return {
  "echasnovski/mini.surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*",

  config = function()
    require("mini.surround").setup()
  end,
}
