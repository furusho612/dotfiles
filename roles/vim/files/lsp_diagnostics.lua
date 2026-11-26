vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		source = "always",
		border = "rounded",
		header = "",
		prefix = "",
	},
})

local diagnostic_float_group = vim.api.nvim_create_augroup("user_diagnostic_float", { clear = true })

-- カーソルが止まったときに診断内容を表示する。診断の無いバッファでは何もしない
vim.api.nvim_create_autocmd("CursorHold", {
	group = diagnostic_float_group,
	callback = function()
		if #vim.diagnostic.get(0) == 0 then
			return
		end
		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
	end,
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostics float" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Add diagnostics to location list" })
