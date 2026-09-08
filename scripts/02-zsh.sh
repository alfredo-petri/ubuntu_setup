#!/usr/bin/env bash
# Instala Zsh + Oh My Zsh + Powerlevel10k + plugins clonando direto dos
# repositórios oficiais — sempre pega a versão mais atualizada. A única
# coisa deste setup que roda sem depender de um repositório de terceiro
# é a config do nvim (fork estático em nvim/config, ver scripts/03-nvim.sh).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OMZ_DIR="$HOME/.oh-my-zsh"
CUSTOM="$OMZ_DIR/custom"

backup_if_exists() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    echo "==> Backup: $target -> $backup"
    mv "$target" "$backup"
  fi
}

clone_if_missing() {
  local url="$1" dest="$2"
  if [[ -d "$dest" ]]; then
    echo "    $dest já existe, pulando (remova manualmente para reinstalar/atualizar)."
  else
    git clone --depth=1 "$url" "$dest"
  fi
}

echo "==> Instalando Oh My Zsh (ohmyzsh/ohmyzsh)"
clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$OMZ_DIR"

mkdir -p "$CUSTOM/themes" "$CUSTOM/plugins"

echo "==> Instalando tema Powerlevel10k (romkatv/powerlevel10k)"
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$CUSTOM/themes/powerlevel10k"

echo "==> Instalando plugins zsh (zsh-users/*)"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$CUSTOM/plugins/zsh-syntax-highlighting"
clone_if_missing https://github.com/zsh-users/zsh-completions "$CUSTOM/plugins/zsh-completions"

echo "==> Instalando ~/.zshrc"
backup_if_exists "$HOME/.zshrc"
cp "$REPO_ROOT/zsh/zshrc.template" "$HOME/.zshrc"

echo "==> Definindo zsh como shell padrão"
if [[ "$SHELL" != *zsh* ]]; then
  chsh -s "$(command -v zsh)" || echo "    Não foi possível trocar o shell automaticamente. Rode manualmente: chsh -s \$(which zsh)"
else
  echo "    zsh já é o shell padrão."
fi

cat <<'EOF'

==> Zsh instalado.
Abra uma nova sessão (ou rode `zsh`) e depois `p10k configure` para
o assistente interativo do Powerlevel10k.

Para atualizar depois: apague os diretórios em ~/.oh-my-zsh e
~/.oh-my-zsh/custom/{themes,plugins}/* que quiser atualizar e rode
este script de novo (ou faça `git pull` dentro de cada um, já que
são clones git normais).
EOF
