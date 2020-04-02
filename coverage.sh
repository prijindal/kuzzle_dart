#!/bin/sh
mkdir coverage
dart --pause-isolates-on-exit --enable_asserts --enable-vm-service test/.test_coverage.dart > dart-output.txt &
sleep 30
observatory_line=`grep "Observatory listening on http://127.0.0.1:" dart-output.txt`
uri_value=${observatory_line#*Observatory listening on }
echo $uri_value
pub run coverage:collect_coverage --uri="$uri_value" -o coverage/coverage.json --resume-isolates
pub run coverage:format_coverage -l --packages=$(pwd)/.packages -i coverage/coverage.json --report-on=lib -o coverage/lcov.info
curl -s https://codecov.io/bash > coverage/.codecov
sed -i -e 's/TRAVIS_.*_VERSION/^TRAVIS_.*_VERSION=/' coverage/.codecov
chmod +x coverage/.codecov
./coverage/.codecov

killall dart
wait