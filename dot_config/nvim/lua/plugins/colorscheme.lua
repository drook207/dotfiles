return {
	-- add gruvbox
	{ "ellisonleao/gruvbox.nvim" },
	{ "thesimonho/kanagawa-paper.nvim" },
	{ "sainnhe/everforest" },
	{ "sainnhe/gruvbox-material" },
	{ "sainnhe/sonokai" },
	--{ "sainnhe/edge" },
	--{ "sainnhe/edge-dark" },
	--{ "sainnhe/edge-light" },
	{ "navarasu/onedark.nvim" },
	{ "EdenEast/nightfox.nvim" },
	{ "rebelot/kanagawa.nvim" },
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "Mofiqul/dracula.nvim" },
	{ "savq/melange-nvim" },
	{ "ayu-theme/ayu-vim" },
	{ "marko-cerovac/material.nvim" },
	{
		"zaldih/themery.nvim",
		lazy = false,
		config = function()
			require("themery").setup({
				-- add the config here
				themes = {
					"gruvbox",
					"ayu",
					"catppuccin",
					"tokyonight",
					"kanagawa-paper",
					"everforest",
					"gruvbox-material",
					"sonokai",
					--"edge",
					--"edge-dark",
					--"edge-light",
					"onedark",
					"nightfox",
					"kanagawa",
					"rose-pine",
					"dracula",
					"melange-nvim",
					"material",
				}, -- Your list of installed colorschemes.
				livePreview = true, -- Apply theme while picking. Default to true.
			})
		end,
	},

	{
		"catppuccin/nvim",
		lazy = true,
		name = "catppuccin",
		opts = {
			flavor = "macchiato", -- latte, frappe, macchiato, mocha
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dashboard = true,
				flash = true,
				fzf = true,
				grug_far = true,
				gitsigns = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				mini = true,
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				snacks = true,
				telescope = true,
				treesitter_context = true,
				which_key = true,
			},
		},
		specs = {
			{
				"akinsho/bufferline.nvim",
				optional = true,
				opts = function(_, opts)
					if (vim.g.colors_name or ""):find("catppuccin") then
						opts.highlights = require("catppuccin.special.bufferline").get_theme()
					end
				end,
			},
		},
	},
	-- Configure LazyVim to load gruvbox
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin", --"tokyonight" --"habamax" --"nord" --"dracula" --"onedark" --"rose-pine"
		},
	},
}
