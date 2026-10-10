local M = {}

function M.root()
  local path = vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) or ""
  local cwd = vim.fn.getcwd()
  return vim.fs.root(path ~= "" and path or cwd, { { ".jj", ".git" } }) or cwd
end

function M.search(kind, opts)
  opts = vim.tbl_extend("force", { cwd = M.root() }, opts or {})
  return require("fzf-lua")[kind](opts)
end

function M.recent()
  local projects, seen = {}, {}
  local function add(path)
    local root = vim.fs.root(path, { { ".jj", ".git" } })
    if root and not seen[root] then
      seen[root] = true
      projects[#projects + 1] = root
    end
  end
  for _, file in ipairs(vim.v.oldfiles) do
    add(file)
  end
  add(vim.fn.getcwd())
  return projects
end

function M.pick()
  local projects = M.recent()
  if #projects == 0 then
    vim.notify("No recent projects yet. Open a file in a project first.", vim.log.levels.INFO)
    return
  end
  require("fzf-lua").fzf_exec(projects, {
    prompt = "Projects> ",
    actions = {
      default = function(selected)
        if selected[1] then
          vim.api.nvim_set_current_dir(selected[1])
          require("fzf-lua").files({ cwd = selected[1] })
        end
      end,
    },
  })
end

return M
