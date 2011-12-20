#!/usr/bin/env zsh

# Path to your oh-my-zsh configuration.
ZSH=$HOME/Development/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it"ll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx brew git github node npm pip textmate nyan)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Theme.
HOSTINFO="%{$fg[yellow]%}%n@%m"
CURDIR='%{$fg[red]%}%p%~ %{$fg[red]%}$ %{$reset_color%}'

# Show hostname and username on remote shells.
if [[ -z "`uname -a | grep paulmillr`" ]]; then
  PROMPT="$HOSTINFO $CURDIR"
else
  PROMPT="$CURDIR"
fi


# Add Ruby, Homebrew, custom Python2/3 & Haskell package dirs to PATH.
export PATH="\
/usr/local/bin:\
/usr/local/Cellar/ruby/1.9.3-p0/bin:\
/usr/bin:/bin:\
/usr/sbin:/sbin:\
/usr/X11/bin:\
/usr/texbin:\
/usr/local/share/python:\
/usr/local/share/python3:\
$HOME/.cabal/bin"

# LS colors for my theme (paulmillr.terminal).
#export LSCOLORS=ExGxFxDxCxHxHxCbCeEbEb

# Solarized light LS colors.
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# Count code lines in some directory.
# Example usage: `linecount .py .js .css`
function linecount() {
  local total
  local firstletter
  local ext
  local lines
  total=0
  for ext in $@; do
    firstletter=$(echo $ext | cut -c1-1)
    if [[ firstletter != "." ]]; then
      ext=".$ext"
    fi
    lines=`find . -name "*$ext" -exec cat {} \; | wc -l`
    lines=${lines// /}
    total=$(($total + $lines))
    echo Lines of code for $ext: $lines
  done
  echo Total lines of code: $total
}

# Disable / enable screenshot shadow in OS X.
function scrshadow() {
  if [[ $1 == "on" ]]; then
    defaults delete com.apple.screencapture disable-shadow 
    killall SystemUIServer
  elif [[ $1 == "off" ]]; then
    defaults write com.apple.screencapture disable-shadow -bool true 
    killall SystemUIServer
  else
    echo Enter options: ON or OFF
  fi
}

function ram() {
  local sum
  local items
  local app

  app="$1"
  if [ -z "$app" ]; then
    echo "First argument - pattern to grep from processes"
  else
    sum=0
    for i in `ps aux | grep -i "$app" | grep -v "grep" | awk '{print $6}'`; do
      sum=$(($i + $sum))
    done
    sum=$(echo "scale=2; $sum / 1024.0" | bc)
    if [[ $sum != "0" ]]; then
      echo "${fg[blue]}${app}${reset_color} uses ${fg[green]}${sum}${reset_color} MBs of RAM."
    else
      echo "There's no processes with pattern ${fg[blue]}'${app}'${reset_color} are running."
    fi
  fi
}

export LANG=en_US.UTF-8

# Some aliases.
alias rm=trash
alias bitch,=sudo

# iPython as default shell.
#exec /usr/local/bin/ipython -noconfirm_exit -p sh