return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}

    local uv = vim.uv or vim.loop

    local function read_json(path)
      local f = io.open(path, "r")
      if not f then return nil end
      local ok, data = pcall(vim.json.decode, f:read("*a"))
      f:close()
      return ok and data or nil
    end

    local function norm(p)
      if not p or p == "" then return nil end
      p = vim.fs.normalize(p)
      p = uv.fs_realpath(p) or p
      return (p:gsub("/+$", ""))
    end

    -- CMake-Preset-Makros auflösen
    local function expand(s, root, preset)
      s = s:gsub("%${sourceDir}", function() return root end)
      s = s:gsub("%${presetName}", function() return preset.name end)
      s = s:gsub("%$env{([%w_]+)}", function(v) return os.getenv(v) or "" end)
      return s
    end

    -- Feld (optional mit Key) inkl. "inherits" auflösen
    local function lookup(map, preset, field, key)
      local seen = {}
      local function walk(p)
        if not p or seen[p.name] then return nil end
        seen[p.name] = true
        local t = p[field]
        if key then
          if type(t) == "table" and t[key] ~= nil then
            local v = t[key]
            return type(v) == "table" and v.value or v
          end
        elseif t ~= nil then
          return t
        end
        local parents = p.inherits
        if type(parents) == "string" then parents = { parents } end
        for _, name in ipairs(parents or {}) do
          local v = walk(map[name])
          if v ~= nil then return v end
        end
      end
      return walk(preset)
    end

    -- Aktives Build-Verzeichnis: cmake-tools, sonst compile_commands.json-Symlink
    local function active_build_dir(root)
      local ok, cmake = pcall(require, "cmake-tools")
      if ok and cmake.get_build_directory then
        local ok2, dir = pcall(cmake.get_build_directory)
        dir = ok2 and dir and norm(tostring(dir)) or nil
        if dir and vim.fn.isdirectory(dir) == 1 then return dir end
      end
      local cc = uv.fs_realpath(root .. "/compile_commands.json")
      if cc then return norm(vim.fs.dirname(cc)) end
    end

    local function first_executable(candidates)
      for _, c in ipairs(candidates) do
        if c and vim.fn.executable(c) == 1 then return c end
      end
    end

    local function build_cmd(root)
      local bin, args, info = nil, {}, "System-Qt"
      local build = active_build_dir(root)
      local presets = read_json(root .. "/CMakePresets.json")

      if build then
        vim.list_extend(args, { "-b", build })

        if presets and presets.configurePresets then
          local map = {}
          for _, p in ipairs(presets.configurePresets) do map[p.name] = p end

          for _, p in ipairs(presets.configurePresets) do
            local bd = lookup(map, p, "binaryDir")
            if bd and norm(expand(bd, root, p)) == build then
              info = "Preset " .. p.name

              -- QML_IMPORT_PATH aus "environment" (kann ':'-getrennt sein)
              local qip = lookup(map, p, "environment", "QML_IMPORT_PATH")
              if qip then
                for path in expand(qip, root, p):gmatch("[^:]+") do
                  vim.list_extend(args, { "-I", (path:gsub("/+$", "")) })
                end
              end

              -- Native Qt (linux-gcc): QT_HOST_PATH/qml + passendes qmlls
              local host = lookup(map, p, "cacheVariables", "QT_HOST_PATH")
              local candidates = {}
              if host then
                host = expand(host, root, p):gsub("/+$", "")
                vim.list_extend(args, { "-I", host .. "/qml" })
                table.insert(candidates, host .. "/bin/qmlls")
              end

              -- Cross-SDK: qmlls aus dem Host-Sysroot des Toolchains
              local tc = lookup(map, p, "toolchainFile")
              if tc then
                -- .../usr/share/cmake/Qt6Toolchain.cmake -> .../usr
                local usr = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(expand(tc, root, p))))
                table.insert(candidates, usr .. "/bin/qmlls")
                table.insert(candidates, usr .. "/libexec/qmlls")
              end

              bin = first_executable(candidates)
              break
            end
          end
        end
      end

      local cmd = { bin or "qmlls" }
      vim.list_extend(cmd, args)
      vim.notify(("qmlls (%s): %s"):format(info, table.concat(cmd, " ")), vim.log.levels.INFO)
      return cmd
    end

    opts.servers.qmlls = {
      root_markers = { "CMakePresets.json", ".git" },
      cmd = function(dispatchers, config)
        local root = (config and config.root_dir)
          or vim.fs.root(0, { "CMakePresets.json", ".git" })
          or vim.fn.getcwd()
        return vim.lsp.rpc.start(build_cmd(root), dispatchers, { cwd = root })
      end,
    }

    return opts
  end,
}
