return {
  {
    "jtnovellis/herdr-nvim",
    commit = "aafa32ceca90237b87e0647d4381b744906f4b71",
    build = "cargo build --release --locked",
    event = "VeryLazy",
    cmd = {
      "HerdrAsk",
      "HerdrReply",
      "HerdrAskTarget",
      "HerdrAnnotate",
      "HerdrAnnotations",
      "HerdrSend",
      "HerdrPreview",
      "HerdrClear",
      "HerdrNextEdit",
      "HerdrPrevEdit",
      "HerdrKeepEdit",
      "HerdrRevertEdit",
    },
    init = function()
      vim.g.herdr_nvim_no_defaults = true
    end,
    keys = {
      { "<leader>ac", "<cmd>HerdrAsk<CR>", desc = "Ask Herdr agent about current line" },
      { "<leader>ac", ":HerdrAsk<CR>", mode = "x", desc = "Ask Herdr agent about selection" },
      { "<leader>ar", "<cmd>HerdrReply<CR>", desc = "Follow up with Herdr agent" },
      { "<leader>at", "<cmd>HerdrAskTarget<CR>", desc = "Choose Herdr agent" },
      { "<leader>aa", "<cmd>HerdrAnnotate<CR>", desc = "Queue review comment on line" },
      { "<leader>aa", ":HerdrAnnotate<CR>", mode = "x", desc = "Queue review comment on selection" },
      { "<leader>al", "<cmd>HerdrAnnotations<CR>", desc = "List review comments" },
      { "<leader>ap", "<cmd>HerdrPreview<CR>", desc = "Preview comments for Herdr agent" },
      { "<leader>aS", "<cmd>HerdrSend<CR>", desc = "Send review comments to Herdr agent" },
      { "]r", "<cmd>HerdrNextEdit<CR>", desc = "Next tracked Herdr agent edit" },
      { "[r", "<cmd>HerdrPrevEdit<CR>", desc = "Previous tracked Herdr agent edit" },
      { "<leader>ak", "<cmd>HerdrKeepEdit<CR>", desc = "Mark tracked agent edit reviewed" },
    },
    opts = {
      keymaps = false,
      after_ask = "stay",
      after_send = "stay",
      review = { enabled = true },
      -- This is an ordinary Neovim pane; no managed sidebar or daemon.
      quit_guard = false,
      pane_title = false,
      reload = { enabled = false },
    },
    config = function(_, opts)
      require("herdr-nvim").setup(opts)
      -- Watch ordinary panes too: terminal focus events are insufficient in Herdr.
      local reload = require("herdr-nvim.reload")
      reload.start({ debounce_ms = 200 })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("PersonalReloadCleanup", { clear = true }),
        callback = reload.stop,
      })
    end,
  },
}
