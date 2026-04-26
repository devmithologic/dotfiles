# ============================================================================
# fzf.zsh - Fuzzy finder configuration and custom integrations
# ============================================================================

# --- fzf base config ---
if command -v fzf &>/dev/null; then

  # Use fd for file finding if available (respects .gitignore)
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi

  # Theme and appearance
  export FZF_DEFAULT_OPTS="
    --height=60%
    --layout=reverse
    --border=rounded
    --info=inline
    --margin=1
    --padding=1
    --prompt='  '
    --pointer='▶'
    --marker='✓'
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    --bind='ctrl-/:toggle-preview'
    --bind='ctrl-d:preview-half-page-down'
    --bind='ctrl-u:preview-half-page-up'
  "

  # Ctrl+T: find files with preview
  export FZF_CTRL_T_OPTS="
    --preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || cat {}'
    --preview-window='right:60%:wrap'
  "

  # Ctrl+R: search command history
  export FZF_CTRL_R_OPTS="
    --preview 'echo {}'
    --preview-window='up:3:wrap'
  "

  # Alt+C: cd into directories
  export FZF_ALT_C_OPTS="
    --preview 'eza --tree --icons --level=2 --color=always {} 2>/dev/null || ls -la {}'
  "

  # Load fzf keybindings and completion
  # macOS (brew install fzf)
  [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
  # Try the new fzf shell integration (fzf >= 0.48)
  if command -v fzf &>/dev/null; then
    eval "$(fzf --zsh 2>/dev/null)" || true
  fi

  # =========================================================================
  # Custom fzf integrations for DevOps
  # =========================================================================

  # --- Git ---

  # Interactive branch checkout
  fco() {
    local branch
    branch=$(git branch -a --format='%(refname:short)' | fzf --prompt="Branch > " --preview 'git log --oneline -20 {}')
    [[ -n "$branch" ]] && git checkout "$branch"
  }

  # Interactive git log browser
  flog() {
    git log --oneline --color=always | fzf --ansi --no-sort --preview 'git show --color=always {1}' --preview-window='right:60%'
  }

  # Interactive git stash browser
  fstash() {
    local stash
    stash=$(git stash list | fzf --preview 'git stash show -p $(echo {} | cut -d: -f1)' | cut -d: -f1)
    [[ -n "$stash" ]] && git stash pop "$stash"
  }

  # Interactive git add (stage files)
  fga() {
    local files
    files=$(git diff --name-only | fzf --multi --preview 'git diff --color=always {}')
    [[ -n "$files" ]] && echo "$files" | xargs git add && git status -sb
  }

  # --- kubectl ---

  # Interactive pod selector → logs
  fkl() {
    local pod
    pod=$(kubectl get pods --no-headers "${@}" | fzf --prompt="Pod > " --preview 'kubectl describe pod $(echo {} | awk "{print \$1}") | head -40' | awk '{print $1}')
    [[ -n "$pod" ]] && kubectl logs -f "$pod"
  }

  # Interactive pod selector → exec shell
  fke() {
    local pod
    pod=$(kubectl get pods --no-headers "${@}" | fzf --prompt="Pod > " --preview 'kubectl describe pod $(echo {} | awk "{print \$1}") | head -40' | awk '{print $1}')
    [[ -n "$pod" ]] && kubectl exec -it "$pod" -- /bin/sh
  }

  # Interactive namespace switcher
  fkns() {
    local ns
    ns=$(kubectl get ns --no-headers | fzf --prompt="Namespace > " | awk '{print $1}')
    [[ -n "$ns" ]] && kubectl config set-context --current --namespace="$ns" && echo "Switched to: $ns"
  }

  # Interactive context switcher
  fkx() {
    local ctx
    ctx=$(kubectl config get-contexts --no-headers | fzf --prompt="Context > " | awk '{print $2}')
    [[ -n "$ctx" ]] && kubectl config use-context "$ctx"
  }

  # Interactive pod selector → describe
  fkd() {
    local pod
    pod=$(kubectl get pods --no-headers "${@}" | fzf --prompt="Pod > " | awk '{print $1}')
    [[ -n "$pod" ]] && kubectl describe pod "$pod"
  }

  # --- Docker ---

  # Interactive container selector → logs
  fdl() {
    local container
    container=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' | fzf --prompt="Container > " | awk '{print $1}')
    [[ -n "$container" ]] && docker logs -f "$container"
  }

  # Interactive container selector → shell
  fde() {
    local container
    container=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' | fzf --prompt="Container > " | awk '{print $1}')
    [[ -n "$container" ]] && docker exec -it "$container" /bin/sh
  }

  # Interactive image selector → remove
  fdri() {
    local images
    images=$(docker images --format '{{.Repository}}:{{.Tag}}\t{{.Size}}' | fzf --multi --prompt="Remove images > ")
    [[ -n "$images" ]] && echo "$images" | awk '{print $1}' | xargs docker rmi
  }

  # --- SSH ---

  # Interactive SSH host selector (from ~/.ssh/config)
  fssh() {
    local host
    host=$(grep "^Host " ~/.ssh/config 2>/dev/null | awk '{print $2}' | grep -v '\*' | fzf --prompt="SSH > ")
    [[ -n "$host" ]] && ssh "$host"
  }

  # --- AWS ---

  # Interactive AWS profile switcher
  faws() {
    local profile
    profile=$(aws configure list-profiles 2>/dev/null | fzf --prompt="AWS Profile > ")
    [[ -n "$profile" ]] && export AWS_PROFILE="$profile" && echo "AWS_PROFILE=$profile"
  }

  # --- General ---

  # Interactive process killer
  fkill() {
    local pid
    pid=$(ps aux | fzf --prompt="Kill > " --header="Select process to kill" | awk '{print $2}')
    [[ -n "$pid" ]] && kill -9 "$pid" && echo "Killed PID: $pid"
  }

  # Interactive file opener in nvim
  fe() {
    local file
    file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || cat {}')
    [[ -n "$file" ]] && nvim "$file"
  }

fi
