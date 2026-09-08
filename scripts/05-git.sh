#!/usr/bin/env bash
# Instala o git (se necessário) e configura a identidade global de
# forma interativa — assim o script funciona pra qualquer usuário ou
# máquina, sem hardcodar nome/email de ninguém no repositório.
set -euo pipefail

if ! command -v git >/dev/null 2>&1; then
  echo "==> Instalando git"
  sudo apt update
  sudo apt install -y git
else
  echo "==> git já instalado ($(git --version))"
fi

current_name="$(git config --global user.name 2>/dev/null || true)"
current_email="$(git config --global user.email 2>/dev/null || true)"

if [[ -n "$current_name" && -n "$current_email" ]]; then
  echo "==> git já configurado: $current_name <$current_email>"
  exit 0
fi

if [[ ! -t 0 ]]; then
  echo "==> Sem terminal interativo, pulando configuração de user.name/user.email."
  echo "    Configure manualmente depois: git config --global user.name \"Seu Nome\""
  echo "                                  git config --global user.email \"seu@email\""
  exit 0
fi

echo "==> Configuração de identidade do git (usada nos commits)"
if [[ -z "$current_name" ]]; then
  read -rp "Nome para git commits: " name
  git config --global user.name "$name"
fi
if [[ -z "$current_email" ]]; then
  read -rp "Email para git commits: " email
  git config --global user.email "$email"
fi

git config --global init.defaultBranch main

echo "==> git configurado: $(git config --global user.name) <$(git config --global user.email)>"
