#!/bin/sh
mkdir coverage
dart --pause-isolates-on-exit --enable_asserts --enable-vm-service test/.test_coverage.dart &
sleep 10
pub run coverage:collect_coverage --uri=http://127.0.0.1:8181 -o coverage/coverage.json --resume-isolates
pub run coverage:format_coverage -l --packages=$(pwd)/.packages -i coverage/coverage.json --report-on=lib -o coverage/lcov.info

killall dart
wait