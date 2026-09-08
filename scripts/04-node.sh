#!/usr/bin/env bash
# Instala NVM + Node LTS a partir do repositório oficial nvm-sh/nvm.
# Necessário para o Mason instalar servidores LSP baseados em npm
# (ex.: vtsls, usado pela config do Neovim deste repositório).
set -euo pipefail

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  echo "==> NVM já instalado em $NVM_DIR"
else
  echo "==> Instalando NVM (nvm-sh/nvm)"
  LATEST_TAG="$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep -m1 '"tag_name"' | cut -d '"' -f4)"
  # PROFILE=/dev/null: o carregamento do nvm já está em zsh/zshrc.template
  # (versionado), não deixamos o instalador mexer em nenhum rc file
  # direto. Precisa de `export` (não só prefixo) porque o `bash` do
  # outro lado do pipe é quem lê a variável, não o `curl`.
  export PROFILE=/dev/null
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST_TAG}/install.sh" | bash
fi

# shellcheck disable=SC1091
\. "$NVM_DIR/nvm.sh"

echo "==> Instalando Node LTS"
nvm install --lts
nvm alias default 'lts/*'

cat <<'EOF'

==> Node instalado.
Abra uma nova sessão (o nvm é carregado pelo Oh My Zsh via plugin nvm
automaticamente se estiver na lista de plugins, ou pelo trecho que o
instalador acrescenta ao seu shell rc).
EOF
