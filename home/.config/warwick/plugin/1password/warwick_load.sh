# home/.config/warwick/plugin/1password/warwick_load.sh
# 1Password CLI - bridges to the Windows desktop app on WSL
#
# The Linux `op` binary cannot talk to the Windows 1Password desktop app,
# so on WSL we alias `op` to `op.exe` shipped with the WinGet install.
# Caveat: `op run` and shell plugins do not work through this bridge.

if [ -z "$WSL_HOME" ]
then
	return 0
fi

OP_WIN_DIR="/mnt/c/Users/augus/AppData/Local/Microsoft/WinGet/Packages/AgileBits.1Password.CLI_Microsoft.Winget.Source_8wekyb3d8bbwe"
if [ ! -d "$OP_WIN_DIR" ]
then
	return 0
fi

warwick_verbose "1Password (op.exe)"

export PATH="$PATH:$OP_WIN_DIR"
alias op=op.exe
