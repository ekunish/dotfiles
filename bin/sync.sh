#!/bin/zsh

set -eux

brew bundle dump --force
brew bundle cleanup
brew bundle
