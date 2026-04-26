#!/bin/bash
# ============================================================================
# install.sh - Bootstrap dotfiles on any machine (macOS or WSL/Linux)
# Usage: git clone <repo> ~/.dotfiles && cd ~/.dotfiles && ./install.sh
# ============================================================================

set -e

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

echo "================================================"
echo "  Dotfiles Installer - mithologic"
echo "================================================"
echo ""

# --- Detect OS ---
OS="unknown"
if [[ "$(uname)" == "Darwin" ]]; then
    OS="macos"
elif grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
    OS="wsl"
else
    OS="linux"
fi
echo "[INFO] Detected OS: $OS"

# --- Backup existing dotfiles ---
backup_if_exists() {
    local file="$1"
    if [[ -f "$file" || -L "$file" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp -L "$file" "$BACKUP_DIR/" 2>/dev/null || true
        echo "[BACKUP] $file -> $BACKUP_DIR/"
    fi
}

# --- Create symlink (backup first) ---
link_file() {
    local source="$1"
    local target="$2"

    backup_if_exists "$target"
    ln -sf "$source" "$target"
    echo "[LINK] $target -> $source"
}

# --- Install oh-my-zsh if not present ---
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo ""
    echo "[INSTALL] Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Install Powerlevel10k if not present ---
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
    echo "[INSTALL] Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# --- Install zsh plugins ---
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    echo "[INSTALL] zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    echo "[INSTALL] zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# --- Install tools ---
echo ""
echo "[INSTALL] Installing DevOps toolkit..."

if [[ "$OS" == "macos" ]]; then
    # macOS: use Brewfile for everything
    if command -v brew &>/dev/null; then
        echo "[INSTALL] Running brew bundle..."
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    else
        echo "[WARN] Homebrew not found. Install from https://brew.sh and re-run."
    fi
else
    # WSL/Linux: apt for what's available, manual for the rest
    echo "[INSTALL] Installing apt packages..."
    sudo apt-get update
    sudo apt-get install -y \
        tmux neovim fzf bat fd-find ripgrep jq tree wget ncdu htop \
        2>/dev/null || true

    # Fix naming differences on Debian/Ubuntu
    # bat is installed as 'batcat', fd as 'fdfind'
    [[ ! -L "$HOME/.local/bin/bat" ]] && mkdir -p "$HOME/.local/bin" && \
        ln -sf "$(which batcat 2>/dev/null)" "$HOME/.local/bin/bat" 2>/dev/null || true
    [[ ! -L "$HOME/.local/bin/fd" ]] && mkdir -p "$HOME/.local/bin" && \
        ln -sf "$(which fdfind 2>/dev/null)" "$HOME/.local/bin/fd" 2>/dev/null || true

    # Tools not in apt — install via binary releases
    echo "[INSTALL] Installing tools from GitHub releases..."

    # eza (modern ls)
    if ! command -v eza &>/dev/null; then
        echo "  → eza..."
        sudo apt-get install -y gpg 2>/dev/null || true
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null || true
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null 2>/dev/null || true
        sudo apt-get update 2>/dev/null && sudo apt-get install -y eza 2>/dev/null || echo "  [SKIP] eza - install manually"
    fi

    # lazygit
    if ! command -v lazygit &>/dev/null; then
        echo "  → lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*' 2>/dev/null || echo "0.44.1")
        curl -sLo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" 2>/dev/null && \
        tar xzf /tmp/lazygit.tar.gz -C /tmp lazygit 2>/dev/null && \
        sudo install /tmp/lazygit /usr/local/bin/ 2>/dev/null && rm /tmp/lazygit /tmp/lazygit.tar.gz || echo "  [SKIP] lazygit - install manually"
    fi

    # lazydocker
    if ! command -v lazydocker &>/dev/null; then
        echo "  → lazydocker..."
        curl -sL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash 2>/dev/null || echo "  [SKIP] lazydocker - install manually"
    fi

    # k9s
    if ! command -v k9s &>/dev/null; then
        echo "  → k9s..."
        K9S_VERSION=$(curl -s "https://api.github.com/repos/derailed/k9s/releases/latest" | grep -Po '"tag_name": "\K[^"]*' 2>/dev/null || echo "v0.32.5")
        curl -sLo /tmp/k9s.tar.gz "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" 2>/dev/null && \
        tar xzf /tmp/k9s.tar.gz -C /tmp k9s 2>/dev/null && \
        sudo install /tmp/k9s /usr/local/bin/ 2>/dev/null && rm /tmp/k9s /tmp/k9s.tar.gz || echo "  [SKIP] k9s - install manually"
    fi

    # btop
    if ! command -v btop &>/dev/null; then
        echo "  → btop..."
        sudo apt-get install -y btop 2>/dev/null || echo "  [SKIP] btop - install manually"
    fi

    # yq
    if ! command -v yq &>/dev/null; then
        echo "  → yq..."
        sudo wget -qO /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64" 2>/dev/null && \
        sudo chmod +x /usr/local/bin/yq || echo "  [SKIP] yq - install manually"
    fi

    # tldr
    if ! command -v tldr &>/dev/null; then
        echo "  → tldr..."
        pip3 install tldr --break-system-packages 2>/dev/null || \
        sudo apt-get install -y tldr 2>/dev/null || echo "  [SKIP] tldr - install manually"
    fi
fi

# --- Create symlinks ---
echo ""
echo "[SETUP] Creating symlinks..."

# Shell
link_file "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"

# Git
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# Tmux
link_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Neovim
mkdir -p "$HOME/.config/nvim"
link_file "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# --- Create common directories ---
mkdir -p "$HOME/dev" "$HOME/projects"

# --- Summary ---
echo ""
echo "================================================"
echo "  Installation complete!"
echo "================================================"
echo ""
echo "  Backups saved to: $BACKUP_DIR"
echo ""
echo "  Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Run 'p10k configure' to set up your prompt"
echo "     (Add kubecontext and aws segments for ops work)"
echo ""
echo "  Key bindings:"
echo "    Ctrl+R     Fuzzy search command history"
echo "    Ctrl+T     Fuzzy find files"
echo "    Alt+C      Fuzzy cd into directories"
echo ""
echo "  fzf DevOps commands:"
echo "    fkl        Fuzzy select pod → follow logs"
echo "    fke        Fuzzy select pod → exec shell"
echo "    fkns       Fuzzy switch namespace"
echo "    fkx        Fuzzy switch context"
echo "    fco        Fuzzy checkout git branch"
echo "    flog       Fuzzy browse git log"
echo "    fssh       Fuzzy select SSH host"
echo "    faws       Fuzzy switch AWS profile"
echo "    fe         Fuzzy open file in nvim"
echo ""
echo "  TUI apps:"
echo "    lg         lazygit     (git TUI)"
echo "    lzd        lazydocker  (docker TUI)"
echo "    kk         k9s         (kubernetes TUI)"
echo "    btop                   (system monitor)"
echo ""
echo "  tmux Quick Start:"
echo "    tmux new -s work      # New session named 'work'"
echo "    Ctrl+a |              # Split vertical"
echo "    Ctrl+a -              # Split horizontal"
echo "    Alt+arrows            # Navigate panes"
echo "    Shift+arrows          # Navigate windows"
echo "    Ctrl+a d              # Detach (session persists)"
echo "    tmux attach -t work   # Reattach"
echo ""
echo "================================================"
