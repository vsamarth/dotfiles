-- Dev mode (NVV_DEV=1): restart in place whenever this config changes, keeping the file and cursor.
local uv = vim.uv
local root = vim.fn.stdpath("config")
local handle, timer = uv.new_fs_event(), uv.new_timer()
handle:start(root, { recursive = true }, function(err, name)
  if err or not name or name:match("^%.git") or name:match("^hill/") or name:match("^scratch/") or name:match("lazy%-lock") then return end
  timer:stop()
  timer:start(400, 0, vim.schedule_wrap(function()
    if vim.fn.mode() == "n" then vim.cmd("restart") end
  end))
end)
