-- Read-only code viewer for the pane next to the agent. Files cannot be edited unless NVV_EDIT=1.
-- NVV_DEV=1 restarts nvim in place whenever this config changes (see lua/dev.lua).
vim.g.mapleader = " "
local o = vim.o
o.termguicolors = true
o.number, o.relativenumber = true, false
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 8
o.wrap, o.linebreak, o.breakindent = true, true, true
o.showbreak = "↪ "
o.laststatus = 3
o.showmode, o.ruler = false, false
o.cmdheight = 1 -- an empty row under the bar; with 0 Ghostty paints the chip colours into the leftover pixels below
o.mouse = "a"
o.ignorecase, o.smartcase = true, true
o.splitright, o.splitbelow = true, true
o.autoread = true
o.updatetime = 250
o.swapfile, o.backup, o.writebackup = false, false, false
o.fillchars = "eob: ,vert:│"

-- Viewing only: buffers cannot be edited or saved (set NVV_EDIT=1 to allow it).
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "" and not vim.env.NVV_EDIT then
      vim.bo[ev.buf].modifiable = false
      vim.bo[ev.buf].readonly = true
    end
  end,
})

-- Pick up edits made by other programs (Claude) quickly.
local timer = vim.uv.new_timer()
timer:start(500, 500, vim.schedule_wrap(function()
  if vim.fn.mode() == "n" then vim.cmd("silent! checktime") end
end))
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, { command = "silent! checktime" })

require("lazy_boot")
require("keymaps")
require("follow")
if vim.env.NVV_DEV then require("dev") end
