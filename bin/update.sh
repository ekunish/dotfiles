#!/bin/zsh

set -eux

brew update
brew upgrade

source $HOME/dotfiles/bin/sync.sh
