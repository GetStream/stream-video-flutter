#!/usr/bin/env python3
"""Log digest for a smoke-test run — called by report.sh.

The checks only grep for the lines they need, so a run can pass while the logs
show something wrong: a cleartext frame on an encrypted call went unreported
exactly that way. This reads every SDK warning/error line (and every app crash)
from both logs, groups repeats into one entry, and sorts each group into one of:

  UNEXPLAINED  — not in log_noise.tsv. These are what a human should read.
  EXPECTED     — matched a log_noise.tsv rule, shown collapsed with its reason.

It never fails the run: it is evidence, not an assertion. When an UNEXPLAINED
entry turns out to be benign, add a rule for it to log_noise.tsv (with the
reason) instead of teaching anyone to ignore the digest.

usage: log_digest.py <android.log> <ios.log> <log_noise.tsv> <env.sh>
"""
import re
import sys
from datetime import datetime, timedelta

ANDROID_LOG, IOS_LOG, NOISE_TSV, ENV_SH = sys.argv[1:5]

# The SDK's own timestamp. Both platforms print it at the start of the payload;
# logcat prefixes it with its own, which is dropped so the payload is the same
# line on both platforms — and so lines logcat captured twice dedupe.
SDK_TS = re.compile(r'(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)\.\d+ ')
SDK_LEVEL = re.compile(r'\((E|W)/([^)]+)\): ?(.*)')
# App-level failures that are not SDK log calls. Kept narrow on purpose: the
# emulator's own system logs are full of exceptions that say nothing about us.
# Flutter prints the full EXCEPTION CAUGHT BY block only for the first error
# after start or hot reload; every later one is a single "Another exception was
# thrown" line. Logcat's threadtime format writes the engine's errors as
# "E flutter :", not "E/flutter".
CRASH = re.compile(
    r'Unhandled Exception|EXCEPTION CAUGHT BY|Another exception was thrown|'
    r'\bE/flutter\b|\sE flutter +:|'
    r'FATAL EXCEPTION|ANR in io\.getstream|Lost connection to device')
LOGCAT_PREFIX = re.compile(r'^\d\d-\d\d \d\d:\d\d:\d\d\.\d+ +\d+ +\d+ ')

# Collapses what differs between repeats of the same message.
NORMALISE = [
    (re.compile(r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'), '<uuid>'),
    (re.compile(r'\b[0-9a-f]{16}\b'), '<id>'),
    (re.compile(r'\d+'), 'N'),
]


def read_env(path):
    env = {}
    try:
        for line in open(path, encoding='utf-8', errors='replace'):
            m = re.match(r'^(?:export )?([A-Z_][A-Z0-9_]*)=(.*)$', line.strip())
            if m:
                env[m.group(1)] = m.group(2).strip('\'"')
    except OSError:
        pass
    return env


def parse_ts(value):
    try:
        return datetime.strptime(value, '%Y-%m-%d %H:%M:%S')
    except (TypeError, ValueError):
        return None


def windows(env):
    """Named time windows a noise rule can be scoped to."""
    out = {}
    start = parse_ts(env.get('RECONNECT_FROM'))
    if start:
        # Without an end (the step died mid-way) assume two minutes. The grace
        # on either side covers clock skew and the SDK's own retry tail.
        end = parse_ts(env.get('RECONNECT_TO')) or start + timedelta(minutes=2)
        out['reconnect'] = (start - timedelta(seconds=5), end + timedelta(seconds=30))
    return out


def load_rules(path):
    rules = []
    for n, line in enumerate(open(path, encoding='utf-8'), 1):
        if not line.strip() or line.startswith('#'):
            continue
        parts = line.rstrip('\n').split('\t')
        if len(parts) != 4:
            sys.exit(f'log_noise.tsv:{n}: expected 4 tab-separated columns, got {len(parts)}')
        platform, scope, pattern, reason = parts
        rules.append((platform, scope, re.compile(pattern), reason))
    return rules


# One line of Flutter's own output on either platform, with the prefix removed.
FLUTTER_LINE = re.compile(r'(?: I flutter +: |^flutter: )(.*)$')
LOGCAT_TIME = re.compile(r'^\d\d-\d\d (\d\d:\d\d:\d\d)')
SOURCE_REF = re.compile(r'(?:file://\S*?/|package:)((?:packages/)?[\w/.]+\.dart:\d+)')


def flutter_error(lines, i):
    """Summarise a FlutterError block starting at lines[i] (the ╡ banner):
    the banner title, the first line of the error itself, and the first source
    location. The banner alone says nothing — "EXCEPTION CAUGHT BY RENDERING
    LIBRARY" covers every layout overflow there is."""
    head = FLUTTER_LINE.search(lines[i])
    title = re.sub(r'[═╡╞]', '', head.group(1) if head else lines[i]).strip()
    message, where, after_thrown = '', '', False
    for raw in lines[i + 1:i + 60]:
        m = FLUTTER_LINE.search(raw)
        if not m:
            continue            # interleaved non-Flutter logcat lines
        text = m.group(1).strip()
        if text and set(text) <= {'═'}:
            break               # closing rule of the block
        if not message and after_thrown and text:
            message = text
        if 'was thrown' in text:
            after_thrown = True
        if not where:
            ref = SOURCE_REF.search(text)
            if ref:
                where = ref.group(1)
    return f'{title}: {message or "?"}' + (f' @ {where}' if where else '')


def entries(path, platform):
    """(time, stamp, level, tag, message) per distinct SDK warning/error or
    crash. `time` is a datetime when the SDK timestamp is there (needed for
    window-scoped rules); `stamp` is always something printable."""
    seen = set()
    try:
        lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
    except OSError as e:
        # Loud, not silent: an empty result reads as a clean run.
        yield None, '?', 'MISSING', platform, f'LOG MISSING: {path} ({e.strerror})'
        return
    if not any(lines):
        yield None, '?', 'MISSING', platform, f'LOG EMPTY: {path}'
        return
    for i, raw in enumerate(lines):
        lvl = SDK_LEVEL.search(raw)
        crash = CRASH.search(raw)
        if not lvl and not crash:
            continue
        ts = SDK_TS.search(raw)
        if lvl:
            payload = raw[ts.start():] if ts else LOGCAT_PREFIX.sub('', raw)
            message = lvl.group(3)
        elif 'EXCEPTION CAUGHT BY' in raw:
            message = flutter_error(lines, i)
            lt = LOGCAT_TIME.search(raw)
            # No SDK timestamp on these; logcat's own is the best there is, and
            # it also keys the dedupe so logcat's repeated capture collapses.
            payload = (lt.group(1) if lt else '') + message
        else:
            payload = LOGCAT_PREFIX.sub('', raw)
            message = payload
        if payload in seen:
            continue
        seen.add(payload)
        when = parse_ts(ts.group(1)) if ts else None
        lt = LOGCAT_TIME.search(raw)
        stamp = when.strftime('%H:%M:%S') if when else (lt.group(1) if lt else '?')
        if lvl:
            yield when, stamp, lvl.group(1), lvl.group(2), message
        else:
            yield when, stamp, 'CRASH', platform, message


def classify(platform, when, level, tag, message, rules, wins):
    # The same shape the log line has, so rules can be written against it.
    text = f'({level}/{tag}): {message}'
    for rule_platform, scope, pattern, reason in rules:
        if rule_platform not in ('any', platform):
            continue
        if scope != 'any':
            win = wins.get(scope)
            if not win or when is None or not (win[0] <= when <= win[1]):
                continue
        if pattern.search(text):
            return reason
    return None


def key(level, tag, message):
    text = f'{level} {tag}: {message}'
    for pattern, repl in NORMALISE:
        text = pattern.sub(repl, text)
    return text[:200]


def main():
    env = read_env(ENV_SH)
    rules = load_rules(NOISE_TSV)
    wins = windows(env)

    unexplained = {}   # (platform, key) -> [count, first, last, sample]
    expected = {}      # (platform, reason) -> count
    totals = {}
    for platform, path in (('android', ANDROID_LOG), ('ios', IOS_LOG)):
        n = 0
        for when, stamp, level, tag, message in entries(path, platform):
            n += 1
            reason = classify(platform, when, level, tag, message, rules, wins)
            if reason:
                expected[(platform, reason)] = expected.get((platform, reason), 0) + 1
                continue
            k = (platform, key(level, tag, message))
            if k not in unexplained:
                unexplained[k] = [0, stamp, stamp, f'{level} {tag}: {message}']
            unexplained[k][0] += 1
            unexplained[k][2] = stamp
        totals[platform] = n

    print('================== LOG DIGEST ==================')
    print('SDK warnings/errors and app crashes, deduplicated. Evidence, not checks.')
    for platform in ('android', 'ios'):
        u = sum(v[0] for (p, _), v in unexplained.items() if p == platform)
        e = sum(c for (p, _), c in expected.items() if p == platform)
        print(f'{platform:8} {totals.get(platform, 0):4} lines: {u} unexplained, {e} expected')
    if 'reconnect' not in wins:
        print('(no reconnect window recorded — network-loss noise is not excused this run)')
    print()
    if unexplained:
        print('UNEXPLAINED — not in log_noise.tsv; read these:')
        for (platform, _), (count, first, last, sample) in sorted(
                unexplained.items(), key=lambda kv: (kv[0][0], kv[1][1])):
            span = first if first == last else f'{first}–{last}'
            print(f'  [{platform}] {count}× {span}  {sample[:240]}')
    else:
        print('UNEXPLAINED — none')
    print()
    if expected:
        print('EXPECTED — matched log_noise.tsv:')
        for (platform, reason), count in sorted(expected.items()):
            print(f'  [{platform}] {count}× {reason}')
    print('=================================================')


if __name__ == '__main__':
    main()
