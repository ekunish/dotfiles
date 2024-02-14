################################# homebrew ##################################
eval "$(/opt/homebrew/bin/brew shellenv)"


################################# anyenv ##################################
# # install
# export PATH="~/.anyenv/bin:$PATH"
# eval "$(anyenv init -)"
#
# # export PATH="$HOME/.pyenv/bin:$PATH"
#
# export EDITOR=nvim
# export VISUAL="$EDITOR"

#################################  Android SDK  ################################
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

alias bundletool="java -jar $HOME/bundletool/bundletool-all-1.10.0.jar"


################################# conda ##################################

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


#################################  HISTORY  ####################################
# history
HISTFILE=$HOME/.zsh-history # 履歴を保存するファイル
HISTSIZE=100000             # メモリ上に保存する履歴のサイズ
SAVEHIST=1000000            # 上述のファイルに保存する履歴のサイズ

# share .zshhistory
setopt inc_append_history   # 実行時に履歴をファイルにに追加していく
setopt share_history        # 履歴を他のシェルとリアルタイム共有する


#################################  COMPLEMENT  #################################
# enable completion
autoload -Uz compinit && compinit

# 補完候補をそのまま探す -> 小文字を大文字に変えて探す -> 大文字を小文字に変えて探す
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

### 補完方法毎にグループ化する。
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''


### 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2


#################################  OTHERS  #################################
# automatically change directory when dir name is typed
setopt auto_cd

# disable ctrl+s, ctrl+q
setopt no_flow_control



#################################  Zplug  #################################
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# 非同期処理できるようになる
zplug "mafredri/zsh-async"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
# zplug "zsh-users/zsh-syntax-highlighting"
zplug "zdharma-continuum/fast-syntax-highlighting"
# コマンド入力途中で上下キー押したときの過去履歴がいい感じに出るようになる
zplug "zsh-users/zsh-history-substring-search"
# 過去に入力したコマンドの履歴が灰色のサジェストで出る
zplug "zsh-users/zsh-autosuggestions"
zplug "hchbaw/auto-fu.zsh"
# 補完強化
zplug "zsh-users/zsh-completions"
# 256色表示にする
zplug "chrissicool/zsh-256color"
# コマンドライン上の文字リテラルの絵文字を emoji 化する
zplug "mrowa44/emojify", as:command


zplug "agkozak/zsh-z"
zplug "kazhala/dotbare"

# zplug "Aloxaf/fzf-tab"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load


bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest


################################# pmy #####################################
# 補完のトリガーを変更 (Ctrl+P)
# export PMY_TRIGGER_KEY="^e"
# eval "$(pmy init)"


#################################  NEOVIM  ################################
export XDG_CONFIG_HOME="$HOME/.config"

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

export PATH="$HOME/.local/bin:$PATH"
#################################  Lunarvim  ################################
#export PATH="your-dir:$PATH" #$HOME/.local/bin/lvim
# export PATH="$HOME/.local/bin:$PATH"
alias lvim="~/.local/bin/lvim"

#################################  exa  #################################

if [[ $(command -v exa) ]]; then
    alias e='exa --icons --git'
    alias l=e
    # alias ls=e
    alias ls='exa -a --icons --git'
    alias ea='exa -a --icons --git'
    alias la=ea
    alias ee='exa -aahl --icons --git'
    alias ll=ee
    alias et='exa -T -L 3 -a -I "node_modules|.git|.cache" --icons'
    alias lt=et
    alias eta='exa -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
    alias lta=eta
    alias l='clear && ls'
fi


#################################  fzf  #################################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#################################  original command  #################################
# ip () {ifconfig | grep 192}
# reload () { exec $SHELL -l}
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/ekunish/Library/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

################################# starship ################################

if [ -e "$HOME/.nodenv" ]
then
    export NODENV_ROOT="$HOME/.nodenv"
    export PATH="$NODENV_ROOT/bin:$PATH"
    if command -v nodenv 1>/dev/null 2>&1
    then
        eval "$(nodenv init - --no-rehash)"
    fi
fi

eval "$(starship init zsh)"

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
