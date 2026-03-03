#!/usr/bin/env sh
# home/.config/warwick/plugin/opencode/warwick_load.sh
#
# opencode configuration
# https://github.com/opencode-ai/opencode

opencode_bin="$HOME/.opencode/bin"
if [ -d "$opencode_bin" ]
then
	warwick_verbose "opencode"
	export PATH="$opencode_bin:$PATH"
fi
