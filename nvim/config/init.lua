-- 1. Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Compatibilidade nvim 0.12: ft_to_lang foi removida mas Telescope ainda a usa
if vim.treesitter and vim.treesitter.language and not vim.treesitter.language.ft_to_lang then
  vim.treesitter.language.ft_to_lang = function(ft) return ft end
end

-- 2. Opções de UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.g.mapleader = " "

-- 3. Plugins
require("lazy").setup({
  -- Tema (carrega imediatamente, precisa de priority alta)
  {
    "gmr458/vscode_modern_theme.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode_modern").setup({
        cursorline = true,
        transparent_background = false,
        nvim_tree_darker = true,
      })
      vim.cmd.colorscheme("vscode_modern")
    end,
  },

  -- Ícones (depedência comum, carrega junto com quem precisar)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Árvore de arquivos (só carrega ao chamar o comando)
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus" },
    opts = {
      update_focused_file = {
        enable = true,
        update_root = false,
      },
    },
  },

  -- LSP: Mason (carrega no startup para instalar servidores)
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", config = true },
  { "neovim/nvim-lspconfig" },

  -- Git: gitsigns (carrega ao abrir arquivo existente)
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = true,
  },

  -- Colorizer: Preview de cores hex e CSS
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background", -- 'background', 'foreground' ou 'virtualtext'
        tailwind = true,
      },
    },
  },

  -- Git: Neogit (só carrega ao abrir)
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = true,
  },

  -- Treesitter (carrega após buffer ser lido)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if ok then
        ts.setup({
          ensure_installed = { "typescript", "tsx", "javascript", "lua" },
          highlight = { enable = true },
        })
      end
    end,
  },

  -- Telescope (carrega ao usar os atalhos ou comando)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    cmd = "Telescope",
    -- Keymaps declarados aqui: lazy gerencia o ciclo de vida corretamente
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end,  desc = "Buscar Arquivos" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,   desc = "Buscar Texto no Projeto" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,     desc = "Ver Buffers abertos" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          -- Desabilita treesitter no previewer (evita erro ft_to_lang no nvim 0.12)
          preview = { treesitter = false },
        },
      })
    end,
  },
})

-- 4. LSP (nvim 0.12+): config() define opções, enable() ativa o servidor
if vim.lsp.config then
  vim.lsp.config("vtsls", {})
  vim.lsp.enable("vtsls")

else
  local lspconfig = require("lspconfig")
  lspconfig.vtsls.setup({})
end

-- 5. Atalhos
vim.keymap.set("n", "<leader>e",  ":NvimTreeToggle<CR>", { desc = "Toggle árvore de arquivos" })
vim.keymap.set("n", "<leader>gg",  ":Neogit<CR>",         { desc = "Abrir Neogit" })
vim.keymap.set("n", "<leader>cp", function() vim.fn.setreg("+", vim.fn.expand("%"))    end, { desc = "Copiar caminho relativo" })
vim.keymap.set("n", "<leader>cP", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end, { desc = "Copiar caminho absoluto" })
vim.keymap.set("v", "<leader>cs", '"+y', { desc = "Copiar seleção para clipboard" })

-- 6. @ File Picker: <leader>@ no modo normal insere @caminho no cursor
vim.keymap.set("n", "<leader>@", function()
  require("telescope.builtin").find_files({
    prompt_title = "@ Arquivo",
    attach_mappings = function(prompt_bufnr, _)
      local actions = require("telescope.actions")
      local state   = require("telescope.actions.state")
      actions.select_default:replace(function()
        local sel = state.get_selected_entry()
        actions.close(prompt_bufnr)
        local path = sel and (sel[1] or sel.value) or ""
        vim.api.nvim_put({ path }, "c", true, true)
      end)
      return true
    end,
  })
end, { desc = "@ — File picker (insere @caminho)" })

-- 7. LSP: keymaps ativos apenas quando um servidor está anexado ao buffer
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local map = function(key, fn, desc)
      vim.keymap.set("n", key, fn, { buffer = args.buf, desc = desc })
    end
    map("<leader>gd", vim.lsp.buf.definition,      "Ir à definição (F12)")
    map("<leader>gr", vim.lsp.buf.references,       "Ver referências")
    map("<leader>gi", vim.lsp.buf.implementation,   "Ir à implementação")
    map("<leader>rn", vim.lsp.buf.rename,           "Renomear símbolo")
    map("K",          vim.lsp.buf.hover,            "Documentação (hover)")
  end,
})
