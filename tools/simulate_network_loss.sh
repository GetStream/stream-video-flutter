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
cut_at=$SECONDS
airplane_on=false
wifi_was_on=false
data_was_on=false
wifi_off=false
data_off=false

android_reachable() {
  adb_cmd 'ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1 && echo yes || echo no' |
    grep -q yes
}

host_reachable() {
  curl -s -m 3 -o /dev/null https://captive.apple.com
}

network_off() {
  case $target in
    --android)
      [[ $(adb_cmd settings get global wifi_on | tr -d '\r') != 0 ]] &&
        wifi_was_on=true
      [[ $(adb_cmd settings get global mobile_data | tr -d '\r') != 0 ]] &&
        data_was_on=true

      cut_at=$SECONDS
      if adb_cmd cmd connectivity airplane-mode enable >/dev/null 2>&1; then
        airplane_on=true
        sleep 2
      fi
      # Airplane mode leaves Wi-Fi up where the user turned it back on in
      # airplane mode before, and some builds cannot set it from the shell.
      if ! $airplane_on || android_reachable; then
        if $wifi_was_on; then
          wifi_off=true
          adb_cmd svc wifi disable
        fi
        if $data_was_on; then
          data_off=true
          adb_cmd svc data disable
        fi
        sleep 2
      fi
      if android_reachable; then
        echo 'The device is still online; giving up.' >&2
        exit 1
      fi
      ;;
    --host)
      sudo -v
      # The anchor only applies while the main ruleset refers to it, as the
      # stock /etc/pf.conf does.
      if ! sudo pfctl -s Anchors 2>/dev/null | grep -q 'com.apple'; then
        sudo pfctl -q -f /etc/pf.conf
      fi
      printf 'block drop quick all\npass quick on lo0 all\n' |
        sudo pfctl -q -a "$pf_anchor" -f -
      cut_at=$SECONDS
      pf_token=$(sudo pfctl -E 2>&1 | sed -n 's/^Token : //p')
      if host_reachable; then
        echo 'The Mac is still online; giving up.' >&2
        exit 1
      fi
      ;;
  esac
}

network_on() {
  case $target in
    --android)
      if $airplane_on; then
        adb_cmd cmd connectivity airplane-mode disable || true
      fi
      if $wifi_off; then adb_cmd svc wifi enable || true; fi
      if $data_off; then adb_cmd svc data enable || true; fi
      ;;
    --host)
      sudo pfctl -q -a "$pf_anchor" -F all 2>/dev/null || true
      if [[ -n $pf_token ]]; then
        sudo pfctl -q -X "$pf_token" 2>/dev/null || true
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

# Counted from the cut, so the time spent checking it is part of the outage.
while ((left = seconds - (SECONDS - cut_at), left > 0)); do
  printf '\r%4d s left ' "$left"
  sleep 1
done
printf '\r'
