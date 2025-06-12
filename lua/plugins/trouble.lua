return {
  "folke/trouble.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-telescope/telescope.nvim" },

  config = function()
    require("trouble").setup({
      auto_close = true,
      auto_preview = true,
      auto_fold = true,
      use_lsp_diagnostic_signs = true,
      modes = {
        test = {
          mode = "diagnostics",
          auto_open = false,
        },
      },
    })

    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
      callback = function()
        vim.cmd([[Trouble qflist open]])
      end,
    })

    vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
    vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")

    vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
  end,
}
