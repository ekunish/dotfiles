-- cd-to-selected: 選択したディレクトリにcdして終了するプラグイン
return {
	entry = function()
		local h = cx.active.current.hovered
		if h and h.cha.is_dir then
			-- ディレクトリを選択している場合、そこに移動してから終了
			ya.manager_emit("cd", { h.url })
		end
		-- 終了（シェルのy関数が--cwd-fileを読んでcdする）
		ya.manager_emit("quit", {})
	end,
}
