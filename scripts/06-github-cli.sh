#!/usr/bin/env bash
# Instala o GitHub CLI (gh) a partir do repositório apt oficial do
# próprio GitHub (cli.github.com) — não é o apt padrão do Ubuntu, mas
# é o fabricante da ferramenta, não um terceiro.
set -euo pipefail

if command -v gh >/dev/null 2>&1; then
  echo "==> gh já instalado ($(gh --version | head -1))"
  exit 0
fi

echo "==> Adicionando repositório oficial do GitHub CLI"
out="$(mktemp)"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o "$out"
sudo install -D -m 644 "$out" /usr/share/keyrings/githubcli-archive-keyring.gpg
sudo mkdir -p -m 755 /etc/apt/sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

echo "==> Instalando gh"
sudo apt update
sudo apt install -y gh

cat <<'EOF'

==> GitHub CLI instalado. Rode `gh auth login` para autenticar.
EOF
