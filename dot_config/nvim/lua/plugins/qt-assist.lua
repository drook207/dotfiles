-- lazy.nvim / LazyVim: ~/.config/nvim/lua/plugins/qt-assist.lua
return {
  {
    "drook207/qt-assist.nvim",
    -- lokal stattdessen: dir = "~/Projects/qt-assist.nvim",
    name = "qt-assist.nvim",
    ft = { "cpp", "c", "objcpp", "cuda" },
    cmd = { "QtAssist", "QtAssistSwitch" },
    dependencies = {
      -- optional: liefern das Build-Verzeichnis mit der compile_commands.json
      { "Civitasv/cmake-tools.nvim", optional = true },
      { "drook207/qmake-tools.nvim", optional = true },
    },
    ---@type QtAssistConfig
    opts = {
      naming = {
        member_prefixes = { "m_", "m", "_" }, -- bool mFoo → foo
        getter = "{name}", -- bool foo()
        bool_getter = nil, -- z. B. "is{Name}"
        setter = "set{Name}", -- void setFoo()
        setter_param = "{name}",
        signal = "{name}Changed", -- void fooChanged()
      },
      property = {
        full = "Q_PROPERTY({type} {name} READ {getter} WRITE {setter} NOTIFY {signal} FINAL)",
      },
      signal = { emit = "emit", keyword = "signals" },
      definitions = "source", -- Rümpfe in die .cpp
      missing_namespace = "create", -- fehlende Namespaces in der .cpp anlegen
      namespace_style = "nested", -- namespace a::b {
      source = { create_missing = "ask" },
      auto_save = false,
    },
    keys = {
      { "<leader>qa", "<cmd>QtAssist<cr>", mode = { "n", "x" }, desc = "Qt Assist: Aktionen" },
      { "<leader>qp", "<cmd>QtAssist property<cr>", desc = "Qt Assist: Q_PROPERTY + Member" },
      { "<leader>qg", "<cmd>QtAssist getset<cr>", mode = { "n", "x" }, desc = "Qt Assist: Getter/Setter" },
      { "<leader>qd", "<cmd>QtAssist define<cr>", desc = "Qt Assist: Definition erzeugen" },
      { "<leader>qD", "<cmd>QtAssist define_all<cr>", desc = "Qt Assist: alle fehlenden Definitionen" },
      { "<leader>qm", "<cmd>QtAssist move<cr>", desc = "Qt Assist: Definition in .cpp verschieben" },
      { "<leader>qs", "<cmd>QtAssistSwitch<cr>", desc = "Qt Assist: Header/Quelle wechseln" },
    },
  },
}
