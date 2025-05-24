return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "onsails/lspkind.nvim",
  },
  config = function()
    -- Add cmp_nvim_lsp capabilities settings to lspconfig
    -- This should be executed before you configure any language server
    local lspconfig_defaults = require("lspconfig").util.default_config
    lspconfig_defaults.capabilities =
      vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

    local cmp = require("cmp")

    cmp.setup({
      sources = {
        { name = "nvim_lsp", group_index = 2 },
        { name = "path", group_index = 2 },
        { name = "buffer", keyword_length = 3 },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        format = require("lspkind").cmp_format({
          menu = {
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            latex_symbols = "[Latex]",
          },
          mode = "symbol_text", -- show only symbol annotations
          maxwidth = 50, -- prevent the popup from showing more than provided characters
          ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
          show_labelDetails = true,
        }),
      },
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
    })

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.HINT] = "⚑",
          [vim.diagnostic.severity.INFO] = "»",
        },
      },
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        header = "",
        prefix = "",
      },
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "docker_compose_language_service",
        "dockerls",
        "bashls",
        "kotlin_language_server",
        "groovyls",
        "jedi_language_server",
        "eslint",
        "ts_ls",
        "astro",
      },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,

        -- Lua
        lua_ls = function()
          require("lspconfig").lua_ls.setup({
            on_init = function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.uv.fs_stat(path .. "/.luarc.json") then
                  return
                end
              end

              client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  },
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                  -- library = vim.api.nvim_get_runtime_file("", true)
                },
              })
            end,
            settings = {
              Lua = {},
            },
          })
        end,
        -- Docker Compose
        docker_compose_language_service = function()
          require("lspconfig").docker_compose_language_service.setup({})
        end,
        -- Dockerfile
        dockerls = function()
          require("lspconfig").dockerls.setup({
            settings = {
              docker = {
                languageserver = {
                  formatter = {
                    ignoreMultilineInstructions = true,
                  },
                },
              },
            },
          })
        end,
        -- Bash
        bashls = function()
          require("lspconfig").bashls.setup({})
        end,
        -- Kotlin
        kotlin_language_server = function()
          require("lspconfig").kotlin_language_server.setup({})
        end,
        -- Groovyls
        groovyls = function()
          require("lspconfig").groovyls.setup({})
        end,
        -- Jedi (Python)
        jedi_language_server = function()
          require("lspconfig").jedi_language_server.setup({})
        end,
        -- Eslint (Javascript)
        eslint = function()
          require("lspconfig").eslint.setup({
            on_attach = function(_, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
              })
            end,
          })
        end,
      },
      -- ts_ls (Typescript)
      ts_ls = function()
        require("lspconfig").ts_ls.setup({})
      end,
      -- astro
      astro = function()
        require("astro").astro.setup({})
      end,
      -- kotlin
      kotlin_language_server = function()
        require("lspconfig").kotlin_language_server.setup({})
      end,
    })
  end,
}
