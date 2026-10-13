-- Settings that keep :checkhealth clean
return {
  -- LaTeX in Markdown isn't used: no latex parser, utftex or latex2text needed
  { "MeanderingProgrammer/render-markdown.nvim", optional = true, opts = { latex = { enabled = false } } },
  -- vim.ui.input comes from dressing.nvim (LazyVim's telescope extra)
  { "folke/snacks.nvim", opts = { input = { enabled = false } } },
  -- formatter used by the markdown extra via conform/none-ls
  { "mason-org/mason.nvim", opts = { ensure_installed = { "prettier" } } },
}
