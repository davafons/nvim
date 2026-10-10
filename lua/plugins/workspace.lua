return {
  {
    "folke/persistence.nvim",
    commit = "b20b2a7887bd39c1a356980b45e03250f3dce49c",
    event = "BufReadPre",
    opts = { branch = false }, -- A session per project directory also works with jj.
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore project session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore last session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Stop session saving",
      },
    },
  },
  {
    "folke/snacks.nvim",
    commit = "882c996cf28183f4d63640de0b4c02ec886d01f2",
    dependencies = { "akinsho/bufferline.nvim", "nvim-lualine/lualine.nvim" },
    priority = 900,
    lazy = false,
    opts = {
      indent = { enabled = true, animate = { enabled = false } },
      dashboard = {
        enabled = true,
        preset = {
          pick = function(cmd, opts)
            if cmd == "files" or cmd == "live_grep" then
              require("config.projects").search(cmd, opts)
            else
              require("fzf-lua")[cmd](opts)
            end
          end,
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "p", desc = "Projects", action = ":lua require('config.projects').pick()" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Plugins", action = ":Lazy" },
            { icon = "󰋖 ", key = "?", desc = "Vim Shortcuts", action = ":VimShortcuts" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 0, padding = 1 },
          {
            text = {
              { "LEARN VIM  ", hl = "title" },
              { "operator + motion + repeat", hl = "desc" },
            },
          },
          { text = 'ciw change word   di" delete inside quotes   . repeat' },
          { text = ",tt files   ,tg search   ,jd review   ,ac ask agent" },
          { text = ",h full guide   / search the guide   q return", padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    commit = "245956d67572c137df375dbf256e96bdb07e0937",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = { render_modes = { "n", "c" } },
    keys = {
      {
        "<leader>mp",
        function()
          require("render-markdown").toggle()
        end,
        desc = "Toggle Markdown rendering",
        ft = "markdown",
      },
    },
  },
}
