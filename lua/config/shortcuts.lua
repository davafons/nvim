local M = {}
local guide

function M.open()
  if guide and vim.api.nvim_buf_is_valid(guide) then
    local wins = vim.fn.win_findbuf(guide)
    if #wins > 0 then
      vim.api.nvim_set_current_win(wins[1])
      return
    end
  end

  local lines = vim.fn.readfile(vim.fn.stdpath("config") .. "/doc/shortcuts.md")
  -- A separate tab keeps modified files, splits and the dashboard intact.
  vim.cmd("tab split")
  guide = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(guide, "Vim shortcuts")
  vim.api.nvim_buf_set_lines(guide, 0, -1, false, lines)
  vim.bo[guide].bufhidden = "wipe"
  vim.bo[guide].swapfile = false
  vim.bo[guide].modifiable = false
  vim.bo[guide].readonly = true
  vim.api.nvim_win_set_buf(0, guide)
  vim.bo[guide].filetype = "markdown"
  vim.wo.wrap = true
  vim.wo.spell = false
  vim.wo.foldmethod = "manual"
  vim.keymap.set("n", "q", function()
    if #vim.api.nvim_tabpage_list_wins(0) > 1 then
      vim.cmd.close()
    elseif #vim.api.nvim_list_tabpages() > 1 then
      vim.cmd.tabclose()
    else
      vim.cmd.enew()
    end
  end, { buffer = guide, silent = true, desc = "Close shortcut guide" })
end

return M
