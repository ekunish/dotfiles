#!/bin/sh

# エラーや未定義の変数に備える
set -eu

# dotfilesディレクトリの場所を、変数DOTFILES_DIRに教える
DOTFILES_DIR=$(cd $(dirname $0); pwd)
# dotfilesディレクトリに移動する
cd $DOTFILES_DIR

# .から始まるファイルやフォルダに対して繰り返す
for f in .??*; do
	# シンボリックリンクを作りたくないファイルやフォルダを除外
	[[ "$f" == ".git" ]] && continue
	[[ "$f" == ".gitconfig" ]] && continue
	[[ "$f" == ".gitignore" ]] && continue
	[[ "$f" == ".DS_Store" ]] && continue
	[[ "$f" =~ .swp$ ]] && continue

	# シンボリックリンクを作成
	ln -snfv ${DOTFILES_DIR}/$f ~
done

