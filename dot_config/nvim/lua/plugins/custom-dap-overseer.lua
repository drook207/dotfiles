-- Custom plugin to integrate your VS Code configuration with Neovim DAP and Overseer
return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- Load your custom DAP configuration
      require("config.dap-config")
    end,
  },
  {
    "stevearc/overseer.nvim",
    config = function()
      -- Setup overseer with default config
      require("overseer").setup({
        templates = { "builtin" },
        strategy = {
          "jobstart",
          use_terminal = true,
        },
        form = {
          border = "rounded",
          zindex = 40,
          min_width = 80,
          max_width = 0.9,
          width = nil,
          min_height = 10,
          max_height = 0.9,
          height = nil,
        },
        task_list = {
          default_detail = 1,
          max_width = { 100, 0.2 },
          min_width = { 40, 0.1 },
          width = nil,
          max_height = { 20, 0.1 },
          min_height = 8,
          height = nil,
          separator = "────────────────────────────────────────",
          direction = "left",
          bindings = {
            ["?"] = "ShowHelp",
            ["g?"] = "ShowHelp",
            ["<CR>"] = "RunAction",
            ["<C-e>"] = "Edit",
            ["o"] = "Open",
            ["<C-v>"] = "OpenVsplit",
            ["<C-s>"] = "OpenSplit",
            ["<C-f>"] = "OpenFloat",
            ["<C-q>"] = "OpenQuickFix",
            ["p"] = "TogglePreview",
            ["<C-l>"] = "IncreaseDetail",
            ["<C-h>"] = "DecreaseDetail",
            ["L"] = "IncreaseAllDetail",
            ["H"] = "DecreaseAllDetail",
            ["["] = "DecreaseWidth",
            ["]"] = "IncreaseWidth",
            ["{"] = "PrevTask",
            ["}"] = "NextTask",
            ["<C-k>"] = "ScrollOutputUp",
            ["<C-j>"] = "ScrollOutputDown",
            ["q"] = "Close",
          },
        },
      })
      
      -- Load your custom task templates
      require("config.overseer-tasks")
      
      -- Set up keymaps for overseer
      vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Overseer: Toggle" })
      vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Overseer: Run Task" })
      vim.keymap.set("n", "<leader>oa", "<cmd>OverseerTaskAction<cr>", { desc = "Overseer: Task Action" })
      vim.keymap.set("n", "<leader>oi", "<cmd>OverseerInfo<cr>", { desc = "Overseer: Info" })
      vim.keymap.set("n", "<leader>ob", "<cmd>OverseerBuild<cr>", { desc = "Overseer: Build Task" })
      vim.keymap.set("n", "<leader>oq", "<cmd>OverseerQuickAction<cr>", { desc = "Overseer: Quick Action" })
    end,
  },
}