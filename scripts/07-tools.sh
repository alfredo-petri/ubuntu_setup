#!/usr/bin/env bash
# Utilitários de terminal escolhidos item a item: htop, ffmpeg e
# fastfetch (repositórios oficiais do Ubuntu), tldr (binário oficial
# de isacikgoz/tldr) e nodemon (pacote global via npm).
set -euo pipefail

echo "==> Instalando htop, ffmpeg, fastfetch"
sudo apt update
sudo apt install -y htop ffmpeg fastfetch

if command -v tldr >/dev/null 2>&1; then
  echo "==> tldr já instalado"
else
  echo "==> Instalando tldr (isacikgoz/tldr)"
  TAG="$(curl -fsSL https://api.github.com/repos/isacikgoz/tldr/releases/latest | grep -m1 '"tag_name"' | cut -d '"' -f4)"
  VERSION="${TAG#v}"
  TMP="$(mktemp -d)"
  curl -fsSL "https://github.com/isacikgoz/tldr/releases/download/${TAG}/tldr_${VERSION}_linux_amd64.tar.gz" -o "$TMP/tldr.tgz"
  tar -xzf "$TMP/tldr.tgz" -C "$TMP"
  mkdir -p "$HOME/.local/bin"
  install -m 755 "$TMP/tldr" "$HOME/.local/bin/tldr"
fi

echo "==> Instalando nodemon (global, via npm)"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
if command -v npm >/dev/null 2>&1; then
  npm install -g nodemon
else
  echo "    npm não encontrado — rode scripts/04-node.sh antes deste script."
fi
