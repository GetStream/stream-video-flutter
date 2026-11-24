// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

/// Reports the test coverage of a pull request's changed lines, and the
/// coverage of the whole branch against its trunk, `main` or `v2`.
///
/// Reads the `lcov.info` of every package under `packages/`, drops the paths
/// listed under `ignore:` in `codecov.yml`, and diffs `HEAD` against the merge
/// base with `--base`, the pull request's target branch. `--trunk` defaults to
/// `--base`; a stacked pull request passes the trunk its stack starts from.
/// The trunk's coverage comes from `--base-total`, a file an earlier
/// `--save-total` run on the trunk wrote, or else from Codecov, which stores it
/// for every uploaded commit.
///
/// Writes a markdown report to `--output`, and exits with 1 when the changed
/// lines are covered less than the trunk as a whole.
///
/// ```bash
/// dart tools/coverage_report.dart --base origin/feat/x --trunk origin/v2 --base-total total.json --output coverage.md
/// dart tools/coverage_report.dart --save-total total.json
/// ```
Future<void> main(List<String> args) async {
  final options = _parseArgs(args);
  final base = options['base'] ?? 'origin/main';
  final trunk = options['trunk'] ?? base;
  final output = options['output'];

  final ignore = _readIgnoreGlobs(File('codecov.yml'));
  final coverage = _readCoverage(Directory('packages'), ignore);
  final head = _totalCoverage(coverage);

  if (options['save-total'] case final path?) {
    _saveTotal(File(path), head);
    return;
  }

  final changed = _changedLines(base);
  final patch = _patchCoverage(coverage, changed);
  final baseCoverage =
      _readTotal(options['base-total']) ?? await _baseCoverage(trunk);

  final report = _report(
    patch: patch,
    head: head,
    base: baseCoverage,
    trunk: trunk.replaceFirst('origin/', ''),
  );
  print(report.markdown);
  if (output != null) File(output).writeAsStringSync(report.markdown);

  if (!report.passed) exit(1);
}

Map<String, String> _parseArgs(List<String> args) {
  final options = <String, String>{};
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i].startsWith('--')) options[args[i].substring(2)] = args[++i];
  }
  return options;
}

/// The `ignore:` globs from codecov.yml, as regular expressions.
List<RegExp> _readIgnoreGlobs(File file) {
  if (!file.existsSync()) return const [];
  final globs = <RegExp>[];
  var inIgnore = false;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('ignore:')) {
      inIgnore = true;
    } else if (inIgnore && line.trimLeft().startsWith('- ')) {
      final glob = line.trim().substring(2).replaceAll('"', '').trim();
      globs.add(_globToRegExp(glob));
    } else if (inIgnore && line.isNotEmpty && !line.startsWith(' ')) {
      inIgnore = false;
    }
  }
  return globs;
}

RegExp _globToRegExp(String glob) {
  final pattern = RegExp.escape(glob)
      .replaceAll(r'\*\*', '\u0000')
      .replaceAll(r'\*', '[^/]*')
      .replaceAll('\u0000', '.*');
  return RegExp('^$pattern\$');
}

/// Hit counts per line, keyed by repository-relative path.
Map<String, Map<int, int>> _readCoverage(
  Directory packages,
  List<RegExp> ignore,
) {
  final coverage = <String, Map<int, int>>{};
  if (!packages.existsSync()) return coverage;

  for (final package in packages.listSync().whereType<Directory>()) {
    final lcov = File('${package.path}/coverage/lcov.info');
    if (!lcov.existsSync()) continue;

    Map<int, int>? lines;
    for (final line in lcov.readAsLinesSync()) {
      if (line.startsWith('SF:')) {
        final path = '${package.path}/${line.substring(3)}'.replaceFirst(
          RegExp(r'^\./'),
          '',
        );
        final ignored = ignore.any((glob) => glob.hasMatch(path));
        lines = ignored ? null : coverage.putIfAbsent(path, () => {});
      } else if (line.startsWith('DA:') && lines != null) {
        final [number, hits, ...] = line.substring(3).split(',');
        final lineNumber = int.parse(number);
        lines[lineNumber] = (lines[lineNumber] ?? 0) + int.parse(hits);
      } else if (line == 'end_of_record') {
        lines = null;
      }
    }
  }
  return coverage;
}

/// Lines added or changed since the merge base with [base], per path.
Map<String, Set<int>> _changedLines(String base) {
  final mergeBase = _git(['merge-base', base, 'HEAD']).trim();
  final diff = _git([
    'diff',
    '--unified=0',
    '--no-color',
    '--no-renames',
    mergeBase,
    'HEAD',
    '--',
    'packages',
  ]);

  final changed = <String, Set<int>>{};
  Set<int>? lines;
  final hunk = RegExp(r'^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@');
  for (final line in const LineSplitter().convert(diff)) {
    if (line.startsWith('+++ ')) {
      final path = line.substring(4);
      lines = path == '/dev/null'
          ? null
          : changed.putIfAbsent(path.substring(2), () => {});
    } else if (lines != null) {
      final match = hunk.firstMatch(line);
      if (match == null) continue;
      final start = int.parse(match.group(1)!);
      final count = int.parse(match.group(2) ?? '1');
      for (var i = 0; i < count; i++) {
        lines.add(start + i);
      }
    }
  }
  return changed;
}

String _git(List<String> args) {
  final result = Process.runSync('git', args);
  if (result.exitCode != 0) {
    stderr.writeln('git ${args.join(' ')} failed: ${result.stderr}');
    exit(2);
  }
  return result.stdout as String;
}

class _Patch {
  _Patch(this.hits, this.lines, this.uncovered);

  final int hits;
  final int lines;

  /// Changed lines no test runs, per path.
  final Map<String, List<int>> uncovered;

  double? get percent => lines == 0 ? null : hits * 100 / lines;
}

_Patch _patchCoverage(
  Map<String, Map<int, int>> coverage,
  Map<String, Set<int>> changed,
) {
  var hits = 0;
  var lines = 0;
  final uncovered = <String, List<int>>{};
  for (final MapEntry(key: path, value: changedLines) in changed.entries) {
    final fileCoverage = coverage[path];
    if (fileCoverage == null) continue;
    for (final line in changedLines.toList()..sort()) {
      final lineHits = fileCoverage[line];
      if (lineHits == null) continue;
      lines++;
      if (lineHits > 0) {
        hits++;
      } else {
        uncovered.putIfAbsent(path, () => []).add(line);
      }
    }
  }
  return _Patch(hits, lines, uncovered);
}

double? _totalCoverage(Map<String, Map<int, int>> coverage) {
  var hits = 0;
  var lines = 0;
  for (final file in coverage.values) {
    lines += file.length;
    hits += file.values.where((h) => h > 0).length;
  }
  return lines == 0 ? null : hits * 100 / lines;
}

class _BaseCoverage {
  const _BaseCoverage(this.sha, this.percent, this.source);

  final String sha;
  final double percent;
  final String source;
}

/// Writes this commit's total coverage, for pull requests into its branch.
void _saveTotal(File file, double? total) {
  if (total == null) {
    stderr.writeln('No coverage to save.');
    exit(2);
  }
  final sha = _git(['rev-parse', 'HEAD']).trim();
  file.writeAsStringSync(jsonEncode({'sha': sha, 'coverage': total}));
  print('Saved ${total.toStringAsFixed(2)}% for $sha to ${file.path}');
}

/// The total a `--save-total` run wrote to [path], if there is one.
_BaseCoverage? _readTotal(String? path) {
  if (path == null) return null;
  final file = File(path);
  if (!file.existsSync()) return null;
  try {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    return _BaseCoverage(
      json['sha'] as String,
      (json['coverage'] as num).toDouble(),
      'cache',
    );
  } on FormatException catch (e) {
    stderr.writeln('Ignoring unreadable ${file.path}: $e');
    return null;
  }
}

/// The coverage Codecov stored for the newest commit on [base] that has one,
/// starting at the merge base. Null when Codecov can't be reached or has none.
Future<_BaseCoverage?> _baseCoverage(String base) async {
  final repository =
      Platform.environment['GITHUB_REPOSITORY'] ??
      'GetStream/stream-video-flutter';
  final [owner, repo] = repository.toLowerCase().split('/');
  final mergeBase = _git(['merge-base', base, 'HEAD']).trim();
  final candidates = const LineSplitter().convert(
    _git(['rev-list', '--first-parent', '--max-count=20', mergeBase]),
  );

  final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
  try {
    for (final sha in candidates) {
      final uri = Uri.https(
        'api.codecov.io',
        '/api/v2/github/$owner/repos/$repo/commits/$sha/',
      );
      try {
        final request = await client.getUrl(uri);
        final response = await request.close();
        final body = await response.transform(utf8.decoder).join();
        if (response.statusCode != 200) continue;
        final json = jsonDecode(body) as Map<String, dynamic>;
        final totals = json['totals'] as Map<String, dynamic>?;
        final percent = totals?['coverage'] as num?;
        if (json['state'] == 'complete' && percent != null) {
          return _BaseCoverage(sha, percent.toDouble(), 'Codecov');
        }
      } on Exception catch (e) {
        stderr.writeln('Codecov request for $sha failed: $e');
        return null;
      }
    }
    return null;
  } finally {
    client.close();
  }
}

class _Report {
  const _Report(this.markdown, {required this.passed});

  final String markdown;
  final bool passed;
}

_Report _report({
  required _Patch patch,
  required double? head,
  required _BaseCoverage? base,
  required String trunk,
}) {
  String pct(double? value) =>
      value == null ? 'n/a' : '${value.toStringAsFixed(2)}%';

  final patchPercent = patch.percent;
  final passed =
      patchPercent == null || base == null || patchPercent >= base.percent;

  final delta = head != null && base != null ? head - base.percent : null;
  final deltaText = delta == null
      ? ''
      : ' (${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(2)}%)';

  final buffer = StringBuffer()
    ..writeln('<!-- coverage-report -->')
    ..writeln('## Coverage')
    ..writeln()
    ..writeln('| | Coverage |')
    ..writeln('|---|---|')
    ..writeln(
      '| Changed lines | ${pct(patchPercent)} '
      '(${patch.hits}/${patch.lines} lines) |',
    )
    ..writeln('| This branch | ${pct(head)}$deltaText |')
    ..writeln(
      base == null
          ? '| `$trunk` | unknown: not in the cache or Codecov |'
          : '| `$trunk` | ${pct(base.percent)} '
                '(${base.sha.substring(0, 9)}, from ${base.source}) |',
    )
    ..writeln();

  if (patchPercent == null) {
    buffer.writeln('None of the changed lines is in the coverage report.');
  } else if (base == null) {
    buffer.writeln('The coverage of `$trunk` is unknown, so nothing fails.');
  } else if (passed) {
    buffer.writeln(
      '✅ Changed lines are covered at least as well as `$trunk`.',
    );
  } else {
    buffer.writeln(
      '❌ Changed lines are covered less than `$trunk` '
      '(${pct(base.percent)}).',
    );
  }

  if (patch.uncovered.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('<details><summary>Uncovered changed lines</summary>')
      ..writeln();
    for (final MapEntry(key: path, value: lines) in patch.uncovered.entries) {
      buffer.writeln('- `$path`: ${_ranges(lines)}');
    }
    buffer
      ..writeln()
      ..writeln('</details>');
  }

  return _Report(buffer.toString(), passed: passed);
}

/// `[1, 2, 3, 7]` as `1-3, 7`.
String _ranges(List<int> lines) {
  final ranges = <String>[];
  var start = lines.first;
  var end = start;
  for (final line in lines.skip(1)) {
    if (line == end + 1) {
      end = line;
      continue;
    }
    ranges.add(start == end ? '$start' : '$start-$end');
    start = end = line;
  }
  ranges.add(start == end ? '$start' : '$start-$end');
  return ranges.join(', ');
}
