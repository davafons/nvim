#!/usr/bin/env python3
"""Check the real configuration headlessly without desktop or clipboard input.

Requires the pinned plugins to be installed in the normal Neovim data directory.
Editor state, cache, files, and repository fixtures are temporary.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

CONFIG = Path(__file__).resolve().parents[1]
NVIM = shutil.which("nvim")
assert NVIM, "Neovim is required"

PROBE = r'''
local config = vim.fn.stdpath("config")
for _, path in ipairs(vim.fn.glob(config .. "/lua/**/*.lua", false, true)) do
  local chunk, err = loadfile(path)
  assert(chunk, path .. ": " .. tostring(err))
end
assert(vim.g.mapleader == ",")
assert(vim.o.shiftwidth == 2)
assert(vim.o.expandtab and vim.o.relativenumber)
assert(vim.o.clipboard == "", "Startup must not enable automatic clipboard sync")
assert(not vim.o.autowrite and not vim.o.autowriteall)
assert(vim.o.textwidth == 99 and vim.o.colorcolumn == "100")
assert(vim.o.undolevels == 10000)
assert(vim.fn.maparg("j", "n") == "gj")
assert(vim.fn.maparg("k", "n") == "gk")
assert(vim.fn.exists(":VimShortcuts") == 2)
local lazy = require("lazy")
lazy.load({ plugins = { "jj.nvim", "codediff.nvim", "herdr-nvim", "fzf-lua" } })
assert(type(require("config.herdr_review").setup) == "function")
assert(type(require("herdr-nvim.ask").set_target) == "function")
assert(type(require("codediff.config").options) == "table")
local projects = require("config.projects")
local original_cwd = vim.fn.getcwd()
vim.cmd.edit(vim.env.NVIM_TEST_FILE)
assert(projects.root() == vim.env.NVIM_TEST_PROJECT)
assert(vim.fn.getcwd() == original_cwd, "Root lookup changed the working directory")
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "unsaved fixture" })
local file_buffer = vim.api.nvim_get_current_buf()
require("config.shortcuts").open()
assert(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t") == "Vim shortcuts")
assert(vim.bo.readonly and not vim.bo.modifiable)
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("Herdr"))
vim.api.nvim_feedkeys("q", "xt", false)
assert(vim.api.nvim_get_current_buf() == file_buffer)
assert(vim.bo.modified, "Closing the guide lost the unsaved file")
assert(vim.fn.readfile(vim.env.NVIM_TEST_FILE)[1] == "original fixture")
print("Neovim config checks passed: startup, defaults, review dependencies, roots, guide, unsaved edits")
vim.cmd("qa!")
'''

with tempfile.TemporaryDirectory(prefix="nvim-config-tests-") as temporary:
    root = Path(temporary).resolve()
    config_home = root / "config"
    config_home.mkdir()
    (config_home / "nvim").symlink_to(CONFIG, target_is_directory=True)
    project = root / "project"
    (project / ".jj").mkdir(parents=True)
    source = project / "nested" / "fixture.txt"
    source.parent.mkdir()
    source.write_text("original fixture\n")
    probe = root / "probe.lua"
    probe.write_text(PROBE)
    environment = dict(os.environ, XDG_CONFIG_HOME=str(config_home),
                       XDG_STATE_HOME=str(root / "state"), XDG_CACHE_HOME=str(root / "cache"),
                       NVIM_TEST_FILE=str(source), NVIM_TEST_PROJECT=str(project))
    for key in list(environment):
        if key.startswith("HERDR_") or key == "NVIM_APPNAME":
            environment.pop(key)
    command = "lua local ok, err = pcall(dofile, " + json.dumps(str(probe)) + "); " \
              "if not ok then io.stderr:write(tostring(err) .. '\\n'); vim.cmd('cquit 1') end"
    result = subprocess.run([NVIM, "--headless", "-n", "-i", "NONE", "-u", str(CONFIG / "init.lua"),
                             "-c", command], env=environment, cwd=root,
                            capture_output=True, text=True, timeout=30)
    print(result.stdout + result.stderr, end="")
    if result.returncode:
        raise SystemExit(result.returncode)
    assert source.read_text() == "original fixture\n"
