#!/bin/bash

# Get location of script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OMZ_HOME=$DIR/.oh-my-zsh
export ZPLUG_HOME=$DIR/.zplug

# 1. Install oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ${OMZ_HOME}

# 2. Install zplug
git clone https://github.com/zplug/zplug ${ZPLUG_HOME}
zsh source ${ZPLUG_HOME}/init.zsh

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ln -sv ${DIR}/zshrc ~/.zshrc
ln -sv ${DIR}/config ~/.config
