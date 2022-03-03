#!/bin/zsh

set -eux

for dotfile in .??*; do
  [[ $dotfile == '.git' ]] && continue
  [[ $dotfile == '.DS_Store' ]] && continue

  ln -sfnv $HOME/dotfiles/$dotfile $HOME
done

