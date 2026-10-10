return {
  {
    "stevearc/conform.nvim",
    commit = "016802de402556da54c36bd7359b441266b01cdd",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "never" })
        end,
        mode = { "n", "x" },
        desc = "Format buffer or selection",
      },
    },
    opts = function()
      local util = require("conform.util")
      local biome_command = util.from_node_modules("biome")
      local prettier_command = util.from_node_modules("prettier")
      local function web_formatters(buf)
        if vim.fs.root(buf, { "biome.json", "biome.jsonc" }) then
          return { "biome" }
        end
        return { "prettier" }
      end
      return {
        default_format_opts = { lsp_format = "never" },
        formatters_by_ft = {
          ruby = { "rubocop" },
          eruby = { "herb" },
          lua = { "stylua" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          python = { "ruff_format" },
          kotlin = { "ktlint" },
          java = { "google-java-format" },
          sql = { "sqlfluff" },
          toml = { "taplo" },
          javascript = web_formatters,
          typescript = web_formatters,
          javascriptreact = web_formatters,
          typescriptreact = web_formatters,
          vue = web_formatters,
          svelte = web_formatters,
          html = web_formatters,
          css = web_formatters,
          scss = { "prettier" },
          json = web_formatters,
          jsonc = web_formatters,
          yaml = { "prettier" },
          markdown = { "prettier" },
        },
        formatters = {
          biome = {
            require_cwd = true,
            condition = function(self, ctx)
              local cwd = self:cwd(ctx)
              local command = biome_command(self, ctx)
              if not cwd or command == "biome" then
                return false
              end
              -- Ask Biome itself: config overrides and experimental formats can disable a file.
              local result = vim
                .system({ command, "format", "--stdin-file-path", ctx.filename }, {
                  cwd = cwd,
                  stdin = "",
                  text = true,
                })
                :wait(2000)
              return result.code == 0
            end,
          },
          prettier = {
            condition = function(self, ctx)
              return prettier_command(self, ctx) ~= "prettier"
            end,
          },
          herb = {
            command = util.from_node_modules("herb-format"),
            args = { "-" },
            stdin = true,
            cwd = util.root_file({ ".herb.yml" }),
            require_cwd = true,
          },
          rubocop = {
            cwd = util.root_file({ "Gemfile", ".rubocop.yml" }),
            command = function(_, ctx)
              return vim.fs.root(ctx.dirname, { "Gemfile" }) and "bundle" or "rubocop"
            end,
            prepend_args = function(_, ctx)
              return vim.fs.root(ctx.dirname, { "Gemfile" }) and { "exec", "rubocop" } or {}
            end,
          },
        },
        -- No format_on_save: only explicit ,cf modifies formatting.
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    commit = "f6230a5c06ba59e6059c14637f1dbe29a7978b9b",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>cl",
        function()
          require("lint").try_lint()
        end,
        desc = "Run file linters",
      },
    },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        -- Ruby and JavaScript diagnostics come from their language servers.
        python = { "ruff" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        dockerfile = { "hadolint" },
        kotlin = { "ktlint" },
      }
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("PersonalLint", { clear = true }),
        callback = function(ev)
          if vim.bo[ev.buf].buftype ~= "" then
            return
          end
          vim.api.nvim_buf_call(ev.buf, function()
            local available = {}
            for _, name in ipairs(lint.linters_by_ft[vim.bo.filetype] or {}) do
              local linter = lint.linters[name]
              local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
              if vim.fn.executable(cmd) == 1 then
                table.insert(available, name)
              end
            end
            if #available > 0 then
              lint.try_lint(available)
            end
          end)
        end,
      })
    end,
  },
}
