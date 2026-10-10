-- Separate plugin, parser and tool installs keep the backed-up LazyVim runtime usable.
local data = vim.fn.stdpath("data") .. "/personal"
return { data = data, lazy = data .. "/lazy", mason = data .. "/mason", site = data .. "/site" }
