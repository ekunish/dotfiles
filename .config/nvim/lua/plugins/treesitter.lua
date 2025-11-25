return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = { "lua", "javascript" },
			auto_install = { enable = true },
			highlight = { enable = true },
			indent = { enable = true },
			-- Neovim本体のパーサーと重複を避ける設定
			prefer_git = false,
		})
	end,
}
