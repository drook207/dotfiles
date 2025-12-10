-- Overseer configuration to match your VS Code tasks.json
local overseer = require("overseer")

-- Helper functions to get input values (mimicking VS Code inputs)
local function get_remote_host()
  return vim.fn.input("Remote host: ", "root@Fusion")
end

local function get_remote_path()
  return vim.fn.input("Remote deployment path: ", "/home/root/apps/TopView")
end

local function get_executable_name()
  return vim.fn.input("Executable Name: ", "TopViewDemoApplication")
end

local function get_debug_port()
  return vim.fn.input("Remote Debug Port: ", "10000")
end

-- Register custom task templates that match your VS Code tasks
overseer.register_template({
  name = "Install current build",
  builder = function()
    return {
      cmd = { "cmake" },
      args = { "--install", "." },
      cwd = "build/Debug",
      components = { "default" },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
})

overseer.register_template({
  name = "Deploy to remote target",
  builder = function()
    local remote_host = get_remote_host()
    local remote_path = get_remote_path()
    return {
      cmd = { "rsync" },
      args = {
        "-avz",
        "--progress", 
        "--compress",
        "build/Debug/install/lib",
        "build/Debug/install/bin",
        "build/Debug/install/qml",
        "build/Debug/install/plugins",
        remote_host .. ":" .. remote_path
      },
      components = { "default" },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
})

overseer.register_template({
  name = "Deploy Executable Only",
  builder = function()
    local remote_host = get_remote_host()
    local remote_path = get_remote_path()
    local executable_name = get_executable_name()
    return {
      cmd = { "rsync" },
      args = {
        "-avz",
        "--progress",
        "--compress",
        "build/Debug/install/bin/" .. executable_name,
        remote_host .. ":" .. remote_path
      },
      components = { "default" },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
})

overseer.register_template({
  name = "Start Remote GDBServer",
  builder = function()
    local remote_host = get_remote_host()
    local remote_path = get_remote_path()
    local executable_name = get_executable_name()
    local debug_port = get_debug_port()
    return {
      cmd = { "ssh" },
      args = {
        remote_host,
        "cd " .. remote_path .. "/bin && export WAYLAND_DISPLAY=/run/wayland-0 && gdbserver :" .. debug_port .. " ./" .. executable_name
      },
      components = { 
        "default",
        {
          "on_output_parse",
          problem_matcher = {
            {
              pattern = ".*",
              file = 1,
              location = 2,
              message = 3
            }
          }
        }
      },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
})

overseer.register_template({
  name = "Stop Remote GDBServer",
  builder = function()
    local remote_host = get_remote_host()
    return {
      cmd = { "ssh" },
      args = { remote_host, "pgrep gdbserver | xargs kill" },
      components = { "default" },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
})

overseer.register_template({
  name = "Kill Remote Process", 
  builder = function()
    local remote_host = get_remote_host()
    local executable_name = get_executable_name()
    return {
      cmd = { "ssh" },
      args = { remote_host, "pgrep " .. executable_name .. " | xargs kill" },
      components = { "default" },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
})

-- Composite tasks (like VS Code dependsOn)
overseer.register_template({
  name = "Deploy to Remote",
  builder = function()
    return {
      cmd = { "echo" },
      args = { "Running composite task: Deploy to Remote" },
      components = {
        "default",
        {
          "dependencies",
          task_names = { "Install current build", "Deploy to remote target" },
          sequential = true,
        }
      },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
})

overseer.register_template({
  name = "Deploy and Start Debug",
  builder = function()
    return {
      cmd = { "echo" },
      args = { "Running composite task: Deploy and Start Debug" },
      components = {
        "default", 
        {
          "dependencies",
          task_names = { "Deploy to Remote", "Start Remote GDBServer" },
          sequential = true,
        }
      },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
})