-- C++/Qt: QML language server and formatter from Qt 6 (qt6-declarative; qmlls
-- also reports qmllint's warnings), treesitter for QML, and CTest-based tests
-- (QtTest, GoogleTest, Catch2 ...).
-- Qt keeps its tools outside the PATH, so look in the usual places
-- (Arch/Ubuntu: /usr/lib/qt6/bin, Fedora: /usr/lib64/qt6/bin). Each part is only
-- set up if its tool is installed.
local function qt_tool(names)
  for _, name in ipairs(names) do
    for _, path in ipairs({ name, "/usr/lib/qt6/bin/" .. name, "/usr/lib64/qt6/bin/" .. name }) do
      if vim.fn.executable(path) == 1 then
        return vim.fn.exepath(path)
      end
    end
  end
end

local qmlls = qt_tool({ "qmlls" })
local qmlformat = qt_tool({ "qmlformat" })

-- the QML parser is called qmljs, the filetype qml
vim.treesitter.language.register("qmljs", "qml")

return {
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "qmljs", "qmldir" } } },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Qt 6 QML; for QML import paths qmlls reads the .qmlls.ini that CMake
        -- writes with QT_QML_GENERATE_QMLLS_INI=ON
        qmlls = qmlls and { cmd = { qmlls }, mason = false } or nil,
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = { qml = qmlformat and { "qmlformat" } or nil },
      formatters = { qmlformat = qmlformat and { command = qmlformat } or nil },
    },
  },


  -- neotest (LazyVim test.core extra) with CTest as runner
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "orjangj/neotest-ctest" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-ctest").setup({}))
    end,
  },
}
