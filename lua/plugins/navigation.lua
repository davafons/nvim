return {
  {
    "willfish/herdr-navigator.nvim",
    commit = "e6b05e6f99b4f99df42cd7e78ae33a066351138d",
    lazy = false,
    config = function()
      local navigator = require("herdr-navigator")
      -- Keep terminal-mode input available to fzf and interactive programs.
      navigator.setup({ mappings = { left = "", down = "", up = "", right = "" } })
      for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
        vim.keymap.set("n", "<C-" .. key .. ">", function()
          if vim.env.HERDR_ENV == "1" and vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
            navigator[direction]()
          else
            vim.cmd("wincmd " .. key)
          end
        end, { desc = "Navigate " .. direction .. " across splits and Herdr panes" })
      end
    end,
  },
}
