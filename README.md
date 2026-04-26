# dotfiles

Personal development environment for DevOps/SRE work. Portable across macOS and WSL.

## What's Included

| File | Purpose |
|------|---------|
| `shell/.zshrc` | Main shell config — oh-my-zsh, plugins, portable PATH |
| `shell/aliases.zsh` | kubectl, docker, git, AWS, terraform, SSH aliases |
| `shell/functions.zsh` | Helper functions (klogs, kshell, dshell, extract, etc.) |
| `shell/fzf.zsh` | Fuzzy finder config + DevOps integrations (fkl, fke, fco, etc.) |
| `git/.gitconfig` | Git aliases, rebase-on-pull, safe force push, diff3 conflicts |
| `git/.gitignore_global` | System/editor files to never commit |
| `tmux/.tmux.conf` | Ctrl+a prefix, mouse support, intuitive splits, status bar |
| `nvim/init.lua` | Minimal neovim for YAML/config editing |
| `Brewfile` | All tools to install via `brew bundle` (macOS) |

## Install

```bash
git clone https://github.com/mithologic/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

The installer will:
- Back up existing dotfiles to `~/.dotfiles_backup/`
- Install oh-my-zsh, Powerlevel10k, zsh plugins
- Install DevOps toolkit (fzf, bat, eza, ripgrep, fd, jq, yq, lazygit, lazydocker, k9s, btop, tmux, neovim, etc.)
- Create symlinks from `~/.dotfiles/` to the right locations

On macOS uses `brew bundle`, on WSL/Linux uses `apt` + GitHub releases.

## Post-Install

1. **Restart terminal** or `source ~/.zshrc`
2. **Configure Powerlevel10k**: run `p10k configure`
   - Add `kubecontext` and `aws` segments to your right prompt
3. **Set up Git for work** (optional): uncomment `[includeIf]` in `.gitconfig`

## Tools Installed

### Modern Unix Replacements

| Classic | Modern | Alias |
|---------|--------|-------|
| `cat` | `bat` | `cat` (auto-aliased) |
| `ls` | `eza` | `ls`, `ll`, `tree` (auto-aliased) |
| `grep` | `ripgrep` | `grep` (auto-aliased) |
| `find` | `fd` | `find` (auto-aliased) |
| `top` | `btop` | `top` (auto-aliased) |
| `du` | `ncdu` | `dua` |

### TUI Apps

| Command | Tool | Purpose |
|---------|------|---------|
| `lg` | lazygit | Git visual interface |
| `lzd` | lazydocker | Docker visual interface |
| `kk` | k9s | Kubernetes dashboard in terminal |
| `btop` | btop | System monitor |

### fzf Key Bindings (built-in)

| Keybinding | Action |
|------------|--------|
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy find files |
| `Alt+C` | Fuzzy cd into directories |

### fzf DevOps Commands

| Command | Action |
|---------|--------|
| `fkl` | Fuzzy select pod → follow logs |
| `fke` | Fuzzy select pod → exec shell |
| `fkns` | Fuzzy switch k8s namespace |
| `fkx` | Fuzzy switch k8s context |
| `fkd` | Fuzzy select pod → describe |
| `fco` | Fuzzy checkout git branch |
| `flog` | Fuzzy browse git log |
| `fga` | Fuzzy stage git files |
| `fstash` | Fuzzy apply git stash |
| `fdl` | Fuzzy select container → logs |
| `fde` | Fuzzy select container → shell |
| `fssh` | Fuzzy select SSH host |
| `faws` | Fuzzy switch AWS profile |
| `fe` | Fuzzy open file in nvim |
| `fkill` | Fuzzy kill process |

## Key Aliases

```
k       = kubectl           gs      = git status -sb
kgp     = kubectl get pods   gc      = git commit -m
kex     = kubectl exec -it   gpu     = git push -u origin <current>
kdebug  = run debug pod      d       = docker
kns     = switch namespace   dps     = docker ps (formatted)
tf      = terraform          awswho  = aws sts get-caller-identity
```

## tmux Cheatsheet

```
Prefix = Ctrl+a

Ctrl+a |     Split vertical       Alt+arrows    Navigate panes
Ctrl+a -     Split horizontal     Shift+arrows  Navigate windows
Ctrl+a c     New window           Ctrl+a d      Detach session
Ctrl+a L     Ops layout           Ctrl+a r      Reload config
```

## Structure

```
~/.dotfiles/
├── install.sh
├── Brewfile
├── README.md
├── shell/
│   ├── .zshrc
│   ├── aliases.zsh
│   ├── functions.zsh
│   └── fzf.zsh
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── tmux/
│   └── .tmux.conf
└── nvim/
    └── init.lua
```
