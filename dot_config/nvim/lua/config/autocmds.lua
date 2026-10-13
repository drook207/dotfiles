-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Qt Designer for .ui files: <leader>cq (Qt 6 Designer preferred, Qt 5 as fallback)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ui",
  callback = function(ev)
    local designer
    for _, c in ipairs({ "designer6", "/usr/lib/qt6/bin/designer", "/usr/lib64/qt6/bin/designer", "designer-qt6", "designer" }) do
      if vim.fn.executable(c) == 1 then
        designer = c
        break
      end
    end
    if not designer then
      return
    end
    vim.keymap.set("n", "<leader>cq", function()
      vim.fn.jobstart({ designer, vim.api.nvim_buf_get_name(ev.buf) }, { detach = true })
    end, { buffer = ev.buf, desc = "Open in Qt Designer" })
  end,
})
