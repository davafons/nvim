return {
  {
    "Saghen/blink.cmp",
    branch = "v1",
    commit = "78336bc89ee5365633bcf754d93df01678b5c08f",
    event = "InsertEnter",
    dependencies = {
      { "rafamadriz/friendly-snippets", commit = "b4d01b0fdf3c9a549961c2f9ffe8dc09be166219" },
    },
    opts = {
      keymap = {
        preset = "enter",
        -- Herdr owns Ctrl-n/p for pane cycling; use arrows in completion menus.
        ["<C-n>"] = false,
        ["<C-p>"] = false,
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = false } },
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
        menu = { border = "rounded" },
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = { lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 } },
      },
      fuzzy = { implementation = "prefer_rust" },
      cmdline = { enabled = false },
      term = { enabled = false },
    },
  },
}
