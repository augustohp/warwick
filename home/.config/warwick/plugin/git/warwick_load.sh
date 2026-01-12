# .config/warwick/plugin/git/warwick_load.sh
# Git

warwick_verbose "Git"

# Configurations
export WARWICK_OPTION_PREFER_GIT_WIN="" # Fill to enable
export WARWICK_OPTION_PREFER_SSH_WIN="" # Fill to enable

# -----------------------------------------------------------------------------
#                                                                   WSL support
# Windows's WSL needs some care to work in a sane way. Using the same GPG and SSH
# keys, for example. Or the same Git configuration between host (Windows) and
# container (WSL).

if [ ! -d "${WSL_HOME}/.ssh" ] && [ -n "$WARWICK_OPTION_PREFER_GIT_WIN" ]
then
	##
	# Copies all SHH folder content from user /home to %UserHome% so Git on Windows
	# has access to the same keys.
	##
	# Usage: warwick_wsl_sync_ssh
	warwick_wsl_sync_ssh()
	{
		WIN_SSH_DIR="${WSL_HOME}/.ssh"
		warwick_verbose_inside "Copying '.ssh' from '${HOME}' to '${WSL_HOME}"
		if [ ! -d "${WIN_SSH_DIR}" ]
		then
			mkdir "${WIN_SSH_DIR}"
		fi
		cp "${HOME}/.ssh/"* "${WIN_SSH_DIR}/"
	}

	# If "%UserHome%/.ssh" doesn't exist, copy it from /home
	warwick_wsl_sync_ssh
fi


##
# Copies Git configuration files from the User's /home directory to %UserHome%
# on Windows.
##
# Usage: warwick_wsl_sync_git
warwick_wsl_sync_git()
{
	for config in "${HOME}"/.git*
	do
		config_filename="$(basename "$config")"
		existing_configuration="${WSL_HOME}/${config_filename}"
		if [ -f "$existing_configuration" ]
		then
			warwick_verbose_inside "Backing up '${existing_configuration}' to '${existing_configuration}.bkp'..."
			mv "${existing_configuration}" "${existing_configuration}.bkp"
		fi
		warwick_verbose_inside "Copying '${config_filename}' from '${HOME}' to '${WSL_HOME}'"
		if [ -d "$config" ]
		then
			cp -r "$config" "${WSL_HOME}/${config_filename}"
		else
			cp "$config" "${WSL_HOME}/${config_filename}"
		fi
	done
}

if [ -n "$WARWICK_OPTION_PREFER_GIT_WIN" ]
then
	##
	# Prefer Windows binary of Git for performance reasons, this will replace any
	# existing `git` command call for `git.exe`. This will cause confusion as the
	# configuration loaded will be the one from the %UserHome%.
	##
	# Usage: git <subcommand> [options]
	git()
	{
		git.exe "$@"
	}

	if [ ! -f "${WSL_HOME}/.gitignore_global" ]
	then
		# If "%UserHome%/.gitignore_global" doesn't exist, copy it from /home
		warwick_wsl_sync_git
	fi

	warwick_wsl_git_motd()
	{
		echo "  Using git.exe with configuration from:"
		git config --list --show-origin \
			| cut -f1 \
			| sed 's/file://' \
			| sort \
			| uniq \
			| sed 's/^/    - /'
	}
	warwick_wsl_git_motd
elif [ -n "$WSL_HOME" ]
then
	# This uses `ssh.exe` when on Windows so the SSH Agent on Windows
	# can communicate with 1password and share/sign with its public and
	# private keys.
	warwick_verbose_inside 'ssh=ssh.exe (1password)'
	alias ssh="ssh.exe"
	alias ssh-add="ssh-add.exe"
fi

# -----------------------------------------------------------------------------
#                                                                       Aliases

alias g="git"
alias ga="git_add_interactive"
alias gr="git_restore_interactive"
alias gs="git s"
alias gd="git diff"
alias gb="git branch"
alias gmb="git_main_or_master_branch"
alias gcmb="git_checkout_main"
alias gc="git_checkout_interactive"
alias gcr="git_checkout_remote"

alias ga.="git add ."
alias gca="git commit --amend --no-edit"
alias gpf="git push --force"
alias g.f="ga. && gca && gpf"
alias gC="git commit"

alias gp="git pull"
alias gP="git push"
alias gfo="git fetch origin"

alias gbd="git_branch_delete_interactive"

wg_trim_leading_whitespaces() { sed 's/^[\t ]*//'; }
wg_remove_leading_star () { sed 's/^[\t \*]*//'; }
wg_filter_remote_branches_without_local_copies () { grep -v ' -> '; }
wg_remove_prefix () { sed "s/^${1}//"; }

##
# Returns current branch of working directory.
##
# Usage: wg_current_branch
wg_current_branch ()
{
	git branch \
		| grep '^* ' \
		| wg_remove_leading_star
}

##
# Will download changes from remote without applying them to anywhere
# and without generating any output.
##
# Usage: wg_fetch_silent
wg_fetch_silent ()
{
	local remote

	remote='origin'
	git fetch "${remote}" > /dev/null 2>&1
}

##
# Will save work on current branch to allow destructive commands.
##
# Usage: wg_stash_silent
wg_stash_silent ()
{
	local current_branch
	local today

	today="$(date +%Y-%m-%d)"
	current_branch="$(wg_current_branch)"

	# Staged changes
	git diff --cached --exit-code > /dev/null || \
		git stash save --quiet --staged "Auto stashed staged changes while on '${current_branch}' at '${today}'."
	# Non staged changes
	git diff --exit-code > /dev/null || \
		git stash save --quiet --all --include-untracked "Auto stashed while on '${current_branch}' at '${today}'."
}

##
# Will display all local branches in the current repository
# using `fzf` to choose one among them. Returning only one.
##
# Usage: git_choose_local_branch
git_choose_local_branch ()
{
	local remote_name
	local main_branch
	remote_name='origin'
	main_branch="$(git_main_or_master_branch)"

	wg_stash_silent
	git branch \
		| wg_remove_leading_star \
		| fzf --no-multi \
			--height="35%" \
			--header "TAB (selects file) / ENTER (submits) / CTRL-C (quits)" \
			--border --border-label-pos 2 --border-label "🪵 Choose local branch to checkout ..." \
			--prompt "git checkout " \
			--preview "git log --oneline ${remote_name}/${main_branch}..{}" \
			--preview-label "Changes from '${main_branch}'" \
			--preview-label-pos 2
}

##
# Displays remote branches, and checks it out.
##
# Usage: git_checkout_remote
git_checkout_remote ()
{
	local remote_name
	local main_branch
	local desired_remote_branch
	remote_name='origin'
	main_branch="$(git_main_or_master_branch)"

	desired_remote_branch=$(
		git branch -r \
		| wg_trim_leading_whitespaces \
		| wg_filter_remote_branches_without_local_copies \
		| fzf --no-multi \
			--header "TAB (selects file) / ENTER (submits) / CTRL-C (quits)" \
			--border --border-label-pos 2 --border-label "📁 Choosing files ..." \
			--prompt "git checkout -b " \
			--preview "git log --oneline ${remote_name}/${main_branch}..{}" \
			--preview-label "Changes from '${main_branch}'" \
			--preview-label-pos 2
		)

	test -z "$desired_remote_branch" && return 1
	wg_stash_silent
	desired_remote_branch="$(echo "${desired_remote_branch}" | wg_remove_prefix "${remote_name}\\/")"
	git checkout -b "${desired_remote_branch}" "${remote_name}/${desired_remote_branch}"
}

##
# Will output "main" or "master", depending on the local branch
# that exists.
##
# Usage: git_main_or_master_branch
git_main_or_master_branch()
{
	git branch \
		| grep -e main -e master \
		| head -n 1 \
		| wg_remove_leading_star
}

##
# Will go to a given branch or display among existing ones
# using `fzf`.
##
# Usage: git_checkout_interactive [branch]
git_checkout_interactive ()
{
	local branch="${1:-}"

	if [ -z "$branch" ]
	then
		branch="$(git_choose_local_branch)"
	fi
	if [ -z "$branch" ]
	then
		return 1
	fi

	wg_stash_silent
	git checkout "$branch"
}

##
# Checkouts to the "main" branch or the repository, which might be
# called "master" depending when the repository was created.
##
# Usage: git_checkout_main [branch]
git_checkout_main ()
{
	local main_branch="${1:-}"

	if [ -z "$main_branch" ]
	then
		main_branch="$(git_main_or_master_branch)"
	fi

	wg_stash_silent
	git checkout "$main_branch"
}

##
# Echos files subject to `git-add`.
##
# Usage: git_unstaged_files
git_unstaged_files ()
{
	# Files with changes
	git status --short \
		| grep -v '^[MARCD]' \
		| awk '{ print $2 }'
	# Renamed files with changes
	git status --short \
		| grep "^RM" \
		| cut -d ">" -f 2 \
		| wg_trim_leading_whitespaces
}

##
# Displays a menu of changed files to be selected and added
# interactively. Uses `fzf`
##
# Usage: git_add_interactive [path1] [path2]...
git_add_interactive ()
{
	local arguments="$@"
	local files

	if [ $# -gt 0 ]
	then
		git add "$arguments"
		return $?
	fi

	files=$(git_unstaged_files \
		| fzf --multi \
			--layout reverse \
			--border \
			--border-label-pos 2 \
			--border-label "📁 Choosing files ..." \
			--prompt "git add" \
			--header "TAB (select file) / ENTER (select current and submit) / CTRL-C (quit)" \
			--preview-label "git-diff" \
			--preview-label-pos 2 \
			--preview 'git diff --no-ext-diff --color=always -- {}' )
	for f in $files
	do
		git add "$f"
	done
}


##
# Displays a menu of changed failes to be selected and
# restored interactively. Uses `fzf`.
##
# Usage: git_restore_interactive
git_restore_interactive ()
{
	local files

	files=$(git_unstaged_files \
		| fzf --multi \
			--layout reverse \
			--border \
			--border-label-pos 2 \
			--border-label "📁 Choosing files ..." \
			--prompt "git restore" \
			--header "TAB (select file) / ENTER (select current and submit) / CTRL-C (quit)" \
			--preview-label "git-diff" \
			--preview-label-pos 2 \
			--preview 'git diff --no-ext-diff --color=always -- {}' )
	for f in $files
	do
		git restore -- "$f"
	done
}

##
# Displays a menu of branches to be selected for deletion.
# Uses `fzf`.
##
# Usage: git_branch_delete_interactive
git_branch_delete_interactive ()
{
	local files
	local main_branch

	main_branch="$(git_main_or_master_branch)"
	current_branch="$(wg_current_branch)"
	files=$(git branch | wg_trim_leading_whitespaces | wg_remove_leading_star \
		| fzf --multi \
			--layout reverse \
			--border \
			--border-label-pos 2 \
			--border-label "✂️  Choose branches to delete ..." \
			--prompt "git branch -D" \
			--header "TAB (selects file) / ENTER (submits) / CTRL-C (quits)" \
			--preview-label "Commits on branch ${current_branch}.." \
			--preview-label-pos 2 \
			--preview 'git log --oneline ${current_branch}..{}' )

	for f in $files
	do
		git branch -D "$f"
	done
}
