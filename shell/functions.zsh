# ============================================================================
# functions.zsh - Operations utility functions
# ============================================================================

# --- kubectl helpers ---

# Quick switch namespace and confirm
unalias kns 2>/dev/null
kns() {
  kubectl config set-context --current --namespace="$1"
  echo "Switched to namespace: $1"
}

# Get all resources in a namespace
kall() {
  local ns="${1:-default}"
  echo "=== Resources in namespace: $ns ==="
  kubectl get all -n "$ns"
}

# Watch pods (refreshes every 2s)
kwatch() {
  kubectl get pods "${@}" -w
}

# Get pod logs by partial name match
klogs() {
  local pod=$(kubectl get pods --no-headers | grep "$1" | head -1 | awk '{print $1}')
  if [[ -n "$pod" ]]; then
    kubectl logs -f "$pod" "${@:2}"
  else
    echo "No pod found matching: $1"
  fi
}

# Exec into pod by partial name match
kshell() {
  local pod=$(kubectl get pods --no-headers | grep "$1" | head -1 | awk '{print $1}')
  if [[ -n "$pod" ]]; then
    kubectl exec -it "$pod" -- "${2:-/bin/sh}"
  else
    echo "No pod found matching: $1"
  fi
}

# --- Docker helpers ---

# Shell into a running container by partial name
dshell() {
  local container=$(docker ps --format '{{.Names}}' | grep "$1" | head -1)
  if [[ -n "$container" ]]; then
    docker exec -it "$container" "${2:-/bin/sh}"
  else
    echo "No running container matching: $1"
  fi
}

# Show container resource usage
dstats() {
  docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" --no-stream
}

# --- SSH helpers ---

# SSH with tmux auto-attach (creates or reattaches to session)
ssht() {
  ssh "$@" -t 'tmux attach || tmux new-session'
}

# --- Git helpers ---

# Create branch, push, and set upstream in one command
gnew() {
  git checkout -b "$1" && git push -u origin "$1"
}

# Quick commit with conventional format
gcom() {
  local type="$1"
  local msg="$2"
  if [[ -z "$type" || -z "$msg" ]]; then
    echo "Usage: gcom <type> <message>"
    echo "Types: feat, fix, docs, refactor, style, chore, test"
    return 1
  fi
  git commit -m "${type}: ${msg}"
}

# Show what changed in last N commits
gshow() {
  git log --oneline --stat -"${1:-5}"
}

# --- General helpers ---

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.tar.xz)  tar xJf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick HTTP server (Python)
serve() {
  local port="${1:-8000}"
  echo "Serving on http://localhost:$port"
  python3 -m http.server "$port"
}

# Show PATH entries, one per line
showpath() {
  echo "$PATH" | tr ':' '\n' | nl
}

# Find process by name
psfind() {
  ps aux | grep -i "$1" | grep -v grep
}

# Quick note to a scratchpad
note() {
  local notefile="$HOME/.notes.md"
  if [[ -z "$1" ]]; then
    cat "$notefile" 2>/dev/null || echo "No notes yet."
  else
    echo "- $(date '+%Y-%m-%d %H:%M') | $*" >> "$notefile"
    echo "Note saved."
  fi
}
