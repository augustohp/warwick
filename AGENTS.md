# Homeshick for AI Agents

Homeshick is a bash-based dotfiles manager that uses git and symlinks to
manage configuration files across machines.

Some Core Concepts:

- **Dotfiles**: Configuration files for shells, editors, and other tools.
- **Git Repositories**: Dotfiles are stored in git repositories for version
  control and easy sharing.
- **Castles**: Dotfile repositories are called "castles". Each castle lives in
  `~/.homesick/repos/CASTLE/` and contains a `home/` directory that mirrors
  `$HOME` structure.
- **Structure**: Files in `castle/home/.bashrc` symlink to `~/.bashrc`.
- [homeshick][] is an alternative compatible with [homesick][]. You can use
  them interchangibly. We **prefer homeshick** for its simplicity.

[Homeshick]: https://github.com/andsens/homeshick) "Simpler alterntive to Homesick."
[Homesick]: https://github.com/technicalpickles/homesick "Original, Ruby, version."

## Essential Commands

- List castles: `homeshick ls`.
- Clone a castle: `homeshick clone <castle>`.
- Link files: `homeshick link [CASTLE]`.
- Track new files: `homeshick track <castle> <file1> [<file2>]...`.
- Update castles: `homeshick pull [CASTLE]`.
- Enter castle directory: `homeshick cd <castle>`.
- Generate new castle: `homeshick generate <castle name>`.

## Common Workflows

### Add persistent shell changes

When implementing shell behavior changes that should persist:

1. Plan which behavior to incorporate.
2. Let user review changes.
1. Choose appropriate castle: `homeshick ls`.
1. Enter castle: `homeshick cd <castle>`.
1. Add/modify files in `home/` directory.
1. Commit and push changes to remote.

### Clone existing setup on new machine

```sh
# Install homeshick first
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source ~/.homesick/repos/homeshick/homeshick.sh

# Clone your castles
homeshick clone user/dotfiles
homeshick link dotfiles
```

### Cloning a castle

You clone repositóries with `homeshick clone <castle>`.

Castles can be:

- GitHub "<owner>/<repo>", for example: "augustohp/warwick".
- A SSH URL: "git@github.com:augustohp/warwick.git".

**Always** prefer to use an **SSH URL**. If a GitHub owner/repo is given,
convert it to `git@github.com:<owner>/<repo>/git`.

### Checking if a castle can be updated

In order for a castle to be updated, it needs to not have any changes into it:

1. Check if there are changes made to the castle with: `git status`.
1. If there is any output, this castle needs to have its changes committed.

### Shallow symlink

By default, Homeshick traverses directories within home/ and creates individual
symlinks for every contained file ("deep linking"). For complex directories with
many files (e.g., .emacs.d, .vim) where granular control is unnecessary, this
behavior is inefficient.​

Homeshick can treat a directory as a single unit by converting it into a symlink
within the castle structure.

Implementation Steps:

1. Relocate: Move the target directory (e.g., .emacs) outside of the home/
   directory in your dotfiles repository (e.g., to the repository root).
1. Link: Create a relative symlink inside the home/ directory that points to the
   relocated directory (e.g., cd home && ln -s ../emacs .emacs).
1. Deploy: When running homeshick link, the tool will detect a symlink in home/
   (instead of a directory) and create a single symlink in $HOME pointing to the
   repository path, skipping deep traversal. ​

Homeshick's linking table dictates that if a resource in home/ is a "Not Directory"
(which includes symlinks to directories), it simply links it; it only recurses
if the resource is a literal directory.
​
### Linking table

homeshick does not blindly symlink everything, instead it uses a carefully crafted
linking strategy to achieve a high level of flexibility without resorting to
configuration files.

The table below shows how homeshick decides what to do in different situations.

`$HOME`/castle            | directory      | not directory
--------------------------|----------------|--------------
**nonexistent**           | `mkdir`        | `link`
**symlink to castle**     | `rm! && mkdir` | `identical`
**file/symlinked file**   | `rm? && mkdir` | `rm? && link`
**directory**             | `identical`    | `rm? && link`
**directory (symlink)**   | `identical`    | `rm? && link`

#### Explanation
homeshick traverses through all *resources* (files, folders and symlinks),
that reside under the `home/` folder of a castle in a depth-first manner.
Symlinks in the castle are not followed.
Conversely: if `$HOME` contains a directory symlink that matches a normal
directory in the castle it will be followed.
The table is consulted for each *resource* that is encountered.
Files or directories that are not tracked by git are ignored and not traversed.

The columns **directory** and **not directory** represent the resource in the castle.
The rows represent what resource is found at the corresponding location in the
actual `$HOME` directory.

In the castle, **directory** is a simple directory (and not a symlink to a directory),
while **not directory** is everything that is not the former (so: files, symlinked
files, and symlinked directories).

The *resources* that can be encounter in the `$HOME` directory are categorized as follows:

- **nonexistent** means that the corresponding *resource* in the `$HOME` folder does not exist.
- **symlink to castle** represents a symlink to the current *resource*
- **file/symlinked file** is a symlink to anything *but* the current *resource*
- **directory** is a regular directory
- **directory (symlink)** is a symlinked directory (but not to the castle)

The actions that can be taken always refer to the `$HOME` directory.
A `&&` means that the second action is only executed if the first one was executed as well.

- `identical`: Do not do anything, resources are identical
- `mkdir`: Create the directory
- `link`: Create a symlink to the resource in the castle
- `rm!`: Delete without prompting (this is only done for legacy directory symlinks)
- `rm?`: Prompt whether the user wants to overwrite the resource
   - `--skip` answers "no" to this.
   - `--force` does the opposite.
   - `--batch` selects the default, which is "no".

## Rules for Agents

- Scripts must work on WSL2, MacOS, and Linux.
- Prefer POSIX, avoid bashisms.
- Check if a castle has no pending changes (`git status`) before updating it.
- Avoid breaking existing setups when updating castles.
- Prefer SSH Urls for castles when possible.
