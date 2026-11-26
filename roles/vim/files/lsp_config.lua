local lsp_servers = {
	"lua_ls",
	"vimls",
	"ruff",
	"biome",
	"ts_ls",
	"markdown_oxide",
	"jsonls",
	"jsonnet_ls",
	"yamlls",
	"dockerls",
	"bashls",
	"golangci_lint_ls",
	"gopls",
	"terraformls",
	"rust_analyzer",
	"elixirls",
}

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	ensure_installed = lsp_servers,
	-- LSP の有効化は下の vim.lsp.enable ループに一本化する
	-- automatic_enable は mason にインストール済みのツールを無差別に vim.lsp.enable するため、
	-- LSP 非対応の stylua (フォーマッタ用) まで stylua --lsp で起動されてエラーになる
	automatic_enable = false,
})

-- Global config: set git repository as root marker for all servers
vim.lsp.config("*", {
	root_markers = { ".git" },
})

-- lua_ls がワークスペース設定を尋ね、テレメトリを送るのを止める
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			telemetry = { enable = false },
			workspace = { checkThirdParty = false },
		},
	},
})

-- Enable each LSP server
for _, lsp_server in ipairs(lsp_servers) do
	vim.lsp.enable(lsp_server)
end

-- 補完と lspsaga の操作を、LSP が接続したバッファだけで有効にする
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client == nil then
			return
		end
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
		local keymaps = {
			{ "<leader>rn", "<cmd>Lspsaga rename<CR>", "Rename symbol" },
			{ "<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code action" },
			{ "<leader>d", "<cmd>Lspsaga peek_definition<CR>", "Peek definition" },
			{ "<leader>o", "<cmd>Lspsaga outline<CR>", "Outline" },
		}
		for _, keymap in ipairs(keymaps) do
			vim.keymap.set("n", keymap[1], keymap[2], { buffer = ev.buf, desc = keymap[3] })
		end
	end,
})

-- conform.nvim setup (formatter)
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		javascript = { "biome" },
		typescript = { "biome" },
		javascriptreact = { "biome" },
		typescriptreact = { "biome" },
		json = { "biome" },
		css = { "biome" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		go = { "gofumpt" },
		terraform = { "terraform_fmt" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- nvim-lint setup (linter)
-- JS/TS の lint は biome (LSP) に任せる。eslint_d はプロジェクトの ESLint と
-- 設定、プラグインを必要とし、biome より依存が大きいため使わない
require("lint").linters_by_ft = {
	json = { "jsonlint" },
	yaml = { "yamllint" },
	dockerfile = { "hadolint" },
}

-- Auto-run linter
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

require("lspsaga").setup({
	symbol_in_winbar = {
		separator = "  ",
	},
})
