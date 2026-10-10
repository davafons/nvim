return {
  {
    "folke/todo-comments.nvim",
    commit = "31e3c38ce9b29781e4422fc0322eb0a21f4e8668",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "nvim-lua/plenary.nvim", commit = "74b06c6c75e4eeb3108ec01852001636d85a932b" },
    },
    opts = {},
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next TODO",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous TODO",
      },
      { "<leader>tT", "<cmd>TodoFzfLua<cr>", desc = "Search TODO comments" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "TODO list" },
    },
  },
  {
    "nvim-mini/mini.hipatterns",
    commit = "7c840c71d6a91f53d734cab2b6fe2290d285ec3b",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      return { highlighters = { hex_color = require("mini.hipatterns").gen_highlighter.hex_color() } }
    end,
  },
}
