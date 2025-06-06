#!/usr/bin/env sh
#

if [ -z "$(command -v starship)" ]
then
	return;
fi

warwick_verbose "Starship"

eval "$(starship init bash)"
