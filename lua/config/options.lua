-- Personal pre-LazyVim defaults, with the exceptions selected in the walkthrough.
vim.g.mapleader = ","
vim.opt.termguicolors = true
vim.opt.autoread = true
vim.opt.undofile = true
local undo_dir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undo_dir, "p")
vim.opt.undodir = undo_dir
vim.opt.spell = false

-- Shared by the personal config and LazyVim, plus the selected conflicts.
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.copyindent = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.hidden = true
vim.opt.showmode = false
vim.opt.clipboard = ""
vim.opt.autowrite = false
vim.opt.autowriteall = false
vim.opt.wrap = true
vim.opt.textwidth = 99
vim.opt.colorcolumn = "100"
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.showmatch = true
vim.opt.title = true
vim.opt.errorbells = false
vim.opt.updatetime = 300
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.wildignore = { "*/__pycache__/*" }
vim.opt.history = 1000
vim.opt.undolevels = 10000
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.laststatus = 3
vim.opt.confirm = true

-- Keep the old placement and movement defaults explicit.
vim.opt.splitbelow = false
vim.opt.splitright = false
vim.opt.splitkeep = "cursor"
vim.opt.signcolumn = "auto"
vim.opt.scrolloff = 0
vim.opt.sidescrolloff = 0
vim.opt.smartindent = false

-- Filetype plugins can reset formatoptions, so apply this after they load.
local group = vim.api.nvim_create_augroup("PersonalEditor", { clear = true })
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  group = group,
  callback = function(event)
    vim.bo[event.buf].formatoptions = vim.bo[event.buf].formatoptions:gsub("[cro]", "")
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 40 })
  end,
})

vim.filetype.add({
  extension = { egg = "egg" },
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
})
