#!/usr/bin/env bash
# Pacotes apt necessários para zsh e nvim. Nada aqui vem de repositório
# de terceiros fora do apt oficial do Ubuntu/Debian.
set -euo pipefail

echo "==> Instalando pacotes apt (zsh, ripgrep, fzf, xclip)"
sudo apt update
sudo apt install -y zsh ripgrep fzf xclip
