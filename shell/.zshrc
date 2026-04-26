# ============================================================================
# .zshrc - Alejandro Zamudio (mithologic)
# Portable dotfiles for macOS + WSL
# ============================================================================

# --- Powerlevel10k Instant Prompt (must stay at top) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- OS Detection ---
export IS_MAC=false
export IS_WSL=false
if [[ "$(uname)" == "Darwin" ]]; then
  export IS_MAC=true
elif grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
  export IS_WSL=true
fi

# --- PATH (portable, no hardcoded usernames) ---
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Homebrew (macOS only)
if [[ "$IS_MAC" == true ]] && [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- pyenv (before Oh My Zsh so the pyenv plugin finds shims) ---
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins — only what you actually use
plugins=(
  git                   # Git aliases (gst, gco, gp, etc.)
  kubectl               # kubectl aliases (k, kgp, kgs, etc.)
  docker                # Docker completions
  aws                   # AWS completions
  ssh-agent             # Auto-start ssh-agent
  virtualenv            # Show active venv
  poetry                # Poetry aliases
  pyenv                 # Pyenv integration
  zsh-autosuggestions   # Fish-like suggestions (install separately)
  zsh-syntax-highlighting  # Syntax coloring (install separately)
)

# ssh-agent config - don't ask passphrase every time
zstyle ':omz:plugins:ssh-agent' quiet yes
zstyle ':omz:plugins:ssh-agent' lazy yes

source $ZSH/oh-my-zsh.sh

# --- History (critical for operations — never lose a command) ---
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS    # No duplicates
setopt HIST_SAVE_NO_DUPS       # Don't save dupes
setopt HIST_REDUCE_BLANKS      # Remove extra spaces
setopt SHARE_HISTORY           # Share between sessions
setopt INC_APPEND_HISTORY      # Write immediately, don't wait for exit
setopt HIST_FIND_NO_DUPS       # Don't show dupes in search

# --- Editor ---
export EDITOR='nvim'
export VISUAL='nvim'

# --- nvm ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- macOS-specific ---
if [[ "$IS_MAC" == true ]]; then
  # Homebrew compiler flags
  if command -v brew &>/dev/null; then
    export LDFLAGS="-L$(brew --prefix)/lib -L$(brew --prefix openssl)/lib"
    export CPPFLAGS="-I$(brew --prefix)/include -I$(brew --prefix openssl)/include"
  fi

  # Docker completions
  [[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)
fi

# --- WSL-specific ---
if [[ "$IS_WSL" == true ]]; then
  # Clipboard integration (copy/paste from terminal)
  alias pbcopy='clip.exe'
  alias pbpaste='powershell.exe -command "Get-Clipboard"'

  # Open files in Windows
  alias open='wslview'
fi

# --- Source modular config files ---
DOTFILES_DIR="$HOME/.dotfiles"

# Source all .zsh files from shell directory
if [[ -d "$DOTFILES_DIR/shell" ]]; then
  for file in "$DOTFILES_DIR/shell"/*.zsh; do
    [[ -f "$file" ]] && source "$file"
  done
fi

# --- Completions ---
autoload -Uz compinit
compinit

# --- Powerlevel10k ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
