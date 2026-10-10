return {
  {
    "esmuellert/codediff.nvim",
    commit = "09d9ebef2cc5a5c04db7a349cd6c61bdf84ecc8e",
    cmd = "CodeDiff",
    opts = {
      diff = { layout = "side-by-side" },
      keymaps = {
        view = {
          focus_explorer = false,
          toggle_stage = false,
          toggle_staged_view = false,
          stage_hunk = false,
          unstage_hunk = false,
          discard_hunk = false,
          diff_get = false,
          diff_put = false,
        },
        explorer = { stage_all = false, unstage_all = false, restore = false },
      },
    },
  },
  {
    "NicolasGB/jj.nvim",
    commit = "64605c84f4e7774ff510d614204625ced87ffb48",
    dependencies = { "esmuellert/codediff.nvim" },
    cmd = { "J", "Jdiff", "Jhdiff" },
    keys = {
      { "<leader>jl", "<cmd>J log<CR>", desc = "JJ change log" },
      { "<leader>js", "<cmd>J status<CR>", desc = "JJ status" },
      {
        "<leader>jd",
        function()
          require("jj.diff").show_revision({ rev = "@" })
        end,
        desc = "Review current JJ change",
      },
      {
        "<leader>jf",
        function()
          require("jj.diff").diff_current({ rev = "@-" })
        end,
        desc = "Review current file against JJ parent",
      },
      -- The upstream CodeDiff backend takes target first, then base.
      {
        "<leader>jm",
        function()
          require("jj.diff").diff_revisions({ left = "@", right = "main" })
        end,
        desc = "Review JJ changes since main",
      },
    },
    opts = {
      diff = { backend = "codediff" },
      -- Use David's `jj push` alias in a shell to run the required checks.
      cmd = { keymaps = { log = { push = false, push_all = false } } },
    },
  },
}
