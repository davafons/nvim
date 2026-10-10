local map = vim.keymap.set

vim.api.nvim_create_user_command("VimShortcuts", function()
  require("config.shortcuts").open()
end, { desc = "Open the searchable Vim shortcut guide" })
map("n", "<leader>h", "<cmd>VimShortcuts<cr>", { desc = "Vim shortcut guide" })

-- Match the old displayed-line movement, including counts.
map("n", "j", "gj", { silent = true, desc = "Down a displayed line" })
map("n", "k", "gk", { silent = true, desc = "Up a displayed line" })

map("n", "<leader><space>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("x", "<leader>p", [["_dP]], { desc = "Replace selection without replacing yank" })

-- Ctrl-w followed by Ctrl-direction moves the window itself.
map("n", "<C-w><C-h>", "<C-w>H", { desc = "Move window left" })
map("n", "<C-w><C-j>", "<C-w>J", { desc = "Move window down" })
map("n", "<C-w><C-k>", "<C-w>K", { desc = "Move window up" })
map("n", "<C-w><C-l>", "<C-w>L", { desc = "Move window right" })

-- Ordinary y/p keep Vim registers; clipboard copies are explicit.
map({ "n", "x" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

-- Shared split-resizing shortcuts from both configurations.
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
