local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true }) end

-- Small centred list, no preview (picked in design round two).
local function finder(name, extra)
  return function()
    local opts = require("telescope.themes").get_dropdown(vim.tbl_deep_extend("force", { previewer = false }, extra or {}))
    if name == "aerial" then require("telescope").extensions.aerial.aerial(opts) else require("telescope.builtin")[name](opts) end
  end
end

map("q", "<cmd>qa<cr>", "Quit")
map("<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")
map("<leader>f", finder("find_files"), "Find file")
map("<leader>/", finder("live_grep"), "Search text")
map("<leader>g", finder("git_status"), "Changed files")
map("<leader>b", finder("buffers"), "Open files")
map("<leader>r", finder("oldfiles"), "Recent files")
map("<leader>o", finder("aerial"), "Outline")
map("<leader>k", finder("keymaps"), "Keys")
map("]c", function() require("gitsigns").nav_hunk("next") end, "Next change")
map("[c", function() require("gitsigns").nav_hunk("prev") end, "Previous change")
map("<leader>d", function() require("gitsigns").preview_hunk_inline() end, "Show change")
map("<leader>D", function() require("gitsigns").toggle_deleted() end, "Show deleted lines")
map("<leader>B", function() require("gitsigns").blame_line({ full = false }) end, "Blame line")
map("<leader>tb", function() require("gitsigns").toggle_current_line_blame() end, "Toggle blame on cursor line")
map("<leader>tf", function() require("follow").toggle() end, "Toggle follow edits")
map("<leader>ta", function() require("autoopen").toggle() end, "Toggle open edited files")
