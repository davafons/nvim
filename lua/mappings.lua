local opts = { noremap = true }

-- ================  Leader      ====================
vim.g.mapleader = ","

-- ================  Movement    ====================
-- Move through visual lines
vim.keymap.set("n", "j", "gj", { silent = true, noremap = true })
vim.keymap.set("n", "k", "gk", { silent = true, noremap = true })

-- Faster window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Move windows
vim.keymap.set("n", "<C-w><C-h>", "<C-w>H", opts)
vim.keymap.set("n", "<C-w><C-j>", "<C-w>J", opts)
vim.keymap.set("n", "<C-w><C-k>", "<C-w>K", opts)
vim.keymap.set("n", "<C-w><C-l>", "<C-w>L", opts)

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Move to next/prev buffer
vim.keymap.set("n", "<A-j>", ":bprev<CR>", opts)
vim.keymap.set("n", "<A-k>", ":bnext<CR>", opts)

-- ================  Shortcuts   ====================
-- Quickly edit/reload the vimrc file
vim.keymap.set("n", "<Leader>ye", ":e $MYVIMRC<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<Leader>ys", ":source $MYVIMRC<CR>", { silent = true, noremap = true })

-- Disable search highlight
vim.keymap.set("n", "<Leader><space>", ":nohlsearch<CR>", { silent = true, noremap = true })

-- Easy close current buffer
vim.keymap.set("n", "<Leader>bd", ":bd<CR>", opts)

-- Esc with C-c
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Use system clipboard with leader
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- paste the word in x mode, but doesn't override the yank content
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Shortcuts for split window
vim.keymap.set("n", "<Leader>s", ":vsplit<CR>", opts)
vim.keymap.set("n", "<Leader>S", ":split<CR>", opts)

-- ================     LSP      ====================
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local lspOpts = { buffer = event.buf }

    vim.keymap.set("n", "K", vim.lsp.buf.hover, lspOpts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, lspOpts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, lspOpts)
    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, lspOpts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, lspOpts)
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, lspOpts)
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, lspOpts)
    vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, lspOpts)

    -- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
    vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float)

    -- we use zz, so we need to use <cmd>
    -- vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>zz")
    -- vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>zz")
  end,
})
