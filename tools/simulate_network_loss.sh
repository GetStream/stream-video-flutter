#!/usr/bin/env bash
#
# Cuts the network of a test device for a while, so a call's reconnect paths
# can be checked against a real outage.
#
# Usage:
#   tools/simulate_network_loss.sh <blip|fast|rejoin|giveup|SECONDS> --android [SERIAL]
#   tools/simulate_network_loss.sh <blip|fast|rejoin|giveup|SECONDS> --host
#
# Scenarios:
#   blip     2 s   Shorter than the wait before an ICE restart: a fast
#                  reconnect only if the network monitor notices it.
#   fast     6 s   A fast reconnect, inside the SFU's reconnect window.
#   rejoin   25 s  A rejoin: past the window, the SFU has dropped the
#                  participant.
#   giveup   310 s The call gives up and leaves: past the default
#                  networkAvailabilityTimeout of 5 minutes.
#   SECONDS        Any other duration.
#
# Targets:
#   --android [SERIAL]  An Android device or emulator, through adb. Turns
#                       airplane mode on, or Wi-Fi and mobile data off where
#                       airplane mode cannot be set from the shell.
#   --host              This Mac, for the macOS dogfooding app and the iOS
#                       simulator. Blocks all traffic except loopback with a
#                       pf rule; needs sudo, and the Mac is offline meanwhile.
#
# An iOS device cannot be scripted: use Settings > Developer > Network Link
# Conditioner with the "100% Loss" profile, and time it by hand.
#
# The durations are targets: the network monitor takes a moment to notice an
# outage. The network comes back on exit, including after Ctrl-C.

set -euo pipefail

usage() {
  sed -n '3,32p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

[[ $# -ge 2 ]] || usage

scenario=$1
target=$2
serial=${3:-}

case $scenario in
  blip) seconds=2 expected='no ICE restart' ;;
  fast) seconds=6 expected='a fast reconnect' ;;
  rejoin) seconds=25 expected='a rejoin' ;;
  giveup) seconds=310 expected='the call gives up and leaves' ;;
  *)
    [[ $scenario =~ ^[0-9]+$ ]] || usage
    seconds=$scenario
    expected='depends on the duration'
    ;;
esac

adb_cmd() {
  if [[ -n $serial ]]; then
    adb -s "$serial" shell "$@"
  else
    adb shell "$@"
  fi
}

pf_anchor='com.apple/stream-video-simulate'
pf_token=''
android_mode=''

network_off() {
  case $target in
    --android)
      if adb_cmd cmd connectivity airplane-mode enable >/dev/null 2>&1; then
        android_mode=airplane
      else
        adb_cmd svc wifi disable
        adb_cmd svc data disable
        android_mode=radios
      fi
      ;;
    --host)
      sudo -v
      printf 'block drop quick all\npass quick on lo0 all\n' |
        sudo pfctl -a "$pf_anchor" -f - 2>/dev/null
      pf_token=$(sudo pfctl -E 2>&1 | sed -n 's/^Token : //p')
      ;;
    *) usage ;;
  esac
}

network_on() {
  case $target in
    --android)
      case $android_mode in
        airplane) adb_cmd cmd connectivity airplane-mode disable ;;
        radios)
          adb_cmd svc wifi enable
          adb_cmd svc data enable
          ;;
      esac
      ;;
    --host)
      sudo pfctl -a "$pf_anchor" -F all 2>/dev/null || true
      if [[ -n $pf_token ]]; then
        sudo pfctl -X "$pf_token" 2>/dev/null || true
      fi
      ;;
  esac
  echo 'Network back on.'
}

case $target in
  --android | --host) ;;
  *) usage ;;
esac

trap network_on EXIT
trap 'exit 130' INT TERM

echo "Network off for ${seconds} s. Expected: ${expected}."
network_off

for ((left = seconds; left > 0; left--)); do
  printf '\r%4d s left ' "$left"
  sleep 1
done
printf '\r'
