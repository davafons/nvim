return {
  "folke/which-key.nvim",
  commit = "3aab2147e74890957785941f0c1ad87d0a44c15a",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    delay = 300,
    icons = { mappings = false },
    spec = {
      { "<leader>a", group = "Agent context" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Diagnostics" },
      { "<leader>j", group = "jj review" },
      { "<leader>r", group = "Rails" },
      { "<leader>q", group = "Sessions" },
      { "<leader>m", group = "Markdown" },
      { "<leader>t", group = "Search and symbols" },
      { "<leader>x", group = "Diagnostic lists" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Show buffer keybindings",
    },
  },
}
