return {
  {
    "nvim-mini/mini.pairs",
    commit = "b1c5a726921b7a8c9321e9a7a208aa0571de5810",
    event = "InsertEnter",
    opts = { modes = { insert = true, command = false, terminal = false } },
  },
  {
    "nvim-mini/mini.surround",
    commit = "72feeaa0f984646efde875cc775a97b6f8a8be9b",
    event = { "BufReadPre", "BufNewFile" },
    opts = {}, -- Restore the original sa/sd/sr mappings.
  },
  {
    "windwp/nvim-ts-autotag",
    commit = "d7220b55e16ed3c04e88086256def5d282429493",
    event = "InsertEnter",
    opts = {
      opts = { enable_close = true, enable_rename = true, enable_close_on_slash = false },
    },
  },
}
