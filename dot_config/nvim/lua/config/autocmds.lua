-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- In your config file (e.g., ~/.config/nvim/lua/config/autocmds.lua)
vim.api.nvim_create_user_command("DeployAndDebug", function()
	local config = {
		remote_host = "10.100.30.160",
		remote_path = "/home/root/apps/TopViewPro",
		executable = "TopViewApplication",
		debug_port = "10000",
	}
	-- Run tasks in sequence
	vim.cmd("!cmake --install build")
	vim.cmd(
		string.format(
			"!rsync -avz build/install/lib build/install/bin build/install/qml build/install/plugins %s:%s",
			config.remote_host,
			config.remote_path
		)
	)
	-- Start gdbserver in background
	local cmd = string.format(
		"ssh %s 'cd %s/bin && export WAYLAND_DISPLAY=/run/wayland-0 && gdbserver :%s ./%s' &",
		config.remote_host,
		config.remote_path,
		config.debug_port,
		config.executable
	)
	vim.fn.jobstart(cmd, { detach = true })

	-- Wait a bit for gdbserver to start
	vim.defer_fn(function()
		require("dap").continue()
	end, 2000)
end, {})

vim.api.nvim_create_user_command("StopRemoteDebug", function()
	vim.cmd("!ssh 10.100.30.160 'pgrep gdbserver | xargs kill'")
end, {})
