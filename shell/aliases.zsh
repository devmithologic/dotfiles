# ============================================================================
# aliases.zsh - Operations aliases
# ============================================================================

# --- General ---
alias cls='clear'
alias reload='source ~/.zshrc'
alias dotfiles='cd ~/.dotfiles'
alias zshrc='$EDITOR ~/.zshrc'
alias hosts='sudo $EDITOR /etc/hosts'
alias myip='curl -s ifconfig.me && echo'
alias ports='lsof -i -P -n | grep LISTEN'
alias weather='curl wttr.in/?format=3'

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias dev='cd ~/dev'
alias projects='cd ~/projects'

# --- File operations (modern replacements if available) ---
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lah --icons --git'
  alias lt='eza -lah --icons --sort=modified'
  alias lsize='eza -lah --icons --sort=size'
  alias tree='eza --tree --icons -I "node_modules|.git|__pycache__|.venv|venv"'
else
  alias ll='ls -lah'
  alias lt='ls -lahtr'
  alias lsize='ls -lahS'
  alias tree='tree -C -I "node_modules|.git|__pycache__|.venv|venv"'
fi

if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias catp='bat'                   # bat with pager
  alias batdiff='bat --diff'         # Show file with git diff highlights
fi

if command -v rg &>/dev/null; then
  alias grep='rg'
  alias rgi='rg -i'                  # Case insensitive
else
  alias grep='grep --color=auto'
fi

if command -v fd &>/dev/null; then
  alias find='fd'
fi

alias df='df -h'
alias du='du -sh'
alias dua='ncdu 2>/dev/null || du -sh * | sort -rh'

# --- kubectl (extending oh-my-zsh plugin) ---
alias k='kubectl'
alias kx='kubectl config use-context'
alias kn='kubectl config set-context --current --namespace'
alias kctx='kubectl config get-contexts'
alias kns='kubectl get ns'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgpw='kubectl get pods -o wide'
alias kgd='kubectl get deployments'
alias kgs='kubectl get svc'
alias kgi='kubectl get ingress'
alias kgn='kubectl get nodes -o wide'
alias kga='kubectl get all'
alias kgaa='kubectl get all -A'
alias kdp='kubectl describe pod'
alias kds='kubectl describe svc'
alias kdd='kubectl describe deployment'
alias kdn='kubectl describe node'
alias klf='kubectl logs -f'                  # Follow logs
alias klp='kubectl logs --previous'          # Previous container logs
alias kex='kubectl exec -it'                 # Interactive exec
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kdel='kubectl delete'
alias ktp='kubectl top pods'
alias ktn='kubectl top nodes'
alias kroll='kubectl rollout status deployment'
alias kru='kubectl rollout undo deployment'
alias krh='kubectl rollout history deployment'

# kubectl dry-run shortcut (for CKA practice too)
export do="--dry-run=client -o yaml"

# Quick pod for debugging
alias kdebug='kubectl run debug-pod --rm -it --image=busybox:1.28 -- /bin/sh'
alias kdebug-net='kubectl run debug-net --rm -it --image=nicolaka/netshoot -- /bin/bash'

# --- Docker ---
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias di='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'
alias dlog='docker logs -f'
alias dex='docker exec -it'
alias dprune='docker system prune -af --volumes'
alias dvol='docker volume ls'
alias dnet='docker network ls'
alias dstop='docker stop $(docker ps -q)'   # Stop all running containers
alias drm='docker rm $(docker ps -aq)'      # Remove all containers

# --- Git (extending oh-my-zsh plugin) ---
alias g='git'
alias gs='git status -sb'                    # Short status with branch
alias gl='git log --oneline -20'
alias glg='git log --oneline --graph --all -20'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -m'
alias gca='git commit --amend --no-edit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpu='git push -u origin $(git branch --show-current)'
alias gpull='git pull --rebase'
alias gbr='git branch -vv'
alias gbd='git branch -d'
alias gst='git stash'
alias gstp='git stash pop'
alias gclean='git checkout main && git pull && git branch --merged main | grep -v main | xargs -r git branch -d'

# --- AWS ---
alias awswho='aws sts get-caller-identity'
alias awsprofile='export AWS_PROFILE'
alias awsregion='export AWS_DEFAULT_REGION'
alias awsprofiles='aws configure list-profiles'

# --- SSH ---
alias sshl='ssh -l'
alias sshconfig='$EDITOR ~/.ssh/config'
alias sshkeys='ls -la ~/.ssh/*.pub 2>/dev/null'
alias sshcopy='ssh-copy-id'

# --- Terraform ---
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfd='terraform destroy'
alias tfs='terraform state list'
alias tff='terraform fmt -recursive'
alias tfv='terraform validate'

# --- System monitoring ---
alias meminfo='free -h 2>/dev/null || vm_stat'
alias cpuinfo='lscpu 2>/dev/null || sysctl -n machdep.cpu.brand_string'
alias diskinfo='df -h | grep -v tmpfs'
alias top='btop 2>/dev/null || htop 2>/dev/null || top'

# --- TUI apps ---
alias lg='lazygit'
alias lzd='lazydocker'
alias kk='k9s'

# --- Quick help ---
alias help='tldr'
