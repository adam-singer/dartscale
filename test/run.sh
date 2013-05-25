#! /bin/sh
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dart $SCRIPTPATH/test/testMessageSubscription.dart
dart $SCRIPTPATH/test/testModuleLifecyle.dart

