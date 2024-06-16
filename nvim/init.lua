-- Set <space> as the leader key and `\` as the localleader key
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- [[ Settings ]] {{{
-- Make line numbers default
vim.opt.number = true
vim.opt.numberwidth = 5

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { trail = '·', nbsp = '␣', tab = '  ' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- }}}

-- [[ Autocommands ]] {{{
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- }}}

-- [[ Plugins ]]] {{{

-- Install lazy.nvim {{{
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
-- }}}

require('lazy').setup({

  -- User Interface
  { -- Use gruvbox as the colorscheme
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        contrast = 'hard',
        overrides = {
          Folded = { link = 'Comment' },
          SignColumn = { link = 'Normal' },
          Pmenu = { link = 'Normal' },
          PmenuBorder = { link = 'GruvboxBg4' },
        },
      }
      vim.cmd 'colorscheme gruvbox'
    end,
  },
  { -- Statusline at the bottom of buffers
    -- TODO: Remove components not required
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        section_separators = '',
        component_separators = '|',
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
    },
  },
  -- Git
  { -- Show git signs in the signcolumn
    'lewis6991/gitsigns.nvim',
    config = true,
  },
  -- Essentials
  { -- Saves files automatically
    'okuuva/auto-save.nvim',
    cmd = 'ASToggle',
    event = { 'InsertLeave', 'TextChanged' },
    opts = {
      enabled = true,
      execution_message = {
        enabled = false,
      },
    },
  },
  { -- Fuzzy finder for files, lsp etc.
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
  },
  { -- LSP
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'stevearc/conform.nvim',
    },
  },
  { -- LSP configuration for lua
    'folke/neodev.nvim',
    opts = {},
  },
  { -- Code completion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },
}, {
  install = {
    colorscheme = { 'gruvbox', 'habamax' },
  },
  ui = {
    icons = {
      -- TODO: Figure out a way to have no icons at all!
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
-- }}}

-- [[ Keybindings ]] {{{
local function map(mode, l, r, desc, opts)
  opts = opts or {}
  opts.desc = desc

  vim.keymap.set(mode, l, r, opts)
end

map('i', 'jk', '<Esc>')

-- Jump to todo comments
map('n', ']t', require('todo-comments').jump_next)
map('n', '[t', require('todo-comments').jump_prev)

-- }}}

-- [[ LSP ]] {{{

local lspconfig = require 'lspconfig'
require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

require('mason').setup {}
local handlers = {
  function(server_name)
    lspconfig[server_name].setup {}
  end,
}

require('mason-lspconfig').setup {
  handlers = handlers,
}

-- }}}

-- [[ Completion ]] {{{

local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = { completeopt = 'menu,menuone,noinsert' },
  view = {
    entries = 'custom',
  },
  window = {
    completion = {
      border = 'rounded',
      winhighlight = 'Normal:Pmenu,FloatBorder:PmenuBorder',
    },
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
}

-- }}}

-- [[ Telescope ]] {{{
require('telescope').setup {}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')

local builtin = require 'telescope.builtin'

map('n', '<leader>sh', builtin.help_tags)
map('n', '<leader><leader>', builtin.find_files)

-- }}}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
