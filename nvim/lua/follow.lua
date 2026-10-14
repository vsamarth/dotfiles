-- When the open file changes on disk (Claude edited it), optionally jump to the first changed line and flash it.
local M = { on = false }
local snap, ns = {}, vim.api.nvim_create_namespace("follow")

local function remember(buf)
  if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
    snap[buf] = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
  end
end

function M.toggle()
  M.on = not M.on
  vim.notify("follow edits: " .. (M.on and "on" or "off"))
  vim.defer_fn(function() vim.cmd("echo ''") end, 1500)
  vim.cmd("redrawstatus")
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, { callback = function(ev) if not snap[ev.buf] then remember(ev.buf) end end })
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function(ev)
    local buf, old = ev.buf, snap[ev.buf]
    local new = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
    snap[buf] = new
    if not (M.on and old) then return end
    local hunks = vim.diff(old, new, { result_type = "indices" })
    if #hunks == 0 then return end
    local start, count = hunks[1][3], math.max(hunks[1][4], 1)
    start = math.max(start, 1)
    local win = vim.fn.bufwinid(buf)
    if win == -1 then return end
    vim.api.nvim_win_set_cursor(win, { math.min(start, vim.api.nvim_buf_line_count(buf)), 0 })
    vim.api.nvim_win_call(win, function() vim.cmd("normal! zz") end)
    vim.hl.range(buf, ns, "Visual", { start - 1, 0 }, { start - 1 + count, 0 }, { linewise = true, timeout = 900 })
  end,
})

return M
