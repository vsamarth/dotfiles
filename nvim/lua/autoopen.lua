-- Optionally open whichever file in the project was just written, so the pane follows the agent file to file.
local M = { on = false }
local uv = vim.uv
local handle, pending

local function skip(rel)
  return rel:match("^%.git/") or rel:match("node_modules/") or rel:match("%.swp$") or rel:match("~$") or rel:match("^%.DS_Store")
end

local function open(rel)
  local full = vim.fs.joinpath(vim.fn.getcwd(), rel)
  local st = uv.fs_stat(full)
  if not st or st.type ~= "file" or st.size > 2 * 1024 * 1024 then return end
  if vim.bo.buftype ~= "" or vim.fn.mode() ~= "n" then return end
  if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") == full then return end
  vim.system({ "git", "check-ignore", "-q", full }, {}, vim.schedule_wrap(function(r)
    if r.code == 0 then return end
    if vim.fn.mode() == "n" and vim.bo.buftype == "" then vim.cmd("silent! edit " .. vim.fn.fnameescape(full)) end
  end))
end

function M.toggle()
  M.on = not M.on
  if M.on then
    handle = uv.new_fs_event()
    handle:start(vim.fn.getcwd(), { recursive = true }, function(err, name)
      if err or not name or skip(name) then return end
      if pending then pending:stop() pending:close() end
      pending = uv.new_timer()
      pending:start(300, 0, vim.schedule_wrap(function() open(name) end))
    end)
  elseif handle then
    handle:stop() handle:close() handle = nil
  end
  vim.notify("open edited files: " .. (M.on and "on" or "off"))
  vim.defer_fn(function() vim.cmd("echo ''") end, 1500)
  vim.cmd("redrawstatus")
end

return M
