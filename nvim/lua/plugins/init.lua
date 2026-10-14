return {
  { "savq/melange-nvim", lazy = false, priority = 1000, config = function() vim.cmd.colorscheme("melange") end },
  {
    "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate",
    config = function()
      local langs = { "lua", "typescript", "tsx", "javascript", "json", "yaml", "toml", "markdown", "markdown_inline", "bash", "python", "rust", "go", "css", "html", "diff", "vim", "vimdoc" }
      local have = {}
      for _, l in ipairs(require("nvim-treesitter").get_installed()) do have[l] = true end
      local missing = vim.tbl_filter(function(l) return not have[l] end, langs)
      if #missing > 0 then require("nvim-treesitter").install(missing) end
      -- Compiling injection queries costs 20-70 ms per language and a viewer rarely needs embedded-language
      -- colours there, so skip them (Markdown keeps its code-fence injections).
      for _, l in ipairs({ "typescript", "tsx", "javascript", "bash", "python", "rust", "yaml" }) do
        vim.treesitter.query.set(l, "injections", "")
      end
      vim.api.nvim_create_autocmd("FileType", { callback = function() pcall(vim.treesitter.start) end })
    end,
  },
  {
    "lewis6991/gitsigns.nvim", event = "BufReadPost",
    opts = {
      current_line_blame = false,
      current_line_blame_opts = { delay = 200 },
      signs = { add = { text = "▎" }, change = { text = "▎" }, delete = { text = "▁" }, topdelete = { text = "▔" }, changedelete = { text = "▎" } },
      signs_staged_enable = false,
    },
  },
  {
    "nvim-telescope/telescope.nvim", cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, "stevearc/aerial.nvim" },
    config = function()
      require("aerial").setup({ backends = { "treesitter", "markdown" } })
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          prompt_prefix = "  ",
          selection_caret = "▎ ",
          entry_prefix = "  ",
          results_title = false,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          file_ignore_patterns = { "^%.git/", "node_modules/" },
          path_display = { "truncate" },
        },
        pickers = { find_files = { hidden = true, find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" } } },
      })
      pcall(require("telescope").load_extension, "fzf")
      require("telescope").load_extension("aerial")
    end,
  },
  { "MeanderingProgrammer/render-markdown.nvim", ft = "markdown", opts = { code = { sign = false }, heading = { sign = false } } },
}
