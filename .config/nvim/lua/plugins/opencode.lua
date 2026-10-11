-- opencode.nvim — your main agent, embedded in nvim (from omerxx/dotfiles)
-- leader+ot toggle · leader+oa ask about cursor/selection · leader+o+ add context
return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Required for `toggle()` — LazyVim already ships snacks
    { "folke/snacks.nvim", opts = { input = { enabled = true } } },
  },
  config = function()
    vim.opt.autoread = true -- required for opts.auto_reload

    vim.keymap.set("n", "<leader>ot", function()
      require("opencode").toggle()
    end, { desc = "Toggle embedded opencode" })
    vim.keymap.set("n", "<leader>oa", function()
      require("opencode").ask("@cursor: ")
    end, { desc = "Ask opencode about this" })
    vim.keymap.set("v", "<leader>oa", function()
      require("opencode").ask("@selection: ")
    end, { desc = "Ask opencode about selection" })
    vim.keymap.set("n", "<leader>o+", function()
      require("opencode").prompt("@buffer", { append = true })
    end, { desc = "Add buffer to prompt" })
    vim.keymap.set("v", "<leader>o+", function()
      require("opencode").prompt("@selection", { append = true })
    end, { desc = "Add selection to prompt" })
    vim.keymap.set("n", "<leader>oe", function()
      require("opencode").prompt("Explain @cursor and its context")
    end, { desc = "Explain this code" })
    vim.keymap.set("n", "<leader>on", function()
      require("opencode").command("session_new")
    end, { desc = "New opencode session" })
    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("messages_half_page_up")
    end, { desc = "Messages half page up" })
    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("messages_half_page_down")
    end, { desc = "Messages half page down" })
    vim.keymap.set({ "n", "v" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "Select opencode prompt" })
  end,
}
