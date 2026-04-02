# ============================================================
# ZSH Configuration - macOS + Optimized for Neovim, tmux, and Starship
# ============================================================

# ============================================================
# Homebrew (must be first)
# ============================================================

eval "$(/opt/homebrew/bin/brew shellenv)"

# ============================================================
# Environment Variables
# ============================================================

export HF_HUB_ENABLE_HF_TRANSFER=1

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Language
if locale -a 2>/dev/null | grep -q "^en_US.UTF-8"; then
    export LANG='en_US.UTF-8'
    export LC_ALL='en_US.UTF-8'
else
    export LANG='C.UTF-8'
    export LC_ALL='C.UTF-8'
fi

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=1000000
export HISTORY_IGNORE="(ls|cd|pwd|exit|cd ..)"

# FZF configuration (Catppuccin Mocha)
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='
  --height 40% --layout=reverse --border
  --color=bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=selected-bg:#45475a
  --color=border:#6c7086,label:#cdd6f4
'

# ============================================================
# Path Configuration (macOS specific)
# ============================================================

# Android SDK/Studio
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

alias bundletool="java -jar $HOME/bundletool/bundletool-all-1.10.0.jar"

# LLVM
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# General
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/Applications/MATLAB_R2023a.app/bin:$PATH"

# Rust/Cargo
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# pnpm
export PNPM_HOME="/Users/ekunish/Library/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Antigravity
export PATH="/Users/ekunish/.antigravity/antigravity/bin:$PATH"

# ============================================================
# Conda / Miniforge (PRESERVED)
# ============================================================

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# ============================================================
# LS_COLORS via vivid (Catppuccin Mocha)
# ============================================================

if command -v vivid &> /dev/null; then
    export LS_COLORS="$(vivid generate catppuccin-mocha)"
fi

# ============================================================
# ZSH Options
# ============================================================

# History options
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# Directory navigation
# setopt AUTO_CD  # Disabled: prevents unintended cd when typing directory names
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt AUTO_MENU

# Other useful options
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt NO_FLOW_CONTROL
setopt EXTENDED_GLOB

# ============================================================
# Cursor Style
# ============================================================

# デフォルトカーソルを点滅縦棒に設定
echo -ne '\e[5 q'

# ============================================================
# Aliases
# ============================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# List files (use eza if available, fallback to ls)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git'
    alias la='eza -a --icons --group-directories-first'
    alias l='eza --icons --group-directories-first'
    alias lt='eza --tree --icons --level=2'
    alias ltr='eza -la --sort=modified --icons'
    alias tree='eza --tree --icons'
else
    alias ls='ls --color=auto -p'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias lt='ls -lt'
    alias ltr='ls -ltr'
    alias tree='tree -C'
fi

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'
alias glogp='git log --oneline --graph --decorate --all'
alias lg='lazygit'

# Neovim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'
alias nvd='nvim -d'  # Diff mode

# tmux
alias t='tmux'
alias ta='tmux attach -t'
alias tls='tmux ls'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'
alias tka='tmux kill-server'
alias tr='tmux rename-session -t'

# System
alias reload='source ~/.zshrc'
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'

# Development
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'

# bat (better cat)
if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
    alias less='bat'
    export BAT_THEME="Catppuccin Mocha"
fi

# Docker (if available)
if command -v docker &> /dev/null; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias dimg='docker images'
    alias dexec='docker exec -it'
    alias dlogs='docker logs -f'
    alias dprune='docker system prune -a'
fi

# Kubernetes (if available)
if command -v kubectl &> /dev/null; then
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get services'
    alias kgd='kubectl get deployments'
    alias kaf='kubectl apply -f'
    alias kdel='kubectl delete'
    alias klog='kubectl logs -f'
fi

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ============================================================
# Functions
# ============================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick backup
backup() {
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# Git commit with emoji (matching our convention)
gce() {
    local type="$1"
    local scope="$2"
    local message="$3"

    case "$type" in
        feat)     emoji="✨" ;;
        fix)      emoji="🐛" ;;
        docs)     emoji="📝" ;;
        style)    emoji="🎨" ;;
        refactor) emoji="♻️" ;;
        perf)     emoji="⚡" ;;
        test)     emoji="✅" ;;
        build)    emoji="📦" ;;
        config)   emoji="🔧" ;;
        ci)       emoji="👷" ;;
        chore)    emoji="🔧" ;;
        *)        emoji="🔨" ;;
    esac

    if [ -n "$scope" ] && [ -n "$message" ]; then
        git commit -m "$emoji $type($scope): $message"
    elif [ -n "$scope" ]; then
        git commit -m "$emoji $type: $scope"
    else
        echo "Usage: gce <type> [scope] <message>"
        echo "Types: feat, fix, docs, style, refactor, perf, test, build, config, ci, chore"
    fi
}

# Yazi wrapper - change directory on exit
if command -v yazi &> /dev/null; then
    y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
fi

# FZF powered functions
if command -v fzf &> /dev/null; then
    # Interactive directory navigation
    fd() {
        local dir
        dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
        cd "$dir"
    }

    # Interactive file open with nvim
    fe() {
        local files
        IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
        [[ -n "$files" ]] && nvim "${files[@]}"
    }

    # Interactive git branch checkout
    fco() {
        local branches branch
        branches=$(git branch --all | grep -v HEAD) &&
        branch=$(echo "$branches" | fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
        git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    }
fi

# ============================================================
# Completion System
# ============================================================

# poetry completions
fpath+=~/.zfunc

# zsh-completions (additional completion definitions)
if [[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]]; then
    fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fi

# Initialize completion (cache for 24h to speed up startup)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Completers: extensions → exact → approximate (typo tolerance)
zstyle ':completion:*' completer _extensions _complete _approximate

# 4-pass matching: exact → case-insensitive → partial-path → substring
zstyle ':completion:*' matcher-list \
    '' \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'

# Display — menu no: fzf-tab handles the menu
zstyle ':completion:*' menu no
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-dirs-first true

# Formatting (colored)
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:corrections' format '[%d (errors: %e)]'
zstyle ':completion:*:messages' format '[%d]'
zstyle ':completion:*:warnings' format '[no matches found]'

# Cache (speeds up heavy completions)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Process completion for kill
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# SSH: don't pull noisy entries from /etc/hosts
zstyle ':completion:*:ssh:*' hosts off

# Accept exact match even if ambiguous
zstyle ':completion:*' accept-exact '*(N)'

# Scroll prompt for large lists
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' select-prompt '%SScrolling: current selection at %p%s'

# Dart CLI completion
[[ -f /Users/ekunish/.config/.dart-cli-completion/zsh-config.zsh ]] && . /Users/ekunish/.config/.dart-cli-completion/zsh-config.zsh || true

# ============================================================
# Plugins
# ============================================================

# fzf-tab (fzf-powered completion menu) — must be after compinit, before autosuggestions
if [[ -n "$HOMEBREW_PREFIX" ]] && [[ -f "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh" ]]; then
    source "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"
elif [[ -f "$HOME/.local/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh" ]]; then
    source "$HOME/.local/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
fi

# fzf-tab settings
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' prefix ''

# fzf-tab previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
    fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
    'case "$group" in
        "modified file") git diff $word | delta ;;
        *) git log --oneline --graph --color=always $word ;;
    esac'

# fzf shell integration (Ctrl+R: history, Ctrl+T: files, Alt+C: cd)
if command -v fzf &> /dev/null; then
    if [[ -n "$HOMEBREW_PREFIX" ]] && [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]]; then
        source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
        source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
    fi
fi

# zsh-autosuggestions (fish-like history suggestions)
if [[ -n "$HOMEBREW_PREFIX" ]] && [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# ============================================================
# Key Bindings
# ============================================================

# Emacs-style line editing
bindkey -e

# History search
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Word navigation
bindkey '^[[1;5C' forward-word  # Ctrl+Right
bindkey '^[[1;5D' backward-word # Ctrl+Left

# Home/End keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# ============================================================
# Starship Prompt
# ============================================================

eval "$(starship init zsh)"

# ============================================================
# Tool Initializations (macOS specific, preserved)
# ============================================================

# nodenv
if [ -e "$HOME/.nodenv" ]; then
    export NODENV_ROOT="$HOME/.nodenv"
    export PATH="$NODENV_ROOT/bin:$PATH"
    if command -v nodenv 1>/dev/null 2>&1; then
        eval "$(nodenv init - --no-rehash)"
    fi
fi

# Google Cloud SDK
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
export ZONE="asia-southeast1-a"
export INSTANCE="mlpre-login-mujor9d1-001"
export PROJECT="geniac-pre"
export COMPUTE_INSTANCE="mlpre-g2-ghpc-3"

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# NVM（遅延ロード）
export NVM_DIR="$HOME/.config/nvm"

_load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() { unfunction nvm node npm npx 2>/dev/null; _load_nvm; nvm "$@" }
node() { unfunction nvm node npm npx 2>/dev/null; _load_nvm; node "$@" }
npm() { unfunction nvm node npm npx 2>/dev/null; _load_nvm; npm "$@" }
npx() { unfunction nvm node npm npx 2>/dev/null; _load_nvm; npx "$@" }

_nvm_auto_use() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc 2>/dev/null)"
  if [ -n "$nvmrc_path" ]; then
    nvm use 2>/dev/null
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _nvm_auto_use

# ============================================================
# zoxide (smarter cd)
# ============================================================

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# ============================================================
# Atuin (better shell history)
# ============================================================

if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
fi

# ============================================================
# Local Configuration
# ============================================================

if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

# ============================================================
# Syntax Highlighting (must be sourced last)
# ============================================================

if [[ -n "$HOMEBREW_PREFIX" ]] && [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ============================================================
# tmux Auto-attach (optional)
# ============================================================

if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -z "$INSIDE_EMACS" ] && [ -z "$VIM" ]; then
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        # tmux new-session -A -s ssh
        :  # Disabled by default, uncomment above to enable
    elif [ "$TERM_PROGRAM" != "vscode" ]; then
        # tmux new-session -A -s main
        :  # Disabled by default, uncomment above to enable
    fi
fi
