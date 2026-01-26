return {
  "nvzone/floaterm",
  dependencies = "nvzone/volt",
  opts = {},
  cmd = "FloatermToggle",

  vim.keymap.set("n", "<leader>tf", ":FloatermToggle<CR>", { desc = "Toggle Floaterm" }),
}
