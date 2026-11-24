// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

/// Reports the test coverage of a pull request's changed lines, and the
/// coverage of the whole branch against its target branch.
///
/// Reads the `lcov.info` of every package under `packages/`, drops the paths
/// listed under `ignore:` in `codecov.yml`, and diffs `HEAD` against the merge
/// base with the target branch. The target branch's coverage comes from
/// Codecov, which stores it for every uploaded commit.
///
/// Writes a markdown report to `--output`, and exits with 1 when the changed
/// lines are covered less than the target branch as a whole.
///
/// ```bash
/// dart tools/coverage_report.dart --base origin/v2 --output coverage.md
/// ```
Future<void> main(List<String> args) async {
  final options = _parseArgs(args);
  final base = options['base'] ?? 'origin/main';
  final output = options['output'];

  final ignore = _readIgnoreGlobs(File('codecov.yml'));
  final coverage = _readCoverage(Directory('packages'), ignore);
  final changed = _changedLines(base);

  final patch = _patchCoverage(coverage, changed);
  final head = _totalCoverage(coverage);
  final baseCoverage = await _baseCoverage(base);

  final report = _report(
    patch: patch,
    head: head,
    base: baseCoverage,
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
  const _BaseCoverage(this.sha, this.percent);

  final String sha;
  final double percent;
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
          return _BaseCoverage(sha, percent.toDouble());
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
          ? '| Target branch | unknown: Codecov has no coverage for it |'
          : '| Target branch | ${pct(base.percent)} '
                '(${base.sha.substring(0, 9)}) |',
    )
    ..writeln();

  if (patchPercent == null) {
    buffer.writeln('None of the changed lines is in the coverage report.');
  } else if (base == null) {
    buffer.writeln('The target branch coverage is unknown, so nothing fails.');
  } else if (passed) {
    buffer.writeln(
      '✅ Changed lines are covered at least as well as the target branch.',
    );
  } else {
    buffer.writeln(
      '❌ Changed lines are covered less than the target branch '
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
