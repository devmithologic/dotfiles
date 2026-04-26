eval "$(/opt/homebrew/bin/brew shellenv)"

# --- pyenv shims (must be in .zprofile for non-interactive shells) ---
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Note: The Python 3.13 system install path was removed.
# Use pyenv to manage Python versions instead:
#   pyenv install 3.13
#   pyenv global 3.13
