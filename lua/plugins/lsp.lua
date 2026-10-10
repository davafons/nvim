return {
  {
    "neovim/nvim-lspconfig",
    commit = "c59fc922f718fa055f69f5f3bc888f23211571eb",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "Saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
      {
        "mason-org/mason.nvim",
        commit = "2a6940af80375532e5e9e7c1f2fc6319a1b7a69d",
        lazy = false,
        opts = { install_root_dir = require("config.paths").mason },
        config = function(_, opts)
          require("mason").setup(opts)
          vim.api.nvim_create_user_command("InstallTools", function()
            vim.cmd.MasonInstall({ args = require("config.tools") })
          end, { desc = "Install the selected formatting and linting tools" })
        end,
      },
      { "mason-org/mason-lspconfig.nvim", commit = "e17625cdc8c2650787467398e02c5d63a2cde966" },
    },
    config = function()
      local languages = require("config.languages")
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.config("biome", {
        cmd = function(dispatchers, config)
          local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin/biome")
          local cmd = vim.fn.executable(local_cmd) == 1 and local_cmd or "biome"
          return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers, { cwd = config.root_dir })
        end,
      })
      vim.lsp.config("herb_ls", {
        filetypes = { "eruby" },
        workspace_required = true,
        root_dir = function(bufnr, on_dir)
          local root = vim.fs.root(bufnr, { ".herb.yml" })
          if root then
            on_dir(root)
          end
        end,
        cmd = function(dispatchers, config)
          local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin/herb-language-server")
          local cmd = vim.fn.executable(local_cmd) == 1 and local_cmd or "herb-language-server"
          return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers, { cwd = config.root_dir })
        end,
        init_options = { linter = { fixOnSave = false }, formatter = { enabled = false } },
        settings = {
          languageServerHerb = { linter = { fixOnSave = false }, formatter = { enabled = false } },
        },
      })
      vim.lsp.config("vtsls", {
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true,
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = require("config.paths").mason
                    .. "/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                },
              },
            },
          },
        },
      })
      vim.lsp.config("jsonls", {
        settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
      })
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })
      -- Formatting stays explicit; ESLint still provides diagnostics/code actions.
      vim.lsp.config("eslint", { settings = { format = false } })
      require("mason-lspconfig").setup({
        ensure_installed = languages.servers,
        automatic_enable = languages.servers,
      })
      vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("PersonalLspMappings", { clear = true }),
        callback = function(ev)
          local function map(key, fn, desc)
            vim.keymap.set("n", key, fn, { buffer = ev.buf, desc = desc })
          end
          map("K", function()
            vim.lsp.buf.hover({ border = "rounded" })
          end, "Documentation")
          map("gd", function()
            require("fzf-lua").lsp_definitions()
          end, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gi", function()
            require("fzf-lua").lsp_implementations()
          end, "Go to implementation")
          map("go", function()
            require("fzf-lua").lsp_typedefs()
          end, "Go to type definition")
          map("gr", function()
            require("fzf-lua").lsp_references()
          end, "Find references")
          map("gs", function()
            vim.lsp.buf.signature_help({ border = "rounded" })
          end, "Signature help")
          map("<F2>", vim.lsp.buf.rename, "Rename symbol")
          map("<F4>", vim.lsp.buf.code_action, "Code actions")
          map("<leader>df", vim.diagnostic.open_float, "Line diagnostics")
          map("<leader>ts", function()
            require("fzf-lua").lsp_document_symbols()
          end, "File symbols")
          map("<leader>tS", function()
            require("fzf-lua").lsp_live_workspace_symbols()
          end, "Project symbols")
        end,
      })
    end,
  },
  {
    "folke/trouble.nvim",
    commit = "bd67efe408d4816e25e8491cc5ad4088e708a69a",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Project diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list" },
    },
  },
}
