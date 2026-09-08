#!/usr/bin/env bash
# Baixa e instala a fonte MesloLGS NF direto do repositório oficial
# (romkatv/powerlevel10k-media) na máquina LOCAL de onde você acessa o
# terminal — só faz sentido se essa máquina for Linux. Para Windows,
# use install-fonts.ps1.
set -euo pipefail

FONTS_DST="$HOME/.local/share/fonts"
BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"

mkdir -p "$FONTS_DST"
for variant in Regular Bold Italic "Bold%20Italic"; do
  name="MesloLGS NF ${variant//%20/ }.ttf"
  echo "==> Baixando $name"
  curl -fLo "$FONTS_DST/$name" "$BASE_URL/MesloLGS%20NF%20${variant}.ttf"
done

fc-cache -fv >/dev/null

echo "==> Fonte MesloLGS NF instalada em $FONTS_DST"
echo "    Selecione 'MesloLGS NF' nas preferências do seu emulador de terminal."
