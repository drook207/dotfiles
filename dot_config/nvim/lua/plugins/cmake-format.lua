-- CMake formatting and linting with cmakelang (cmake-format / cmake-lint), both
-- using the .cmake-format.{yaml,json,py} found upward from the buffer (usually
-- the project root). cmake-format reads stdin, where it would otherwise look
-- for the config from Neovim's cwd; and the LazyVim extra's cmakelint doesn't
-- read that config at all, so it's replaced with cmake-lint.
local config_names = {
  ".cmake-format",
  ".cmake-format.py",
  ".cmake-format.json",
  ".cmake-format.yaml",
  "cmake-format.py",
  "cmake-format.json",
  "cmake-format.yaml",
}

local function find_config(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  return vim.fs.find(config_names, { upward = true, path = vim.fs.dirname(path) })[1]
end

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = { cmake = { "cmake_format" } },
      formatters = {
        cmake_format = {
          args = function(_, ctx)
            local config = find_config(ctx.buf)
            -- "=" form: --config-files takes several values and would swallow "-"
            return config and { "--config-files=" .. config, "-" } or { "-" }
          end,
          cwd = function(_, ctx)
            local config = find_config(ctx.buf)
            return config and vim.fs.dirname(config)
          end,
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    -- cmake-lint gets the file path and finds the config upward from it itself
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.cmake = { "cmake_lint" }
    end,
  },
}
