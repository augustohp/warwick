# home/.config/warwick/plugin/javascript/load.sh
# NodeJS related configuration

warwick_verbose "Javascript"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# pnpm
export PNPM_HOME="/home/augustohp/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Node Version Mamager (NVM) ----------------------------------------------------
# https://nodecli.com/nodejs-nvm

export NVM_DIR="$HOME/.nvm"
if [ -f "$NVM_DIR/nvm.sh" ]
then
	warwick_verbose_inside "Loading nvm..."
	warwick_source "$NVM_DIR/nvm.sh"
	warwick_source "$NVM_DIR/bash_completion"
fi
