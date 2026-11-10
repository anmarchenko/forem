#!/usr/bin/env bash
set -euo pipefail
mode=$(cat .verification/mode)
nohup python3 .verification/backend.py > /tmp/ddtest-verification-backend.log 2>&1 < /dev/null &
for attempt in $(seq 1 30); do curl -fsS http://127.0.0.1:5267/ >/dev/null && break; sleep 1; done
if [ -n "${CIRCLECI:-}" ]; then
  curl -fsSL https://go.dev/dl/go1.27.3.linux-amd64.tar.gz -o /tmp/ddtest-go.tar.gz
  mkdir -p /tmp/ddtest-go
  tar -xzf /tmp/ddtest-go.tar.gz -C /tmp/ddtest-go
  export PATH="/tmp/ddtest-go/go/bin:$PATH"
fi
mkdir -p /tmp/ddtest-pr-source
git -C /tmp/ddtest-pr-source init -q
git -C /tmp/ddtest-pr-source remote add origin https://github.com/DataDog/ddtest.git
git -C /tmp/ddtest-pr-source fetch -q --depth=1 origin fee78e61a6497419570af2b1d13e528f2f3e96a5
git -C /tmp/ddtest-pr-source checkout -q FETCH_HEAD
mkdir -p bin
(cd /tmp/ddtest-pr-source && go build -ldflags='-s -w' -o "$OLDPWD/bin/ddtest" .)
git -C /tmp/ddtest-pr-source rev-parse HEAD
if [ "$mode" = "discovery-failure" ]; then printf 'def broken(:\n' > tests/test_first.py; printf 'def broken(:\n' > tests/test_second.py; fi
if [ "$mode" = "output-failure" ]; then
  if [ -n "${CIRCLECI:-}" ]; then mkdir -p .testoptimization/circleci/parameters.json; else export GITHUB_OUTPUT="$PWD/.verification/blocked-output"; mkdir -p "$GITHUB_OUTPUT"; fi
fi
