local M = {}
local context
local review_tab

local function notify(message)
  vim.notify(message, vim.log.levels.WARN, { title = "Checkout review" })
end

function M.return_to_agent()
  if not context then
    notify("Open a review from Herdr with Ctrl-a, then r.")
    return
  end
  vim.system({ "python3", context.launcher, "return" }, { text = true, timeout = 10000 }, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        notify(vim.trim(result.stderr))
      end)
    end
  end)
end

function M.open()
  if not context then
    return
  end
  if review_tab and vim.api.nvim_tabpage_is_valid(review_tab) then
    vim.api.nvim_set_current_tabpage(review_tab)
    return
  end
  local base = "HEAD"
  if context.kind == "jj" then
    base = require("jj.utils").get_commit_id("@-")
  end
  if not base then
    return
  end
  local layout = vim.o.columns < 100 and "--inline" or "--side-by-side"
  vim.cmd("CodeDiff " .. base .. " " .. layout)
end

function M.choose_target()
  require("herdr-nvim").agents(function(agents)
    if type(agents) ~= "table" then
      return
    end
    vim.ui.select(agents, {
      prompt = "Review comments for which agent?",
      format_item = function(agent)
        return agent.label or agent.pane_id
      end,
    }, function(choice)
      if not choice then
        return
      end
      vim.system({ "herdr", "pane", "get", choice.pane_id }, { text = true, timeout = 10000 }, function(result)
        vim.schedule(function()
          local ok, response = pcall(vim.json.decode, result.stdout)
          local pane = ok and response.result and response.result.pane
          if result.code ~= 0 or not pane or not pane.agent then
            notify("That agent has gone; choose another target.")
            return
          end
          if pane.pane_id == context.source_pane then
            context.source_session = pane.agent_session
            context.source_agent = pane.agent
          end
          require("herdr-nvim.ask").set_target({ pane_id = pane.pane_id, agent = pane.agent })
        end)
      end)
    end)
  end)
end

local function target_annotations()
  -- Upstream remembers question targets, but its annotation sender does not.
  -- Scope this adapter to the dedicated review editor; preserve upstream UI,
  -- blocked-agent checks, delivery bookkeeping and prompt generation.
  local bridge = require("herdr-nvim.bridge")
  local run = bridge.run
  bridge.run = function(config, args, input, on_exit, opts)
    if args[1] ~= "send" then
      return run(config, args, input, on_exit, opts)
    end
    local target = require("herdr-nvim.ask").target()
    local pane_id = target and target.pane_id
    for index, arg in ipairs(args) do
      if arg == "--target" then
        pane_id = args[index + 1]
      end
    end
    if not pane_id then
      on_exit(false, "Choose an agent with ,at before sending review comments.")
      return
    end
    vim.system({ "herdr", "pane", "get", pane_id }, { text = true, timeout = 10000 }, function(result)
      vim.schedule(function()
        local ok, response = pcall(vim.json.decode, result.stdout)
        local pane = ok and response.result and response.result.pane
        if result.code ~= 0 or not pane or not pane.agent then
          on_exit(false, "The target agent has gone. Choose an agent with ,at; comments are kept.")
          return
        end
        if pane_id == context.source_pane and pane.agent ~= context.source_agent then
          on_exit(false, "The source agent changed. Choose an agent with ,at; comments are kept.")
          return
        end
        if pane_id == context.source_pane and context.source_session ~= vim.NIL and context.source_session then
          if not vim.deep_equal(pane.agent_session, context.source_session) then
            on_exit(false, "The source agent session changed. Choose an agent with ,at; comments are kept.")
            return
          end
        end
        local targeted = vim.list_extend({}, args)
        if not vim.tbl_contains(args, "--target") then
          vim.list_extend(targeted, { "--target", pane_id })
        end
        run(config, targeted, input, on_exit, opts)
      end)
    end)
  end
end

function M.setup()
  if context then
    return
  end
  local path = vim.env.HERDR_REVIEW_CONTEXT_PATH
  if not path then
    notify("This command runs in a Herdr checkout review pane.")
    return
  end
  context = vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  require("lazy").load({ plugins = { "jj.nvim", "codediff.nvim", "herdr-nvim" } })
  if context.source_agent and context.source_agent ~= vim.NIL then
    require("herdr-nvim.ask").set_target({ pane_id = context.source_pane, agent = context.source_agent })
  end
  target_annotations()
  vim.api.nvim_create_user_command("HerdrReviewReturn", M.return_to_agent, { desc = "Return to source Herdr pane" })
  vim.api.nvim_create_user_command("HerdrReviewOpen", M.open, { desc = "Reopen checkout changes" })
  vim.api.nvim_create_user_command("HerdrReviewTarget", M.choose_target, { desc = "Choose review comment target" })
  vim.keymap.set("n", "<leader>ab", M.return_to_agent, { desc = "Return to source Herdr pane" })
  vim.keymap.set("n", "<leader>at", M.choose_target, { desc = "Choose review comment target" })
  local group = vim.api.nvim_create_augroup("PersonalHerdrReview", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "CodeDiffOpen",
    callback = function(event)
      review_tab = event.data.tabpage
      local label = (context.source_agent ~= vim.NIL and context.source_agent) or "pane"
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(review_tab)) do
        vim.wo[win].winbar = "Checkout changes · " .. label .. " · ,ab return"
      end
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "CodeDiffClose",
    callback = function(event)
      if event.data.tabpage == review_tab then
        review_tab = nil
        vim.schedule(M.return_to_agent)
      end
    end,
  })
  -- Herdr resizes the newly attached terminal after launching its process.
  -- Choose the layout once the review pane has received its actual dimensions.
  vim.defer_fn(M.open, 200)
end

return M
