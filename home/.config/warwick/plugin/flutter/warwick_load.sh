#!/usr/bin/env sh
# home/.config/warwick/plugin/flutter/warwick_load.sh
#
# Flutter SDK configuration
# https://flutter.dev

FLUTTER_HOME="$HOME/.local/opt/flutter"

if [ ! -d "$FLUTTER_HOME" ]
then
	return 0
fi

warwick_verbose "Flutter"

export FLUTTER_HOME
export PATH="$FLUTTER_HOME/bin:$PATH"

# Dart SDK bundled with Flutter
if [ -d "$FLUTTER_HOME/bin/cache/dart-sdk/bin" ]
then
	export PATH="$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"
fi
