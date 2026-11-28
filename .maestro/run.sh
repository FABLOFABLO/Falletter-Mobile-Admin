#!/usr/bin/env bash
# Maestro 전체 테스트 실행 스크립트
#   ADMIN_EMAIL=<아이디(@dsm.hs.kr 앞부분)> ADMIN_PASSWORD=<비밀번호> ./.maestro/run.sh [android|ios|all]
# 기기 지정: ANDROID_DEVICE / IOS_DEVICE 환경변수 (기본: 첫 번째 연결 기기)
set -uo pipefail
cd "$(dirname "$0")"
: "${ADMIN_EMAIL:?ADMIN_EMAIL 환경변수가 필요합니다}"
: "${ADMIN_PASSWORD:?ADMIN_PASSWORD 환경변수가 필요합니다}"
export MAESTRO_CLI_NO_ANALYTICS=1 MAESTRO_CLI_ANALYSIS_NOTIFICATION_DISABLED=true
TARGET="${1:-all}"
mkdir -p reports
rc=0

run() { # platform appId device
  local platform=$1 app=$2 device=$3
  echo "▶ $platform ($device)"
  maestro --device "$device" test . \
    -e APP_ID="$app" -e ADMIN_EMAIL="$ADMIN_EMAIL" -e ADMIN_PASSWORD="$ADMIN_PASSWORD" \
    --format junit --output "reports/$platform.xml" \
    --test-output-dir "reports/$platform" || rc=1
}

if [[ $TARGET == android || $TARGET == all ]]; then
  run android com.example.falletter_mobile_admin "${ANDROID_DEVICE:-$(adb devices | awk 'NR==2{print $1}')}"
fi
if [[ $TARGET == ios || $TARGET == all ]]; then
  run ios com.example.falletterMobileAdmin "${IOS_DEVICE:-$(xcrun simctl list devices booted | grep -oE '[0-9A-F-]{36}' | head -1)}"
fi
exit $rc
