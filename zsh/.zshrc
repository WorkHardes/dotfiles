ZSH_THEME="agnoster"

plugins=(
    ansible
    archlinux
    celery
    docker
    docker-compose
    emoji
    git
    git-lfs
    golang
    gulp
    history
    kitty
    kubectl
    minikube
    mongo-atlas
    mongocli
    nmap
    npm
    pip
    poetry
    postgres
    pre-commit
    pyenv
    python
    rust
    ssh
    sublime
    systemd
    tmux
    yarn
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)

# git aliases
alias gpa="git pull --all"
alias gb="git branch"
alias ga="git add"

# pyenv path
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# prompt like ~
export DEFAULT_USER=$USER

# golang binaries
export PATH="$HOME/go/bin:$PATH"
