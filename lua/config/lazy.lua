-- lazy.nvim is the standalone plugin manager; plugin specs do not import LazyVim.
local paths = require("config.paths")
local lazypath = paths.lazy .. "/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.mkdir(paths.lazy, "p")
  local cloned = vim
    .system({
      "git",
      "clone",
      "--filter=blob:none",
      "--no-checkout",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    }, { text = true })
    :wait()
  if cloned.code ~= 0 then
    error("Could not install lazy.nvim: " .. (cloned.stderr or ""))
  end
  -- This checkout is the new plugin repository created above.
  local checkout = vim
    .system({
      "git",
      "-C",
      lazypath,
      "checkout",
      "--detach",
      "85c7ff3711b730b4030d03144f6db6375044ae82",
    }, { text = true })
    :wait()
  if checkout.code ~= 0 then
    error("Could not select lazy.nvim version: " .. (checkout.stderr or ""))
  end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  root = paths.lazy,
  spec = { { import = "plugins" } },
  defaults = { lazy = true },
  install = { colorscheme = { "solarized", "habamax" } },
  checker = { enabled = false },
  change_detection = { notify = false },
})
