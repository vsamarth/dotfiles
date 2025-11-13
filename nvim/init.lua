vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Plugins {{{
-- Install lazy.nvim {{{
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
-- }}}

require('lazy').setup {
  { 'neovim/nvim-lspconfig' },
  { 'nvim-mini/mini.basics', config = true },
  { 'nvim-mini/mini.pairs', config = true },
  { 'nvim-mini/mini.surround', config = true },
  { 'lewis6991/gitsigns.nvim', config = true },
  { 'j-hui/fidget.nvim', config = true },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    opts = {
      contrast = 'hard',
      overrides = { Folded = { link = 'Comment' }, SignColumn = { link = 'Normal' }, Pmenu = { link = 'Normal' }, PmenuBorder = { link = 'GruvboxBg4' } },
    },
  },
  { 'okuuva/auto-save.nvim', cmd = 'ASToggle', event = { 'InsertLeave', 'TextChanged' }, config = true },
  { 'nvim-lualine/lualine.nvim', opts = { options = { icons_enabled = false, section_separators = '', component_separators = '|' } } },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets', 'folke/lazydev.nvim' },
    version = '1.*',
    opts = {
      keymap = { preset = 'default' },
      completion = { documentation = { auto_show = false } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { { 'mason-org/mason.nvim', config = true } },
    opts = { ensure_installed = { 'stylua', 'gopls', 'ruff', 'shfmt', 'goimports', 'biome', 'tailwindcss-language-server', 'clang-format', 'shellcheck' } },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        fish = { 'fish_indent' },
        sh = { 'shfmt' },
        go = { 'goimports', 'gofmt' },
        lua = { 'stylua' },
        python = { 'ruff' },
        rust = { 'rustfmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        javascript = { 'biome' },
        javascriptreact = { 'biome' },
        typescript = { 'biome' },
        typescriptreact = { 'biome' },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' } },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      local telescope = require 'telescope'
      local actions = require 'telescope.actions'

      telescope.setup {
        defaults = {
          prompt_prefix = '   ',
          selection_caret = '❯ ',
          sorting_strategy = 'ascending',
          path_display = { 'smart' },
          layout_config = {
            prompt_position = 'top',
            width = 0.9,
            height = 0.85,
            preview_cutoff = 120,
          },
          file_ignore_patterns = { '%.git/', 'node_modules', '%.lock' },
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
              ['<esc>'] = actions.close,
            },
            n = {
              ['q'] = actions.close,
            },
          },
        },
        pickers = {
          buffers = {
            theme = 'dropdown',
            previewer = false,
            sort_lastused = true,
            mappings = {
              i = { ['<C-d>'] = actions.delete_buffer },
              n = { ['dd'] = actions.delete_buffer },
            },
          },
          find_files = {
            theme = 'dropdown',
            previewer = false,
            hidden = true,
            follow = true,
          },
          live_grep = {
            theme = 'ivy',
            additional_args = function()
              return { '--hidden' }
            end,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
    end,
    keys = {
      {
        ';',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = '[ ] Find existing buffers',
      },
      {
        '<leader><leader>',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>sd',
        function()
          require('telescope.builtin').diagnostics()
        end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sg',
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sh',
        function()
          require('telescope.builtin').help_tags()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sr',
        function()
          require('telescope.builtin').resume()
        end,
        desc = '[S]earch [R]esume',
      },
    },
  },
}

--}}}

-- Settings {{{

vim.cmd 'colorscheme gruvbox'

-- General
vim.opt.numberwidth = 5
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.opt.undofile = true -- Enable persistent undo
vim.opt.updatetime = 250 -- Decrease update time

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Editing
vim.opt.breakindent = true
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.confirm = true
-- }}}

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

map('n', '<leader>ff', function()
  require('telescope.builtin').find_files()
end, 'Find files')

map('n', '<leader>fg', function()
  require('telescope.builtin').live_grep()
end, 'Live grep')

map('n', '<leader>fb', function()
  require('telescope.builtin').buffers()
end, 'Find buffers')

map('n', '<leader>fh', function()
  require('telescope.builtin').help_tags()
end, 'Help tags')

map('n', '<leader>e', vim.diagnostic.open_float, 'Line diagnostics')
map('n', '[d', vim.diagnostic.goto_prev, 'Prev diagnostic')
map('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')

map('n', '<leader>q', vim.diagnostic.setloclist, 'Diagnostics loclist')
map('n', '<leader>sv', function()
  vim.cmd 'vsplit'
end, 'Vertical split')
map('n', '<leader>sh', function()
  vim.cmd 'split'
end, 'Horizontal split')


map('n', '<leader>rn', vim.lsp.buf.rename, 'LSP rename')
map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
map('n', 'gd', vim.lsp.buf.definition, 'Goto definition')
map('n', 'gD', vim.lsp.buf.declaration, 'Goto declaration')
map('n', 'gi', vim.lsp.buf.implementation, 'Goto implementation')
map('n', 'gr', vim.lsp.buf.references, 'Goto references')
map('n', '<leader>f', function()
  require('conform').format({async = true, lsp_fallback = true})
end, 'Format buffer')
-- }}}

-- LSP {{{
vim.lsp.enable { 'clangd', 'gopls' }

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

-- }}}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
