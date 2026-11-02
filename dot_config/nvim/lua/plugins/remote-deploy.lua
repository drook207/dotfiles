-- LazyVim-Integration für remote-deploy.nvim
-- Ablegen unter: ~/.config/nvim/lua/plugins/remote-deploy.lua
--
-- Voraussetzungen in LazyVim (:LazyExtras):
--   * dap.core     – nvim-dap (+ nvim-dap-ui) fürs Remote-Debugging
--   * lang.cmake   – cmake-tools.nvim für CMake-Projekte (Presets)
-- qmake-Projekte: qmake-tools.nvim als eigene Spec einbinden, wird automatisch erkannt.

-- Repository des Plugins (GitHub "user/repo" oder volle Git-URL)
local REPO = "drook207/remote-deploy.nvim"

-- Präfix für alle Keybinds. <leader>r ist in LazyVim durch das refactoring-Extra
-- belegt, <leader>d durch dap – daher <leader>R ("Remote").
local P = "<leader>R"

return {
  {
    REPO,
    -- Erst laden, wenn ein Befehl oder Keybind benutzt wird
    cmd = {
      "RemoteDeploy", "RemoteRun", "RemoteDebug", "RemoteDebugLast", "RemoteStop",
      "RemoteDevice", "RemoteDeviceAdd", "RemoteDeviceSet", "RemoteDeviceRemove",
      "RemoteDeviceTest", "RemoteCopyId", "RemoteShell", "RemoteInfo", "RemoteOutput",
    },
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      -- Geräte (zusätzlich zu den per :RemoteDeviceAdd angelegten)
      devices = {
        -- { name = "rpi", host = "192.168.1.50", user = "root" },
        -- Yocto-SDK mit eigenem gdb-Setup (wie "Additional Startup Commands" in Qt Creator):
        -- {
        --   name = "potara", host = "192.168.10.20", user = "root",
        --   gdb = "/opt/potara/1.3.0/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-ttcontrol-linux/aarch64-ttcontrol-linux-gdb",
        --   gdb_init_files = { "~/.config/gdb/potara-remote.gdb" },
        --   gdb_env = { MATCH_BUILD_DIR = "${build_dir}" },
        --   env = { QT_QPA_PLATFORM = "eglfs" },
        -- },
      },
      -- default_device = "rpi",
      backend = "auto", -- "auto" | "cmake" | "qmake"
      debugger = {
        adapter = "gdb", -- GDB >= 14; sonst "cppdbg" (vscode-cpptools über mason)
        -- init_files = { "~/.config/gdb/common.gdb" }, -- für alle Geräte
        -- init_commands = { "set print pretty on" },
      },
    },
    keys = {
      -- Deploy / Starten / Debuggen (Großbuchstabe = ohne vorherigen Build)
      { P .. "d", "<cmd>RemoteDeploy<cr>", desc = "Deploy (Build + Install + rsync)" },
      { P .. "D", "<cmd>RemoteDeploy!<cr>", desc = "Deploy ohne Build" },
      { P .. "r", "<cmd>RemoteRun<cr>", desc = "Deploy + auf dem Gerät starten" },
      { P .. "R", "<cmd>RemoteRun!<cr>", desc = "Starten ohne Build" },
      { P .. "b", "<cmd>RemoteDebug<cr>", desc = "Deploy + Remote-Debug" },
      { P .. "B", "<cmd>RemoteDebug!<cr>", desc = "Remote-Debug ohne Build" },
      { P .. "l", "<cmd>RemoteDebugLast<cr>", desc = "Erneut debuggen (ohne Deploy)" },
      { P .. "s", "<cmd>RemoteStop<cr>", desc = "Stoppen (Deploy/Programm/gdbserver)" },
      -- Geräte
      { P .. "g", "<cmd>RemoteDevice<cr>", desc = "Gerät wählen" },
      { P .. "a", "<cmd>RemoteDeviceAdd<cr>", desc = "Gerät anlegen" },
      { P .. "x", "<cmd>RemoteDeviceRemove<cr>", desc = "Gerät entfernen" },
      { P .. "e", ":RemoteDeviceSet ", desc = "Gerätefeld setzen …" },
      { P .. "t", "<cmd>RemoteDeviceTest<cr>", desc = "Gerät testen" },
      { P .. "k", "<cmd>RemoteCopyId<cr>", desc = "SSH-Schlüssel kopieren" },
      { P .. "h", "<cmd>RemoteShell<cr>", desc = "Shell auf dem Gerät" },
      -- Info / Ausgabe
      { P .. "i", "<cmd>RemoteInfo<cr>", desc = "Info" },
      { P .. "o", "<cmd>RemoteOutput<cr>", desc = "Ausgabefenster ein/aus" },
    },
  },

  -- which-key: Gruppe für das Präfix
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { P, group = "remote", icon = { icon = "󰒍 ", color = "cyan" } },
      },
    },
  },

  -- lualine: aktives Gerät (⟳ = Deploy läuft, ▶ = Programm läuft)
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, 1, {
        function()
          return require("remote-deploy").statusline()
        end,
        -- nur anzeigen, wenn das Plugin schon geladen ist (lädt es nicht nebenbei)
        cond = function()
          return package.loaded["remote-deploy"] ~= nil
        end,
      })
    end,
  },
}
