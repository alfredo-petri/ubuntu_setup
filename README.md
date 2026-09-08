# ubuntu_setup

Instalação e configuração de terminal para desenvolvimento: Zsh (Oh My
Zsh + Powerlevel10k + plugins), Neovim, Node (via NVM), git, GitHub CLI
e utilitários de terminal. Focado em CLI — nada aqui depende de um
desktop/window manager gráfico (pensado para uso via SSH ou WSL2).

oh-my-zsh, powerlevel10k, os plugins zsh, a fonte MesloLGS NF, o NVM e
o gh cli são clonados/baixados **direto dos repositórios oficiais** em
tempo de instalação, sempre pegando a versão mais recente. A única
coisa vendorizada de fato é a config do Neovim, para o setup não
depender do repositório pessoal do `nandobfer/nvim-config` (que pode
mudar ou sumir sem aviso).

Alguns itens vieram de uma triagem item a item do
[`nandobfer/ubuntu_configuration`](https://github.com/nandobfer/ubuntu_configuration)
— só o que faz sentido sem desktop gráfico (esse repo dele é
principalmente um "rice" de i3wm + extensões GNOME, fora do escopo
daqui).

Baseado nos guias [`zsh-setup.md`](https://github.com/alfredo-petri/guides/blob/master/dev-environment/zsh-setup.md) e [`nvim-setup.md`](https://github.com/alfredo-petri/guides/blob/master/dev-environment/nvim-setup.md) do repositório [`alfredo-petri/guides`](https://github.com/alfredo-petri/guides).

## Fontes de cada componente

| Componente | Origem | Como é obtido |
|---|---|---|
| Oh My Zsh | ohmyzsh/ohmyzsh | `git clone` oficial, em tempo de instalação |
| Powerlevel10k | romkatv/powerlevel10k | `git clone` oficial, em tempo de instalação |
| zsh-autosuggestions | zsh-users/zsh-autosuggestions | `git clone` oficial, em tempo de instalação |
| zsh-syntax-highlighting | zsh-users/zsh-syntax-highlighting | `git clone` oficial, em tempo de instalação |
| zsh-completions | zsh-users/zsh-completions | `git clone` oficial, em tempo de instalação |
| Fonte MesloLGS NF | romkatv/powerlevel10k-media | download oficial, em tempo de instalação |
| Neovim | neovim/neovim | AppImage oficial (apt do Ubuntu é desatualizado demais) |
| Config do Neovim | — | **vendorizada** em `nvim/config/` (fork estático do `nandobfer/nvim-config`) |
| Plugins do Neovim (lazy.nvim) / LSPs (mason) | GitHub diverso | baixados na primeira abertura do `nvim` — funcionamento normal dessas ferramentas |
| `zsh`, `ripgrep`, `fzf`, `xclip`, `htop`, `ffmpeg`, `fastfetch`, `git` | apt | repositórios oficiais do Ubuntu/Debian |
| GitHub CLI (`gh`) | cli.github.com | repositório apt oficial do GitHub |
| NVM + Node LTS | nvm-sh/nvm | `git clone` oficial, em tempo de instalação |
| `nodemon` | npm | pacote global via `npm install -g` |
| `tldr` | isacikgoz/tldr | binário oficial da última release, em tempo de instalação |
| Identidade do git (`user.name`/`user.email`) | — | configurada interativamente no primeiro uso, não hardcoded |

Nenhum plugin foi encontrado desabilitado na config original — todos os
plugins listados nos dois markdowns e no `nandobfer/nvim-config` estão
ativos (o `lazy-lock.json` bate 100% com os plugins declarados no
`init.lua`).

## Uso

Na máquina onde o shell vai rodar (servidor SSH, ou local — este
repositório trata as duas situações da mesma forma):

```bash
./install.sh           # instala tudo
./install.sh --zsh      # só zsh/oh-my-zsh/powerlevel10k/plugins
./install.sh --nvim     # só neovim + config
./install.sh --node     # só nvm + node LTS
./install.sh --git      # só git + identidade (interativo)
./install.sh --gh       # só GitHub CLI
./install.sh --tools    # só htop/ffmpeg/fastfetch/tldr/nodemon
```

`--git` faz perguntas interativas (nome/email para os commits) — rode
num terminal de verdade, não em automação.

Depois:

```bash
exec zsh
p10k configure
```

### Fonte MesloLGS NF (máquina local, de onde você acessa o terminal)

Só necessária se você acessa este ambiente via SSH a partir de outra
máquina (ou se este é o ambiente onde seu terminal roda visualmente).

```bash
fonts/install-fonts.sh          # Linux
```

```powershell
fonts\install-fonts.ps1         # Windows, como Administrador
```

Depois selecione **MesloLGS NF** nas preferências do emulador de
terminal (GNOME Terminal, Windows Terminal, iTerm2 etc — veja a
[seção 1 do zsh-setup.md](https://github.com/alfredo-petri/guides/blob/master/dev-environment/zsh-setup.md#1-fonte-meslogs-nf--m%C3%A1quina-local)
para o caminho exato de cada um).

## Idempotência

Os scripts pulam etapas já instaladas (`~/.oh-my-zsh`, tema, plugins,
`~/.config/nvim`) e fazem backup de `~/.zshrc` e `~/.config/nvim`
existentes antes de sobrescrever (`*.bak.<timestamp>`). Para
atualizar algo já instalado, apague o diretório correspondente (ou
rode `git pull` dentro dele, já que são clones git normais) e rode o
script de novo.

## Atualizar a config do Neovim vendorizada

`nvim/config` é uma cópia estática (sem `.git`) do
`nandobfer/nvim-config`. Para atualizar, clone a versão nova upstream,
remova o `.git` dela e substitua a pasta `nvim/config`, depois commit.

## Atalhos e referência

Ver [`zsh-setup.md`](https://github.com/alfredo-petri/guides/blob/master/dev-environment/zsh-setup.md)
e [`nvim-setup.md`](https://github.com/alfredo-petri/guides/blob/master/dev-environment/nvim-setup.md)
no repositório `guides` para atalhos, Vim Motions e troubleshooting
completos (as cópias na raiz deste repositório são só ponteiros).
