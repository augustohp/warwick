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

alias ga.="git add ."
alias gca="git commit --amend"
alias gC="git commit"
alias ga.gpf="git add . && git commit --amend --no-edit && git push --force"

alias gp="git pull"
alias gP="git push"
alias gfo="git fetch origin"

alias gbd="git_branch_delete_interactive"



# Usage: git branch | git_clean_branch_prefix
git_clean_branch_prefix () 
{
	sed 's/^[\t \*]*//'
}

##
# Will display all local branches in the current repository
# using `fzf` to choose one among them. Returning only one.
##
# Usage: git_choose_local_branch
git_choose_local_branch ()
{
	git branch \
		| git_clean_branch_prefix \
		| fzf --no-multi --height="15%" --header "Local branches"
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
		| git_clean_branch_prefix
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
		| sed 's/^[ \t]*//'
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

