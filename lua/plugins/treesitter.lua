return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { 
        "lua", "vim", "vimdoc", "query",
        "java", "python", "javascript", "typescript", 
        "html", "css", "json", "yaml", "toml",
        "bash", "dockerfile", "astro", "kotlin"
      },

      -- Install languages synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- List of parsers to ignore installing
      ignore_install = { "" },

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
      auto_install = true,

      autopairs = {
        enable = true,
      },

      indent = {
        enable = true,
      },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = function(_, bufnr)
          local file_size = vim.fn.getfsize(vim.fn.bufname(bufnr))
          local file_lines = vim.api.nvim_buf_line_count(bufnr)
          return file_size > 50000 or file_lines > 50000
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },

      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    })
  end,
}
