#!/bin/bash
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dart $SCRIPTPATH/testMessageSubscription.dart
dart $SCRIPTPATH/testModuleLifecyle.dart

