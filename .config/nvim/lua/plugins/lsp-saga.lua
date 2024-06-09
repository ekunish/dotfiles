return {
	"nvimdev/lspsaga.nvim",
	config = function()
		require("lspsaga").setup({
			ui = {
			    code_action = "",
			},
			finder = {
				max_height = 0.6,
				default = "tyd+ref+imp+def",
				keys = {
					toggle_or_open = "<CR>",
					vsplit = "v",
					split = "s",
					tabnew = "t",
					tab = "T",
					quit = "q",
					close = "<Esc>",
				},
				methods = {
					tyd = "textDocument/typeDefinition",
				},
			},
		})
	end,
}
