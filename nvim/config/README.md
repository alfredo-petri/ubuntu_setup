# nvim-config

Configuração pessoal do Neovim otimizada para desenvolvimento TypeScript/React.
Requer **Neovim 0.12+** e **ripgrep** (`sudo apt install ripgrep`).

---

## Atalhos personalizados

> `<leader>` = **Espaço**

### Navegação e arquivos

| Atalho | Ação |
|---|---|
| `<leader>e` | Abrir/fechar árvore de arquivos |
| `<leader>ff` | Buscar arquivo pelo nome *(Ctrl+P no VSCode)* |
| `<leader>fg` | Buscar texto em todos os arquivos *(Ctrl+Shift+F no VSCode)* |
| `<leader>fb` | Listar buffers abertos |

### LSP — só funciona em arquivos com servidor ativo (`.ts`, `.tsx`)

| Atalho | Ação |
|---|---|
| `<leader>gd` | Ir à definição *(F12 no VSCode)* |
| `<leader>gr` | Ver todas as referências |
| `<leader>gi` | Ir à implementação |
| `<leader>rn` | Renomear símbolo |
| `K` | Documentação / hover |

### Git

| Atalho | Ação |
|---|---|
| `<leader>g` | Abrir Neogit (painel Git visual) |

### Utilitários

| Atalho | Ação |
|---|---|
| `<leader>cp` | Copiar caminho relativo do arquivo atual |
| `<leader>cP` | Copiar caminho absoluto do arquivo atual |
| `<leader>cs` | Copiar seleção para clipboard *(modo Visual)* |

### Quickfix (lista de referências/erros)

| Atalho / Comando | Ação |
|---|---|
| `:copen` | Abrir lista quickfix |
| `:cclose` | Fechar lista quickfix |
| `]q` | Próximo item |
| `[q` | Item anterior |

---

## Vim Motions — Cheatsheet

### Movimentação básica

| Tecla | Ação |
|---|---|
| `h` `j` `k` `l` | ← ↓ ↑ → |
| `w` | Início da próxima palavra |
| `b` | Início da palavra anterior |
| `e` | Final da palavra atual |
| `0` | Início da linha |
| `^` | Primeiro caractere não-espaço da linha |
| `$` | Final da linha |
| `gg` | Início do arquivo |
| `G` | Final do arquivo |
| `{` `}` | Parágrafo anterior / próximo |
| `Ctrl+d` | Descer meia página |
| `Ctrl+u` | Subir meia página |
| `%` | Ir para o par do `(` `)` `{` `}` `[` `]` |

### Busca no arquivo

| Tecla | Ação |
|---|---|
| `/texto` | Buscar texto para frente |
| `?texto` | Buscar texto para trás |
| `n` | Próxima ocorrência |
| `N` | Ocorrência anterior |
| `*` | Buscar palavra sob o cursor |
| `f{x}` | Ir até o próximo caractere `x` na linha |
| `t{x}` | Ir até antes do próximo caractere `x` na linha |
| `;` | Repetir último `f`/`t` |

### Modos

| Tecla | Ação |
|---|---|
| `i` | Entrar em modo Insert (antes do cursor) |
| `a` | Entrar em modo Insert (após o cursor) |
| `o` | Nova linha abaixo e entrar em Insert |
| `O` | Nova linha acima e entrar em Insert |
| `v` | Modo Visual (seleção por caractere) |
| `V` | Modo Visual (seleção por linha) |
| `Ctrl+v` | Modo Visual em bloco |
| `Esc` | Voltar para modo Normal |

### Edição

| Tecla | Ação |
|---|---|
| `dd` | Deletar linha |
| `yy` | Copiar linha |
| `p` | Colar após o cursor |
| `P` | Colar antes do cursor |
| `u` | Desfazer |
| `Ctrl+r` | Refazer |
| `x` | Deletar caractere sob o cursor |
| `r{x}` | Substituir caractere por `x` |
| `cc` | Deletar linha e entrar em Insert |
| `C` | Deletar do cursor até fim da linha e entrar em Insert |
| `D` | Deletar do cursor até fim da linha |
| `ciw` | Deletar palavra inteira e entrar em Insert *(change inner word)* |
| `ci"` | Deletar conteúdo entre aspas e entrar em Insert |
| `ci(` | Deletar conteúdo entre parênteses e entrar em Insert |
| `>>`/`<<` | Indentar / des-indentar linha |

### Múltiplas janelas

| Tecla | Ação |
|---|---|
| `Ctrl+w s` | Dividir horizontalmente |
| `Ctrl+w v` | Dividir verticalmente |
| `Ctrl+w h/j/k/l` | Navegar entre painéis |
| `Ctrl+w q` | Fechar painel atual |

### Comandos úteis

| Comando | Ação |
|---|---|
| `:w` | Salvar |
| `:q` | Fechar |
| `:wq` | Salvar e fechar |
| `:q!` | Fechar sem salvar |
| `:.,.+5d` | Deletar da linha atual até +5 linhas |
| `:%s/foo/bar/g` | Substituir `foo` por `bar` em todo o arquivo |

---

## Plugins

| Plugin | Função |
|---|---|
| **lazy.nvim** | Gerenciador de plugins com lazy loading — plugins carregam só quando necessário |
| **vscode_modern_theme** | Tema visual inspirado no VSCode |
| **nvim-web-devicons** | Ícones nos menus e árvore de arquivos |
| **nvim-tree** | Árvore de arquivos lateral |
| **mason** + **mason-lspconfig** | Instalador de servidores LSP (`:Mason` para abrir) |
| **nvim-lspconfig** | Integração com servidores de linguagem |
| **gitsigns** | Indicadores de mudanças git na margem do editor |
| **neogit** + **diffview** | Interface visual para Git (commits, diffs, branches) |
| **nvim-treesitter** | Syntax highlighting avançado com parsing real da linguagem |
| **telescope** | Buscador fuzzy para arquivos, texto, buffers e mais |

### Servidores LSP ativos

| Servidor | Linguagem |
|---|---|
| `vtsls` | TypeScript / JavaScript / React (TSX) |
