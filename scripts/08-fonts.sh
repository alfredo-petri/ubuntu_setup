#!/usr/bin/env bash
# Instala a fonte MesloLGS NF na máquina onde o TERMINAL roda de fato
# (não onde este script roda). Detecta o ambiente automaticamente:
#   - WSL2 com acesso a powershell.exe: instala no Windows via
#     fonts/install-fonts.ps1 (a fonte precisa estar lá, não no Linux).
#   - Linux "puro" (com sessão gráfica local): instala via
#     fonts/install-fonts.sh.
#   - Qualquer outro caso (SSH a partir de outra máquina, sem
#     powershell.exe acessível etc.): não dá pra automatizar daqui,
#     mostra instruções manuais e segue em frente.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

confirm() {
  local prompt="$1"
  if [[ ! -t 0 ]]; then
    return 0
  fi
  local reply
  read -rp "$prompt [S/n] " reply
  [[ -z "$reply" || "$reply" =~ ^[SsYy] ]]
}

is_wsl() {
  grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null
}

if is_wsl && command -v powershell.exe >/dev/null 2>&1; then
  echo "==> WSL2 detectado — a fonte precisa ir pro Windows, não pro Linux."
  if confirm "Instalar MesloLGS NF no Windows agora via powershell.exe?"; then
    WIN_PATH="$(wslpath -w "$REPO_ROOT/fonts/install-fonts.ps1")"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$WIN_PATH"
  else
    echo "    Pulado. Rode depois: powershell.exe -ExecutionPolicy Bypass -File \"$(wslpath -w "$REPO_ROOT/fonts/install-fonts.ps1")\""
  fi
elif ! is_wsl && [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]]; then
  echo "==> Sessão gráfica Linux detectada — instalando fonte localmente."
  "$REPO_ROOT/fonts/install-fonts.sh"
else
  cat <<EOF
==> Não consegui detectar automaticamente onde instalar a fonte.

Se você acessa este ambiente via SSH a partir de outra máquina, rode
na MÁQUINA LOCAL (de onde você conecta), não aqui:

  fonts/install-fonts.sh          # Linux local
  fonts/install-fonts.ps1         # Windows local (PowerShell)

Depois selecione "MesloLGS NF" nas preferências do seu terminal.
EOF
fi
