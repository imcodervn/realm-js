#!/bin/bash

set -o pipefail
set -e

PATH="/home/jenkins/.nvm/versions/node/v6.9.1/bin:/opt/android-sdk-linux/platform-tools:$PATH"

# Inform the prepublish script to build Android modules.
REALM_BUILD_ANDROID=1 npm install realm realm-tests

cp ../../src/object-store/tests/query.json node_modules/realm-tests/query-tests.json

echo "Reversing port for physical device"
adb reverse tcp:8081 tcp:8081

react-native run-android

echo "Unlocking device"
adb shell input text 1234 && adb shell input keyevent 66

# sometimes on CI the application is not on the foreground
echo "Starting the Main Activity"
adb shell am start -n io.realm.react.testapp/.MainActivity
