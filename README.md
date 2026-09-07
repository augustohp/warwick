# Warwick

Personal terminal configuration managed as a [Homeshick][] castle. It provides
shared shell behavior, platform profiles, Git settings, tmux, Starship, and
small command-line utilities.

Vim and Neovim configuration lives separately in [warwick-vim][]. Reusable AI
tooling lives in [warwick-llm][]. Work and consulting configuration stays in
private, identity-specific castles.

## Install

Install Homeshick, load it in the current shell, then clone this castle:

```sh
git clone https://github.com/andsens/homeshick.git "$HOME/.homesick/repos/homeshick"
. "$HOME/.homesick/repos/homeshick/homeshick.sh"
homeshick clone git@github.com:augustohp/warwick.git
```

Homeshick links files under `home/` to the equivalent paths under `$HOME`.
Inspect local changes with
`git -C "$HOME/.homesick/repos/warwick" status --short`, check synchronization
with the remote using `homeshick check warwick`, and refresh links with
`homeshick link warwick`.

The configuration supports macOS, WSL2, headless Linux, and Raspberry Pi/ARM
Linux. Platform-specific behavior is capability-gated; shell startup should not
require every optional tool.

## Repository layout

| Path | Responsibility |
| --- | --- |
| `home/.bash_profile` | Shared shell startup orchestration |
| `home/.bash_profile_*` | Platform-specific setup |
| `home/.bash_environment` | Interactive shell preferences and aliases |
| `home/.config/warwick/plugin/` | Capability-oriented shell modules |
| `home/.config/tmux/` | tmux configuration |
| `home/.config/starship.toml` | Prompt configuration |
| `home/.gitconfig` | Shared Git defaults |
| `home/bin/` | Small user commands |

This is a personal environment published for reference. It is not a supported
distribution; review scripts before linking them into your home directory.

[Homeshick]: https://github.com/andsens/homeshick
[warwick-vim]: https://github.com/augustohp/warwick-vim
[warwick-llm]: https://github.com/augustohp/warwick-llm
