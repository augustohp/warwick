# .config/warwick/plugin/git/warwick_load.sh
# Git

warwick_verbose "Git"

alias g="git"
alias ga="git_add_interactive"
alias gs="git s"
alias gd="git diff"
alias gb="git branch"
alias gmb="git_main_or_master_branch"
alias gcmb="git_checkout_main"
alias gc="git_checkout_interactive"
alias gcr="git_checkout_remote"

alias ga.="git add ."
alias gca="git commit --amend"
alias gC="git commit"
alias ga.gpf="git add . && git commit --amend --no-edit && git push --force"

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
# Usage: git_add_interactive
git_add_interactive ()
{
	local files

	files=$(git_unstaged_files \
		| fzf --multi \
			--layout reverse \
			--border \
			--border-label-pos 2 \
			--border-label "📁 Choosing files ..." \
			--prompt "git add" \
			--header "TAB (selects file) / ENTER (submits) / CTRL-C (quits)" \
			--preview-label "git-diff" \
			--preview-label-pos 2 \
			--preview 'git diff --no-ext-diff --color=always -- {}' )
	for f in $files
	do
		git add "$f"
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
	files=$(git branch \
		| fzf --multi \
			--layout reverse \
			--border \
			--border-label-pos 2 \
			--border-label "📁 Choosing files ..." \
			--prompt "git branch -D" \
			--header "TAB (selects file) / ENTER (submits) / CTRL-C (quits)" \
			--preview-label "git-diff" \
			--preview-label-pos 2 \
			--preview 'git diff --no-ext-diff --color=always -- {}' )

	for f in $files
	do
		git branch -D "$f"
	done
}
