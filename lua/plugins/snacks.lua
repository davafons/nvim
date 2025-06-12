return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    dashboard = { enabled = true },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
        },
        files = {
          hidden = true,
          ignored = true,
        },
      },
      enabled = true,
      hidden = true,
      ignored = true,
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    statuscolumn = { enabled = true },
    gitbrowse = { enabled = true },
    lazygit = { enabled = true },

    bigfile = { enabled = false },
    input = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    words = { enabled = false },
  },
  keys = {
    -- Top Pickers & Explorer
    {
      "<leader>f",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    {
      "<leader>v",
      function()
        Snacks.explorer.reveal()
      end,
      desc = "File Explorer",
    },
    {
      "<leader>tt",
      function()
        Snacks.picker.files()
      end,
      desc = "Picker Files",
    },
    {
      "<leader>tg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Picker Grep",
    },
    {
      "<leader>th",
      function()
        Snacks.picker.help()
      end,
      desc = "Picker help",
    },
    {
      "<leader>tv",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find Config File",
    },
    {
      "<leader>tc",
      function()
        Snacks.picker.colorschemes({ layout = "ivy" })
      end,
      desc = "Colorschemes",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
  },
}
