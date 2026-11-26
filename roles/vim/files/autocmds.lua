local augroup_id = vim.api.nvim_create_augroup("user_autocmds", { clear = true })

-- 行末の空白を保存時に削除する。markdown の行末 2 スペースは強制改行なので除外する
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup_id,
	pattern = "*",
	callback = function()
		local filetype = vim.bo.filetype
		if filetype == "markdown" or filetype == "mdx" then
			return
		end
		local view = vim.fn.winsaveview()
		vim.cmd([[keeppatterns %s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

-- 新しい行でコメントを継続しない
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup_id,
	pattern = "*",
	command = "set fo-=c fo-=r fo-=o",
})

-- ファイルを開いたときに前回のカーソル位置へ戻す
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup_id,
	pattern = "*",
	callback = function()
		vim.cmd([[silent! normal! g`"zv]])
	end,
})
