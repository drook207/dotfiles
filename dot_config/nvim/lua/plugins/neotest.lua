-- Automatische Zuordnung: Testdatei -> GTest-Binary über compile_commands.json
-- (nutzt interne Module von neotest-gtest, kann nach Plugin-Updates brechen)
local function gtest_configure_all()
  local nio = require("nio")
  local neotest = require("neotest")
  local GlobalRegistry = require("neotest-gtest.executables.global_registry")
  local refresh = require("neotest-gtest.executables.refresh")

  local function realpath(p)
    return vim.uv.fs_realpath(p) or p
  end

  local function find_compile_db(file)
    for dir in vim.fs.parents(file) do
      for _, c in ipairs({ dir .. "/compile_commands.json", dir .. "/build/compile_commands.json" }) do
        if vim.uv.fs_stat(c) then
          return c
        end
      end
    end
  end

  local function load_db(path)
    local f = assert(io.open(path, "r"))
    local data = vim.json.decode(f:read("*a"))
    f:close()
    local by_file = {}
    for _, e in ipairs(data) do
      local cmd = e.command or table.concat(e.arguments or {}, " ")
      local target = cmd:match("CMakeFiles/([^/]+)%.dir/")
      if target then
        local src = e.file
        if not src:match("^/") then
          src = e.directory .. "/" .. src
        end
        by_file[realpath(src)] = { directory = e.directory, target = target }
      end
    end
    return by_file
  end

  local function is_exe(p)
    local st = vim.uv.fs_stat(p)
    return st and st.type == "file" and vim.fn.executable(p) == 1
  end

  -- Mögliche Binary-Namen: Release ohne Suffix, Debug mit CMAKE_DEBUG_POSTFIX "d"
  local postfixes = { "", "d" }

  local function find_binary(entry, build_root)
    local names = {}
    for _, pf in ipairs(postfixes) do
      names[entry.target .. pf] = true
    end
    -- Zuerst direkt im Build-Verzeichnis des Targets suchen
    local best, best_mtime
    for name in pairs(names) do
      local p = entry.directory .. "/" .. name
      if is_exe(p) then
        local mtime = vim.uv.fs_stat(p).mtime.sec
        if not best or mtime > best_mtime then
          best, best_mtime = p, mtime
        end
      end
    end
    if best then
      return best
    end
    -- Fallback: falls RUNTIME_OUTPUT_DIRECTORY gesetzt ist, im ganzen Build-Dir suchen
    local hits = vim.fs.find(function(name, path)
      return names[name] and is_exe(path .. "/" .. name)
    end, { path = build_root, type = "file", limit = math.huge })
    for _, p in ipairs(hits) do
      local mtime = vim.uv.fs_stat(p).mtime.sec
      if not best or mtime > best_mtime then
        best, best_mtime = p, mtime
      end
    end
    return best
  end

  nio.run(function()
    local mapped, missing, dbs = 0, {}, {}
    for _, adapter_id in ipairs(neotest.state.adapter_ids()) do
      if vim.startswith(adapter_id, "neotest-gtest:") then
        local root = adapter_id:sub(#"neotest-gtest:" + 1)
        local registry = GlobalRegistry:for_dir(root)
        local tree = neotest.state.positions(adapter_id)
        for _, node in tree:iter_nodes() do
          local data = node:data()
          if data.type == "file" then
            local file = realpath(data.path)
            local db_path = find_compile_db(file)
            local reason
            if not db_path then
              reason = "keine compile_commands.json"
            else
              dbs[db_path] = dbs[db_path] or load_db(db_path)
              local entry = dbs[db_path][file]
              if not entry then
                reason = "nicht in compile_commands.json"
              else
                local exe = find_binary(entry, vim.fs.dirname(realpath(db_path)))
                if exe then
                  registry:update_executable(data.path, exe)
                  refresh.track(exe, data.path)
                  mapped = mapped + 1
                else
                  reason = "Binary '" .. entry.target .. "' nicht gefunden (gebaut?)"
                end
              end
            end
            if reason then
              missing[#missing + 1] = vim.fs.basename(data.path) .. ": " .. reason
            end
          end
        end
      end
    end
    vim.schedule(function()
      local msg = ("neotest-gtest: %d Dateien zugeordnet"):format(mapped)
      if #missing > 0 then
        msg = msg .. "\nNicht zugeordnet:\n  " .. table.concat(missing, "\n  ")
      end
      vim.notify(msg, #missing > 0 and vim.log.levels.WARN or vim.log.levels.INFO)
    end)
  end)
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "alfaix/neotest-gtest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-gtest").setup({
          is_test_file = function(file)
            local name = vim.fs.basename(file)
            return name:match("^tst_.+%.cpp$") ~= nil
              or name:match("^tst_.+%.cc$") ~= nil
              or name:match("^tst_.+%.cxx$") ~= nil
          end,
          mappings = { configure = "C" },
        }),
      },
    })
  end,
  keys = {
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Nächsten Test ausführen" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Datei testen" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test debuggen" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test-Übersicht" },
    { "<leader>to", function() require("neotest").output.open() end, desc = "Output anzeigen" },
    { "<leader>tc", gtest_configure_all, desc = "GTest-Binaries aus compile_commands.json zuordnen" },
  },
}
