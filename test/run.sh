#!/bin/bash
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dart $SCRIPTPATH/test_Mediator.dart
dart $SCRIPTPATH/test_Sandbox.dart
dart $SCRIPTPATH/test_Core.dart

