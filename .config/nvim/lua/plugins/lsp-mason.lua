return {
	{
		"williamboman/mason.nvim",
		-- lazy = false,
		cmd = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonLog",
			"MasonUpdate",
		},
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "pyright", "clangd" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- lua_ls
			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
			}

			-- html
			vim.lsp.config.html = {
				capabilities = capabilities,
			}

			-- ts_ls
			vim.lsp.config.ts_ls = {
				capabilities = capabilities,
			}

			-- pyright
			vim.lsp.config.pyright = {
				capabilities = capabilities,
				settings = {
					pyright = {
						-- Using Ruff's import organizer
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							-- Ignore all files for analysis to exclusively use Ruff for linting
							ignore = { "*" },
						},
					},
				},
			}

			-- clangd
			vim.lsp.config.clangd = {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					client.server_capabilities.signatureHelpProvider = false
				end,
			}

			-- ruff
			vim.lsp.config.ruff = {
				capabilities = capabilities,
			}

			-- arduino_language_server
			vim.lsp.config.arduino_language_server = {
				capabilities = capabilities,
			}

			-- Enable all configured LSP servers
			vim.lsp.enable({
				"lua_ls",
				"html",
				"ts_ls",
				"pyright",
				"clangd",
				"ruff",
				"arduino_language_server",
			})

			-- Configure handlers
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})

			vim.diagnostic.config({
				float = { border = "rounded" },
			})
		end,
	},
}
