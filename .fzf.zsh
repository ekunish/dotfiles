# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"



# enable-fzf-preview
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}"'
export FZF_DEFAULT_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}"'


function select-history() {
BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
CURSOR=$#BUFFER

# FZF_RESULT=$(history | sort -k2 | uniq -f 2 | sort -k1 -n -r | perl -pe 's/^(\s+)?[0-9]+\s+//g' | fzf);
# BEFORE_CURSOR=${READLINE_LINE:0:$READLINE_POINT};
# AFTER_CURSOR=${READLINE_LINE:$READLINE_POINT};
# READLINE_LINE=${BEFORE_CURSOR}${FZF_RESULT}${AFTER_CURSOR};
# (( READLINE_POINT += ${#FZF_RESULT} ))
}

zle -N select-history
bindkey '^r' select-history

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
'

_fzf() {fzf --bind 'ctrl-y:execute-silent(pbcopy <<< {})+abort'}

# ff - fuzzy open with vim from anywhere
# ex: vf word1 word2 ... (even part of a file name)
# zsh autoload function
f() {
  local files

  # files=(${(f)"$(locate -i -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})
  files=(${(f)"$( _fzf )"})

  if [[ -n $files ]]
  then
    # nvim -- $files
    print -l $files[1]
  fi
}

fo() {
  local files

  # files=(${(f)"$(locate -i -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})
  files=(${(f)"$( _fzf )"})

  if [[ -n $files ]]
  then
    nvim -- $files
  fi
}



# Another fd - cd into the selected directory
# This one differs from the above, by only showing the sub directories and not
#  showing the directories within those.
# fd() {
#   DIR=`find * -maxdepth 0 -type d -print 2> /dev/null | fzf-tmux` \
#     && cd "$DIR"
#   }

# fda - including hidden directories
fd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# cf - fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
# zsh autoload function
cf() {
  local file

  file="$(locate -i -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"

  if [[ -n $file ]]
  then
    if [[ -d $file ]]
    then
      cd -- $file
    else
      cd -- ${file:h}
    fi
  fi
}


# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
  local pid 
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi  

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi  
}

# zsh; needs setopt re_match_pcre. You can, of course, adapt it to your own shell easily.
tmuxkillf () {
  local sessions
  sessions="$(tmux ls|fzf --exit-0 --multi)"  || return $?
  local i
  for i in "${(f@)sessions}"
  do
    [[ $i =~ '([^:]*):.*' ]] && {
      echo "Killing $match[1]"
          tmux kill-session -t "$match[1]"
        }
    done
  }

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.

tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# fs [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
    tmux switch-client -t "$session"
  }

# ftpane - switch pane (@george-b)
ftpane() {
  local panes current_window current_pane target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_pane=$(tmux display-message -p '#I:#P')
  current_window=$(tmux display-message -p '#I')

  target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} &&
      tmux select-window -t $target_window
  fi
}


# In tmux.conf
# bind-key 0 run "tmux split-window -l 12 'bash -ci ftpane'"

fssh() {
  local sshLoginHost
  sshLoginHost=`cat ~/.ssh/config | grep -i ^host | awk '{print $2}' | fzf`

  if [ "$sshLoginHost" = "" ]; then
    # ex) Ctrl-C.
    return 1
  fi

  ssh ${sshLoginHost}
}


# Install (one or multiple) selected application(s)
# using "brew search" as source input
# mnemonic [B]rew [I]nstall [P]ackage
bip() {
  local inst=$(brew search "$@" | fzf -m)

  if [[ $inst ]]; then
    for prog in $(echo $inst);
    do; brew install $prog; done;
  fi
}

# Update (one or multiple) selected application(s)
# mnemonic [B]rew [U]pdate [P]ackage
bup() {
  local upd=$(brew leaves | fzf -m)

  if [[ $upd ]]; then
    for prog in $(echo $upd);
    do; brew upgrade $prog; done;
  fi
}

# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]ackage (e.g. uninstall)
bcp() {
  local uninst=$(brew leaves | fzf -m)

  if [[ $uninst ]]; then
    for prog in $(echo $uninst);
    do; brew uninstall $prog; done;
  fi
}

# Install or open the webpage for the selected application 
# using brew cask search as input source
# and display a info quickview window for the currently marked application 
install() {
  local token
  token=$(brew search --casks "$1" | fzf-tmux --query="$1" +m --preview 'brew info {}')

  if [ "x$token" != "x" ]                                                                
  then             
    echo "(I)nstall or open the (h)omepage of $token"
    read input                             
    if [ $input = "i" ] || [ $input = "I" ]; then    
      brew install --cask $token                   
    fi                                                                                    
    if [ $input = "h" ] || [ $input = "H" ]; then                                         
      brew home $token                     
    fi                                           
  fi                             
}                                              

# Uninstall or open the webpage for the selected application 
# using brew list as input source (all brew cask installed applications) 
# and display a info quickview window for the currently marked application
uninstall() {                                                                     
  local token                                                                   
  token=$(brew list --casks | fzf-tmux --query="$1" +m --preview 'brew info {}')

  if [ "x$token" != "x" ]                                                       
  then                                                                          
    echo "(U)ninstall or open the (h)omepae of $token"                        
    read input                                                                
    if [ $input = "u" ] || [ $input = "U" ]; then                             
      brew uninstall --cask $token                                          
    fi                                                                        
    if [ $input = "h" ] || [ $token = "h" ]; then                             
      brew home $token                                                      
    fi                                                                        
  fi
}


unalias z
z() {
  if [[ -z "$*" ]]; then
    cd "$(zshz -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    zshz "$@"
  fi
}

zz() {
  cd "$(zshz -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q "$_last_z_args")"
}


# Select a docker container to start and attach to
function da() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# Select a running docker container to stop
function ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

# Select a docker container to remove
function drm() {
  docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -r docker rm
}

# Select a docker image or images to remove
function drmi() {
  docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $3 }' | xargs -r docker rmi
}

# fasd & fzf change directory - open best matched file using `fasd` if given argument, filter output of `fasd` using `fzf` else
function v() {
    [ $# -gt 0 ] && fasd -f -e ${EDITOR} "$*" && return
    local file
    file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && nvim "${file}" || return 1
}

