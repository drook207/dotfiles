return {
  {
    "drook207/qmake-tools.nvim",
    -- lokal stattdessen: dir = "~/Projects/qmake-tools.nvim",
    name = "qmake-tools.nvim",
    lazy = true,
    ft = { "c", "cpp", "qmake" },
    cmd = {
      "QMakeGenerate",
      "QMakeBuild",
      "QMakeRun",
      "QMakeClean",
      "QMakeRebuild",
      "QMakeStop",
      "QMakeOpenExecutor",
      "QMakeCloseExecutor",
      "QMakeToggleExecutor",
      "QMakeInfo",
      "QMakeArgs",
      "QMakeArgsAdd",
      "QMakeRunArgs",
      "QMakeSelectBuildType",
      "QMakeSelectTarget",
      "QMakeSelectProject",
      "QMakeSelectConfig",
      "QMakeConfigNew",
      "QMakeConfigRename",
      "QMakeConfigDelete",
      "QMakeSelectKit",
      "QMakeKits",
      "QMakeKitAdd",
      "QMakeKitRemove",
    },
    opts = {},
    keys = {
      -- ── Kern-Workflow ─────────────────────────────────────
      { "<leader>Qg", "<cmd>QMakeGenerate<cr>", desc = "Generate" },
      { "<leader>Qb", "<cmd>QMakeBuild<cr>", desc = "Build" },
      { "<leader>QB", "<cmd>QMakeRebuild<cr>", desc = "Clean + Build" },
      { "<leader>Qr", "<cmd>QMakeRun<cr>", desc = "Run target" },
      { "<leader>Qc", "<cmd>QMakeClean<cr>", desc = "Clean" },
      { "<leader>Ql", "<cmd>QMakeRunArgs<cr>", desc = "Set launch args" },

      -- ── qmake-Argumente ───────────────────────────────────
      { "<leader>Qae", "<cmd>QMakeArgs<cr>", desc = "Edit qmake args" },
      { "<leader>Qaa", ":QMakeArgsAdd ", desc = "Add qmake arg" },
      { "<leader>Qax", "<cmd>QMakeArgs!<cr>", desc = "Clear qmake args" },

      -- ── Auswahl-Menüs ─────────────────────────────────────
      { "<leader>Qst", "<cmd>QMakeSelectBuildType<cr>", desc = "Select build type" },
      { "<leader>Qsl", "<cmd>QMakeSelectTarget<cr>", desc = "Select launch target" },
      { "<leader>Qsp", "<cmd>QMakeSelectProject<cr>", desc = "Select .pro file" },
      { "<leader>Qsk", "<cmd>QMakeSelectKit<cr>", desc = "Select kit" },
      { "<leader>Qsc", "<cmd>QMakeSelectConfig<cr>", desc = "Select config" },

      -- ── Konfigurationen ───────────────────────────────────
      { "<leader>QCn", "<cmd>QMakeConfigNew<cr>", desc = "New config" },
      { "<leader>QCs", "<cmd>QMakeSelectConfig<cr>", desc = "Select config" },
      { "<leader>QCr", "<cmd>QMakeConfigRename<cr>", desc = "Rename config" },
      { "<leader>QCd", "<cmd>QMakeConfigDelete<cr>", desc = "Delete config" },

      -- ── Kits ──────────────────────────────────────────────
      { "<leader>QKl", "<cmd>QMakeKits<cr>", desc = "List kits" },
      { "<leader>QKs", "<cmd>QMakeKits!<cr>", desc = "Rescan kits" },
      { "<leader>QKa", "<cmd>QMakeKitAdd<cr>", desc = "Add kit" },
      { "<leader>QKr", "<cmd>QMakeKitRemove<cr>", desc = "Remove kit" },

      -- ── Build-Typ direkt ──────────────────────────────────
      { "<leader>Qtd", "<cmd>QMakeSelectBuildType Debug<cr>", desc = "Debug" },
      { "<leader>Qtr", "<cmd>QMakeSelectBuildType Release<cr>", desc = "Release" },

      -- ── Fenster / Prozess ─────────────────────────────────
      { "<leader>Qe", "<cmd>QMakeToggleExecutor<cr>", desc = "Toggle executor" },
      { "<leader>Qoe", "<cmd>QMakeOpenExecutor<cr>", desc = "Open executor" },
      { "<leader>Qoq", "<cmd>botright copen<cr>", desc = "Open quickfix" },
      { "<leader>Qxe", "<cmd>QMakeCloseExecutor<cr>", desc = "Close executor" },
      { "<leader>Qxq", "<cmd>cclose<cr>", desc = "Close quickfix" },
      { "<leader>QX", "<cmd>QMakeStop<cr>", desc = "Stop build" },

      -- ── Sonstiges ─────────────────────────────────────────
      { "<leader>Qi", "<cmd>QMakeInfo<cr>", desc = "Info" },
      { "<leader>QS", "<cmd>checkhealth qmake-tools<cr>", desc = "Health check" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>Q", group = "QMake", icon = "󰙲" },
        { "<leader>Qa", group = "qmake args" },
        { "<leader>Qs", group = "select" },
        { "<leader>Qt", group = "build type" },
        { "<leader>Qo", group = "open" },
        { "<leader>Qx", group = "close" },
        { "<leader>QC", group = "configs" },
        { "<leader>QK", group = "kits" },
      },
    },
  },
}
