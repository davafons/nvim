return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  opts = {},

  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        python = { "black", "isort" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        kotlin = { "ktlint" },
        astro = { "prettierd", "prettier", stop_after_first = true },
      },
    })

    vim.keymap.set("n", "<leader>cf", require("conform").format)
  end,
}
