-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Sync cspell workspace words to Neovim spellfile (project-specific)
local function load_cspell_words()
  -- Search for cspell configuration files in project root
  local cspell_files = {
    "cspell.json",
    ".cspell.json",
    "cspell.config.json",
    ".cspell.config.json",
  }

  local cspell_path = nil
  for _, filename in ipairs(cspell_files) do
    local found = vim.fn.findfile(filename, ".;")
    if found ~= "" then
      cspell_path = found
      break
    end
  end

  if not cspell_path then
    return
  end

  -- Read and parse cspell configuration
  local ok, content = pcall(vim.fn.readfile, cspell_path)
  if not ok then
    return
  end

  local success, cspell_config = pcall(vim.fn.json_decode, table.concat(content, "\n"))
  if not success or not cspell_config then
    return
  end

  -- Extract words from cspell config
  local words = {}
  if cspell_config.words then
    vim.list_extend(words, cspell_config.words)
  end

  if #words == 0 then
    return
  end

  -- Get project root directory and create a unique identifier
  local project_root = vim.fn.fnamemodify(cspell_path, ":h")
  local project_hash = vim.fn.sha256(project_root)

  -- Create spell directory if it doesn't exist
  local spell_dir = vim.fn.stdpath("config") .. "/spell"
  vim.fn.mkdir(spell_dir, "p")

  -- Write words to project-specific spellfile
  local spellfile = spell_dir .. "/cspell-" .. project_hash:sub(1, 12) .. ".utf-8.add"
  vim.fn.writefile(words, spellfile)

  -- Compile the spellfile to .spl format (required for Neovim to use it)
  -- mkspell takes the .add file and creates the .spl file
  vim.cmd("silent! mkspell! " .. vim.fn.fnameescape(spellfile))

  -- Add to spellfile list
  vim.opt.spellfile:append(spellfile)
end

-- Since autocmds.lua loads on VeryLazy (after VimEnter), we need to:
-- 1. Load cspell immediately if we're already past VimEnter
-- 2. Or register for VimEnter if we're still early in startup

local function setup_cspell()
  vim.defer_fn(load_cspell_words, 100)
end

-- Check if VimEnter has already fired
if vim.v.vim_did_enter == 1 then
  -- VimEnter already happened, run immediately
  setup_cspell()
else
  -- VimEnter hasn't fired yet, register for it
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("cspell_integration", { clear = true }),
    callback = setup_cspell,
  })
end

-- Create a user command to manually reload cspell words
vim.api.nvim_create_user_command("CspellReload", function()
  load_cspell_words()
  vim.notify("Reloaded cspell words", vim.log.levels.INFO)
end, { desc = "Reload cspell workspace dictionary" })
