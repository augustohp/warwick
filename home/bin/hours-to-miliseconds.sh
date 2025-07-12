#!/usr/bin/env sh
#
# Convers hours into miliseconds.
# shellcheck disable=SC3043

set -e
if [ -n "$DEBUG" ]
then
	set -x
fi

APP_NAME="$(basename "$0")"
APP_VERSION="1.0.0"

# Usage: display_help
display_help()
{
	cat <<-EOT
	Usage: $APP_NAME <hours>
	       $APP_NAME --help
	
	Options
	  -h, --help      Displays this help message.
	  -v, --version   Displays version.
	  -x, --debug     Enables debug.

	EOT
}

# Usage: echo "1.0123" | remove_float_precision
remove_float_precision()
{
	sed 's/\.0*$//'
}

# Usage: echo "1/3" | do_math
do_math()
{
	bc -l
}

# Usage: hours_to_milliseconds <hours>
hours_to_milliseconds()
{
    local hours="$1"
    
	if ! echo "$hours" | grep -Eq '^-?[0-9]+\.?[0-9]*$'
	then
        echo "Error: '$hours' is not a valid number"
		return 1
    fi
    
    # Convert hours to milliseconds
    # 1 hour = 60 minutes = 3600 seconds = 3,600,000 milliseconds
    echo "$hours * 3600000" \
		| do_math \
		| remove_float_precision
}

if [ $# -lt 1 ]
then
	echo "Error: Missing hours to convert!"
	exit 2
fi

while [ $# -gt 0 ]
do
	case "$1" in
		-h|--help|help)
			display_help
			exit 1
			;;
		-v|--version)
			echo "$APP_NAME $APP_VERSION"
			exit 1
			;;
		-x|--debug)
			set -x
			;;
		--)
			break	
			;;
		*)
			hours="$1"
			;;
	esac
	shift
done

hours_to_milliseconds "$hours"
