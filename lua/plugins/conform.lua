return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      eruby = { "herb" },
    },
    formatters = {
      herb = {
        command = "herb-format",
      },
    },
  },
}
