-- Status line: rectangular chips with a one-column gap. VIEW, file and branch on the left; follow/auto flags on the right when on.
local function view() return "VIEW" end
local function flags()
  local out = {}
  if require("follow").on then out[#out + 1] = "follow" end
  if package.loaded["autoopen"] and require("autoopen").on then out[#out + 1] = "auto" end
  return table.concat(out, " · ")
end

return {
  "nvim-lualine/lualine.nvim", event = "VeryLazy",
  opts = function()
    -- Gap chip takes the bar's current background, so it follows light/dark.
    local function bar_bg()
      local bg = vim.api.nvim_get_hl(0, { name = "lualine_c_normal", link = false }).bg
      return { bg = bg and string.format("#%06x", bg) or "NONE" }
    end
    local gap = { function() return " " end, color = bar_bg, padding = 0 }
    return {
      options = { theme = "melange", globalstatus = true, section_separators = "", component_separators = "" },
      sections = {
        lualine_a = { view },
        lualine_b = { gap, { "filename", path = 1, symbols = { modified = "", readonly = "", unnamed = "[no file]" } } },
        lualine_c = { gap, { "branch", icon = "\u{e0a0}" } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { gap, { flags, cond = function() return flags() ~= "" end } },
      },
    }
  end,
}
