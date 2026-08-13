vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

if not vim.g.vscode then
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
    { 'nvim-mini/mini.basics', config = true },
    { 'nvim-mini/mini.pairs', config = true },
    { 'nvim-mini/mini.surround', config = true },
    {
      'lewis6991/gitsigns.nvim',
      opts = {
        on_attach = function(bufnr)
          local gs = require 'gitsigns'
          local function bind(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
          end
          bind(']h', gs.next_hunk, 'Next changed hunk')
          bind('[h', gs.prev_hunk, 'Previous changed hunk')
          bind('<leader>hp', gs.preview_hunk, 'Preview changed hunk')
          bind('<leader>hs', gs.stage_hunk, 'Stage changed hunk')
          bind('<leader>hu', gs.undo_stage_hunk, 'Undo staged hunk')
          bind('<leader>hr', gs.reset_hunk, 'Discard changed hunk')
          bind('<leader>hb', gs.blame_line, 'Show line history')
        end,
      },
    },
    {
      'sindrets/diffview.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      keys = {
        { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Review working-tree diff' },
        { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Review file history' },
        { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Close diff review' },
      },
    },
    {
      'stevearc/oil.nvim',
      opts = { view_options = { show_hidden = true } },
      keys = { { '-', '<cmd>Oil<cr>', desc = 'Browse containing directory' } },
    },
    {
      'ellisonleao/gruvbox.nvim',
      priority = 1000,
      opts = {
        contrast = 'hard',
        overrides = { Folded = { link = 'Comment' }, SignColumn = { link = 'Normal' }, Pmenu = { link = 'Normal' }, PmenuBorder = { link = 'GruvboxBg4' } },
      },
    },
    { 'nvim-lualine/lualine.nvim', opts = { options = { icons_enabled = false, section_separators = '', component_separators = '|' } } },
    {
      'nvim-treesitter/nvim-treesitter',
      branch = 'master',
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
end

-- Settings {{{

if not vim.g.vscode then
  vim.cmd 'colorscheme gruvbox'
end

-- General
vim.opt.numberwidth = 5
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.opt.undofile = true -- Enable persistent undo
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true

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

-- Keybindings {{{
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

map('n', '<leader>q', '<cmd>copen<cr>', 'Open quickfix results')
map('n', '[q', '<cmd>cprevious<cr>', 'Previous quickfix result')
map('n', ']q', '<cmd>cnext<cr>', 'Next quickfix result')
map('n', '<leader>sv', function()
  vim.cmd 'vsplit'
end, 'Vertical split')
map('n', '<leader>s-', function()
  vim.cmd 'split'
end, 'Horizontal split')

map('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.wo.linebreak = vim.wo.wrap
end, 'Toggle prose wrapping')
-- }}}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
