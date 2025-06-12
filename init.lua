-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Remove Background
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")
  end
})

-- Load file changes from outside nvim
vim.opt.autoread = true
local checktime_group = vim.api.nvim_create_augroup("CheckTime", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = checktime_group,
  pattern = "*",
  command = "checktime"
})

-- Personal configuration
require("options")
require("mappings")

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  change_detection = { notify = false },
  -- Config to add later
})
