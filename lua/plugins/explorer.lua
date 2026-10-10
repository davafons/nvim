return {
  {
    "nvim-tree/nvim-tree.lua",
    commit = "355bcc85a48f45b3e728219f10b880d569928965",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      filters = { dotfiles = false },
      git = { enable = false },
      on_attach = function(buf)
        local api = require("nvim-tree.api")
        api.map.on_attach.default(buf)
        -- Leave Ctrl-k to the shared Neovim/Herdr navigation mapping.
        vim.keymap.del("n", "<C-k>", { buffer = buf })
        vim.keymap.set("n", "?", api.tree.toggle_help, { buffer = buf, desc = "Tree help", nowait = true })
      end,
    },
  },
}
