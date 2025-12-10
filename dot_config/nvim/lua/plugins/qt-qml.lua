return {
	-- QML Language Server Support
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				qmlls = {
					cmd = { "qmlls" },
					filetypes = { "qml" },
					root_dir = function(fname)
						return vim.fn.getcwd()
					end,
					settings = {},
				},
			},
		},
	},

	-- QML Treesitter Support
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"qmljs",
			})
		end,
	},

	-- Mason for automatic LSP installation
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"qmlls",
			},
		},
	},

	-- QML file type detection and syntax highlighting
	{
		"peterhoeg/vim-qml",
		ft = { "qml" },
	},
}
