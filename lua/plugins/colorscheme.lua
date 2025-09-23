return {
  {
    "maxmx03/solarized.nvim",
    config = function(_, opts)
      require("solarized").setup(opts)
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized",
    },
  },
}
