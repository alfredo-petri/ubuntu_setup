#!/usr/bin/env bash
# Instalador principal: zsh + oh-my-zsh + powerlevel10k + plugins + nvim.
#
# oh-my-zsh, powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting,
# zsh-completions e a fonte MesloLGS NF são clonados/baixados direto dos
# repositórios oficiais em tempo de instalação, sempre pegando a versão
# mais recente.
#
# A config do Neovim é a única coisa vendorizada de fato (fork estático
# em nvim/config): assim o setup não depende do repositório pessoal do
# nandobfer/nvim-config, que pode mudar ou sumir. lazy.nvim (plugins) e
# mason (LSPs) continuam baixando do GitHub na primeira abertura do
# nvim — funcionamento normal dessas ferramentas.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<EOF
Uso: $0 [--zsh] [--nvim] [--all]

  --zsh    Instala apenas zsh/oh-my-zsh/powerlevel10k/plugins
  --nvim   Instala apenas neovim + config
  --all    Instala tudo (padrão se nenhuma flag for passada)

Fontes (MesloLGS NF) não entram aqui — rode fonts/install-fonts.sh
(Linux) ou fonts/install-fonts.ps1 (Windows) na MÁQUINA LOCAL de onde
você acessa o terminal.
EOF
}

DO_ZSH=false
DO_NVIM=false

if [[ $# -eq 0 ]]; then
  DO_ZSH=true
  DO_NVIM=true
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --zsh) DO_ZSH=true ;;
    --nvim) DO_NVIM=true ;;
    --all) DO_ZSH=true; DO_NVIM=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opção desconhecida: $1"; usage; exit 1 ;;
  esac
  shift
done

"$REPO_ROOT/scripts/01-packages.sh"

if $DO_ZSH; then
  "$REPO_ROOT/scripts/02-zsh.sh"
fi

if $DO_NVIM; then
  "$REPO_ROOT/scripts/03-nvim.sh"
fi

cat <<'EOF'

==> Instalação concluída.

Próximos passos:
  1. Abra uma nova sessão de terminal (ou rode `exec zsh`).
  2. `p10k configure` para configurar o Powerlevel10k.
  3. Se ainda não instalou a fonte MesloLGS NF na máquina local,
     rode fonts/install-fonts.sh (Linux) ou fonts/install-fonts.ps1
     (Windows) por lá.
EOF
