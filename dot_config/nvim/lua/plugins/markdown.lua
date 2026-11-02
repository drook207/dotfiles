-- markdownlint-cli2 using the .markdownlint* config found upward from the
-- buffer (usually the project root). nvim-lint pipes the buffer through stdin,
-- where markdownlint-cli2 only reads the config in its cwd (Neovim's cwd
-- otherwise), so run it from the config's directory. That also fixes the
-- conform markdownlint-cli2 formatter, which only runs when there are
-- markdownlint diagnostics. prettier and markdownlint-cli2 --fix get the file
-- path and already find their configs from it.
local config_names = {
  ".markdownlint-cli2.jsonc",
  ".markdownlint-cli2.yaml",
  ".markdownlint-cli2.cjs",
  ".markdownlint-cli2.mjs",
  ".markdownlint.jsonc",
  ".markdownlint.json",
  ".markdownlint.yaml",
  ".markdownlint.yml",
  ".markdownlint.cjs",
  ".markdownlint.mjs",
}

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        -- a function is evaluated by nvim-lint on every run
        ["markdownlint-cli2"] = function()
          local linter = vim.deepcopy(require("lint.linters.markdownlint-cli2"))
          local path = vim.api.nvim_buf_get_name(0)
          local config = vim.fs.find(config_names, { upward = true, path = vim.fs.dirname(path) })[1]
          linter.cwd = config and vim.fs.dirname(config) or nil
          return linter
        end,
      },
    },
  },
}
