-- DAP configuration to match your VS Code launch.json
local dap = require("dap")

-- Configure GDB adapter for remote debugging
dap.adapters.gdb = {
  type = "executable",
  command = "/opt/potara/1.3.0/sysroots/x86_64-ttcontrol-linux/usr/bin/aarch64-ttcontrol-linux/aarch64-ttcontrol-linux-gdb",
  args = { "-i", "dap" }
}

-- Helper function to get input values (mimicking VS Code inputs)
local function get_remote_host()
  return vim.fn.input("Remote host: ", "10.100.30.160")
end

local function get_remote_path()
  return vim.fn.input("Remote deployment path: ", "/home/root/apps/TopViewPro")
end

local function get_executable_name()
  return vim.fn.input("Executable Name: ", "TopViewApplication")
end

local function get_debug_port()
  return vim.fn.input("Remote Debug Port: ", "10000")
end

-- Configuration for remote GDB debugging (matching your VS Code config)
dap.configurations.cpp = {
  {
    name = "Remote GDB Debug",
    type = "gdb",
    request = "launch",
    program = function()
      local executable = get_executable_name()
      return vim.fn.getcwd() .. "/build/Debug/App/" .. executable
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = false,
    args = {},
    environment = {
      WAYLAND_DISPLAY = "/run/wayland-0"
    },
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "Enable pretty-printing for gdb",
        ignoreFailures = true
      },
      {
        text = "set remotetimeout 60",
        description = "Set remote timeout",
        ignoreFailures = true
      },
      {
        text = "set solib-search-path /opt/potara/1.3.0/sysroots/cortexa72-cortexa53-crypto-ttcontrol-linux/usr/lib:build/Debug/install/lib",
        description = "Set solib search path",
        ignoreFailures = false
      },
      {
        text = "set solib-absolute-prefix /",
        description = "Add library directory",
        ignoreFailures = true
      },
      {
        text = "set auto-load safe-path /",
        description = "Auto load safe path",
        ignoreFailures = true
      },
      {
        text = "show solib-search-path",
        description = "Show library search path",
        ignoreFailures = true
      }
    },
    miDebuggerServerAddress = function()
      local host = get_remote_host()
      local port = get_debug_port()
      return host .. ":" .. port
    end,
  }
}

-- Also set for C files
dap.configurations.c = dap.configurations.cpp