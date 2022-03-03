#!/bin/zsh

set -eux

brew update
brew upgrade

source $HOME/dotfiles/sync.sh
