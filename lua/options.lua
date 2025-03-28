-- ================    Indentation      ====================
vim.opt.tabstop = 2 -- Number of visual spaces per TAB vim.opt.shiftwidth = 2    -- When indenting with '>', use 2 spaces width
vim.opt.copyindent = true -- Copy previous indentation on auto indenting
vim.opt.autoindent = true -- Enable auto indentation
vim.opt.expandtab = true -- Tabs are spaces
vim.opt.smarttab = true -- Insert tabs according to shiftwidth, not tabstop
vim.opt.shiftround = true -- Use multiples of shiftwidth when indenting

-- ================   General Config   ====================
vim.opt.cursorline = true -- Highlight current line
vim.opt.showcmd = true -- Show as commands are typed
vim.opt.wildmenu = true -- Visual autocomplete for command menu
vim.opt.showmatch = true -- Show matching parenthesis
vim.opt.laststatus = 2 -- Always display status line
vim.opt.showmode = false -- Don't show --INSERT-- --NORMAL-- modes
vim.opt.hidden = true -- Hide buffers instead of closing
vim.opt.title = true -- Show terminal's title
vim.opt.errorbells = false -- No error beep
vim.opt.textwidth = 99 -- Force wrap lines at 89
vim.opt.colorcolumn = "100" -- Show column limit at line 89
vim.opt.number = true -- Number line
vim.opt.relativenumber = true -- Hybrid number line
vim.opt.updatetime = 300 -- Time to autosave swap file when no changes are done

-- Don't continue comment on newline
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

-- Autoformat on save
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("lsp", { clear = true }),
--   callback = function(args)
--     -- 2
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       -- 3
--       buffer = args.buf,
--       callback = function()
--         -- 4 + 5
--         vim.lsp.buf.format { async = false, id = args.data.client_id }
--       end,
--     })
--   end
-- })

-- ================     Searching      ====================
vim.opt.incsearch = true -- Search as characters are entered
vim.opt.hlsearch = true -- Highlight matches
vim.opt.ignorecase = true -- Ignore cases on searches
vim.opt.smartcase = true -- Search lo/up case if no upper-case entered
vim.opt.wildignore = { "*/__pycache__/*" } -- Paths to ignore

-- ================       Buffer       ====================
vim.opt.history = 1000 -- Remember more commands and search history
vim.opt.undolevels = 1000 -- Allow a lot of undo levels
vim.opt.undofile = true -- Create undo files
vim.opt.undodir = "~/.vim/undodir" -- Directory to store undo files

-- ================  File extensions   ====================
vim.cmd([[ au BufRead,BufNewFile *.egg set filetype=egg ]])

-- Correct filetype for docker-compose files
local function set_filetype(pattern, filetype)
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = pattern,
    command = "set filetype=" .. filetype,
  })
end

set_filetype({ "docker-compose.yml" }, "yaml.docker-compose")
set_filetype({ "docker-compose.yaml" }, "yaml.docker-compose")
