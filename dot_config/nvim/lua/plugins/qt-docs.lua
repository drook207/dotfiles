-- lazy.nvim / LazyVim: ~/.config/nvim/lua/plugins/qt-docs.lua
return {
  {
    "drook207/qt-docs.nvim",
    -- lokal stattdessen: dir = "~/Projects/qt-docs.nvim",
    name = "qt-docs.nvim",
    ft = { "cpp", "c", "objcpp" },
    cmd = { "QtDoc", "QtDocHover", "QtDocSearch", "QtDocBrowser", "QtDocIndex" },
    dependencies = {
      -- optional: Doku passend zum Qt des Projekts finden
      { "Civitasv/cmake-tools.nvim", optional = true },
      { "drook207/qmake-tools.nvim", optional = true },
    },
    opts = {
      -- paths = { "~/Qt/Docs/Qt-6.8.0" }, -- leer = automatisch suchen
      window = "vsplit", -- "float" | "split" | "vsplit" | "tab" | "current"
      map_k = true, -- K: Qt-Doku, falls vorhanden, sonst LSP-Hover
      online = {
        enabled = true,
        base_url = "https://doc.qt.io/qt-6/",
        mode = "render", -- oder "browser"
      },
    },
    keys = {
      { "<leader>qk", "<cmd>QtDocHover<cr>", desc = "Qt-Doku: Hover" },
      { "<leader>qK", "<cmd>QtDoc<cr>", desc = "Qt-Doku: Seite öffnen" },
      { "<leader>q/", "<cmd>QtDocSearch<cr>", desc = "Qt-Doku: suchen" },
      { "<leader>qb", "<cmd>QtDocBrowser<cr>", desc = "Qt-Doku: im Browser" },
    },
  },
}
