return {
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "e289100ff98969e118c702199d88b764ce9e7fdf",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      vim.treesitter.language.register("json", "jsonc")
      ts.setup({ install_dir = require("config.paths").site })
      local function attach(buf)
        if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
          return
        end
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then
          return
        end
        local ok, parser = pcall(vim.treesitter.get_parser, buf, lang)
        if not ok or not parser then
          return
        end
        vim.treesitter.start(buf, lang)
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        for _, win in ipairs(vim.fn.win_findbuf(buf)) do
          vim.wo[win].foldmethod = "expr"
          vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[win].foldlevel = 99
        end
      end
      vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
        group = vim.api.nvim_create_augroup("PersonalTreesitter", { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      ts.install(require("config.languages").parsers):await(function(err)
        if err then
          return
        end
        vim.schedule(function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
              attach(buf)
            end
          end
        end)
      end)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    commit = "5c7b0263797dfd1bd6202f2b219f3b53a80b2187",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true, selection_modes = { ["@function.outer"] = "V", ["@class.outer"] = "V" } },
        move = { set_jumps = true },
      })
      local function maps(buf)
        for key, capture in pairs({
          af = "@function.outer",
          ["if"] = "@function.inner",
          ac = "@class.outer",
          ic = "@class.inner",
          aa = "@parameter.outer",
          ia = "@parameter.inner",
        }) do
          vim.keymap.set({ "x", "o" }, key, function()
            require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
          end, { buffer = buf, desc = "Select " .. capture })
        end
        for key, spec in pairs({
          ["]m"] = { "goto_next_start", "@function.outer" },
          ["[m"] = { "goto_previous_start", "@function.outer" },
          ["]M"] = { "goto_next_end", "@function.outer" },
          ["[M"] = { "goto_previous_end", "@function.outer" },
          ["]]"] = { "goto_next_start", "@class.outer" },
          ["[["] = { "goto_previous_start", "@class.outer" },
        }) do
          vim.keymap.set({ "n", "x", "o" }, key, function()
            require("nvim-treesitter-textobjects.move")[spec[1]](spec[2], "textobjects")
          end, { buffer = buf, desc = "Move to " .. spec[2] })
        end
      end
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("PersonalTextobjects", { clear = true }),
        callback = function(ev)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) and vim.bo[ev.buf].buftype == "" then
              maps(ev.buf)
            end
          end)
        end,
      })
    end,
  },
}
