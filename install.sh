#!/usr/bin/env bash
# Instalador principal — um comando só faz o setup completo:
# zsh + oh-my-zsh + powerlevel10k + plugins + nvim + node + git + gh
# cli + utilitários de terminal + fonte MesloLGS NF (detecta sozinho
# se precisa instalar no Windows via WSL2 ou localmente no Linux).
#
# Qualquer decisão que precise de input (identidade do git, se instala
# a fonte no Windows) é perguntada aqui mesmo, via terminal interativo
# — sem precisar de flags nem de outra ferramenta pra configurar.
#
# oh-my-zsh, powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting,
# zsh-completions, a fonte MesloLGS NF e o NVM são clonados/baixados
# direto dos repositórios oficiais em tempo de instalação, sempre
# pegando a versão mais recente. gh cli vem do repositório apt oficial
# do GitHub (cli.github.com).
#
# A config do Neovim é a única coisa vendorizada de fato (fork estático
# em nvim/config): assim o setup não depende do repositório pessoal do
# nandobfer/nvim-config, que pode mudar ou sumir. lazy.nvim (plugins) e
# mason (LSPs) continuam baixando do GitHub na primeira abertura do
# nvim — funcionamento normal dessas ferramentas. O LSP vtsls que o
# mason instala precisa de npm, por isso o node entra no setup.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<EOF
Uso: $0 [--zsh] [--nvim] [--node] [--git] [--gh] [--tools] [--fonts] [--all]

Sem nenhuma flag, roda TUDO (equivalente a --all) — é o uso normal,
um comando só configura a máquina inteira:

  ./install.sh

Flags individuais, se quiser rodar só uma parte:
  --zsh    zsh/oh-my-zsh/powerlevel10k/plugins
  --nvim   neovim + config
  --node   nvm + node LTS (necessário para o LSP vtsls)
  --git    git + identidade global (pergunta nome/email se não tiver)
  --gh     GitHub CLI (gh)
  --tools  htop, ffmpeg, fastfetch, tldr, nodemon
  --fonts  fonte MesloLGS NF (detecta Windows/WSL2 vs Linux sozinho)
  --all    tudo (padrão se nenhuma flag for passada)
EOF
}

DO_ZSH=false
DO_NVIM=false
DO_NODE=false
DO_GIT=false
DO_GH=false
DO_TOOLS=false
DO_FONTS=false

if [[ $# -eq 0 ]]; then
  DO_ZSH=true; DO_NVIM=true; DO_NODE=true
  DO_GIT=true; DO_GH=true; DO_TOOLS=true; DO_FONTS=true
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --zsh) DO_ZSH=true ;;
    --nvim) DO_NVIM=true ;;
    --node) DO_NODE=true ;;
    --git) DO_GIT=true ;;
    --gh) DO_GH=true ;;
    --tools) DO_TOOLS=true ;;
    --fonts) DO_FONTS=true ;;
    --all) DO_ZSH=true; DO_NVIM=true; DO_NODE=true; DO_GIT=true; DO_GH=true; DO_TOOLS=true; DO_FONTS=true ;;
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

if $DO_NODE; then
  "$REPO_ROOT/scripts/04-node.sh"
fi

if $DO_GIT; then
  "$REPO_ROOT/scripts/05-git.sh"
fi

if $DO_GH; then
  "$REPO_ROOT/scripts/06-github-cli.sh"
fi

if $DO_TOOLS; then
  "$REPO_ROOT/scripts/07-tools.sh"
fi

if $DO_FONTS; then
  "$REPO_ROOT/scripts/08-fonts.sh"
fi

cat <<'EOF'

==> Instalação concluída.

Próximos passos:
  1. Abra uma nova sessão de terminal (ou rode `exec zsh`).
  2. `p10k configure` para configurar o Powerlevel10k.
  3. Dentro do nvim, `:Mason` e instale o `vtsls` (tecla `i` em cima
     dele) — precisa do node/npm, instalado pelo script 04-node.sh.
  4. `gh auth login` para autenticar o GitHub CLI.
  5. Selecione "MesloLGS NF" nas preferências do seu emulador de
     terminal, se ainda não fez isso.
EOF
