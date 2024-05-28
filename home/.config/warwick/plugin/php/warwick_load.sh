# home/.config/warwick/plugin/php/load.sh
# PHP related configuration

warwick_verbose "PHP"

warwick_php_version()
{
	php --version | head -n 1 | awk '{print $2;}'
}

PHP_PATH="$(command -v php)"
if [ -n "$PHP_PATH" ]
then
	PHP_VERSION="$(warwick_php_version)"
	warwick_verbose_inside "PHP ($PHP_VERSION)"
fi

# PHPBrew ----------------------------------------------------------------------
# https://github.com/phpbrew/phpbrew

export PHPBREW_PATH="${HOME}/.phpbrew"
if [ -d "$PHPBREW_PATH" ]
then
	warwick_source "$PHPBREW_PATH/bashrc"
	warwick_verbose_inside "PHPBrew loaded."
fi

