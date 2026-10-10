return {
  "tpope/vim-rails",
  commit = "b0a5c76f86ea214ade36ab0b811e730c3f0add67",
  lazy = false, -- Detect Rails before the first project buffer is opened.
  keys = {
    { "<leader>ra", "<cmd>A<cr>", desc = "Rails alternate file" },
    { "<leader>rr", "<cmd>R<cr>", desc = "Rails related file" },
    { "<leader>rm", ":Emodel ", desc = "Rails model" },
    { "<leader>rc", ":Econtroller ", desc = "Rails controller" },
    { "<leader>rv", ":Eview ", desc = "Rails view" },
  },
}
