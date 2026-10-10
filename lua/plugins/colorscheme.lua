return {
  {
    "maxmx03/solarized.nvim",
    commit = "a8085e29883ddcfb39bd46197eb32ef00df05368",
    lazy = false,
    priority = 1000,
    opts = {
      on_highlights = function(colors)
        local highlights = {}
        local foreground = vim.o.background == "dark" and colors.base2 or colors.base02
        local backgrounds = { "mix_blue", "mix_violet", "mix_yellow", "mix_orange", "mix_red", "mix_magenta" }
        for level, background in ipairs(backgrounds) do
          -- Keep tinted heading bands, but avoid accent-colored text on the same accent.
          highlights["@markup.heading." .. level .. ".markdown"] = { fg = foreground, bold = true }
          highlights["RenderMarkdownH" .. level .. "Bg"] = {
            fg = foreground,
            bg = colors[background],
            bold = true,
          }
        end
        return highlights
      end,
    },
    config = function(_, opts)
      vim.opt.termguicolors = true
      vim.opt.background = "dark"
      require("solarized").setup(opts)
      vim.cmd.colorscheme("solarized")
    end,
  },
}
