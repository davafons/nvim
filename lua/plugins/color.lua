return {
  {
    "davafons/nvim-highlight-colors",
    event = "VeryLazy",
    config = function()
      require("nvim-highlight-colors").setup({})
    end,
  },
}
