vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Settings
vim.opt.number = true -- Show line numbers
vim.opt.numberwidth = 5 -- Line
vim.opt.mouse = "a" -- Enable mouse mode, useful for resizing splits
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Save undo history
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 4
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Keybindings
vim.keymap.set("i", "jk", "<Esc>")

-- Install lazy.nvim {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- }}}

require("lazy").setup({
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				contrast = "hard",
			})
			vim.cmd("colorscheme gruvbox")
			vim.api.nvim_set_hl(0, "Folded", { link = "Comment" })
			vim.api.nvim_set_hl(0, "SignColumn", { link = "Normal" })
		end,
	},
	{ "stevearc/conform.nvim", opts = { formatters_by_ft = { lua = { "stylua" } } } },
	{ "lewis6991/gitsigns.nvim", config = true },
	{ "nvim-lualine/lualine.nvim", opts = {
		options = {
			icons_enabled = false,
		},
	} },
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.align").setup()
			require("mini.surround").setup()
		end,
	},
	{ "hrsh7th/nvim-cmp", event = "InsertEnter", dependencies = { "hrsh7th/cmp-buffer" } },
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"okuuva/auto-save.nvim",
		cmd = "ASToggle", -- optional for lazy loading on command
		event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
		opts = {
			enabled = true,
			execution_message = {
				enabled = false,
			},
		},
	},
})

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

-- Telescope {{{
require("telescope").setup({
	defaults = {
		theme = "dropdown",
	},
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.find_files)

-- }}}

-- Completion {{{
local cmp = require("cmp")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
})
-- }}}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
