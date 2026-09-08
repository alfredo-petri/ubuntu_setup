#!/bin/bash

# Garante que o diretório de binários do usuário existe
mkdir -p ~/.local/bin

# Baixa o AppImage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage

# Torna executável
chmod u+x nvim-linux-x86_64.appimage

# Move para o diretório local do usuário com o nome 'nvim'
mv nvim-linux-x86_64.appimage ~/.local/bin/nvim
