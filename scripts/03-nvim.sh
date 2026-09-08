#!/usr/bin/env bash
# Instala o Neovim (AppImage oficial, o apt do Ubuntu fica desatualizado)
# e copia a config vendorizada em nvim/config/ para ~/.config/nvim.
#
# lazy.nvim (gerenciador de plugins) e mason (instalador de LSP) baixam
# seus plugins/binários do GitHub na primeira abertura do nvim — isso é
# o funcionamento normal dessas ferramentas e não foi vendorizado.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config/nvim"

echo "==> Instalando Neovim (AppImage oficial)"
mkdir -p "$HOME/.local/bin"
TMP_APPIMAGE="$(mktemp -d)/nvim.appimage"
curl -Lo "$TMP_APPIMAGE" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x "$TMP_APPIMAGE"
mv "$TMP_APPIMAGE" "$HOME/.local/bin/nvim"

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) echo "    Aviso: $HOME/.local/bin não está no PATH. Adicione no seu shell rc." ;;
esac

echo "==> Instalando configuração do Neovim (vendorizada)"
if [[ -e "$CONFIG_DIR" && ! -L "$CONFIG_DIR" ]]; then
  backup="${CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
  echo "    Backup: $CONFIG_DIR -> $backup"
  mv "$CONFIG_DIR" "$backup"
fi
mkdir -p "$(dirname "$CONFIG_DIR")"
cp -r "$REPO_ROOT/nvim/config" "$CONFIG_DIR"

cat <<'EOF'

==> Neovim instalado.
Abra `nvim` para o lazy.nvim baixar os plugins automaticamente
(precisa de internet nesse primeiro passo). Depois, `:Mason` para
garantir que o LSP `vtsls` está instalado.
EOF
