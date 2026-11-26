local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Optimize shada (shared data) for faster startup
vim.opt.shada = { "'10", "<0", "s10", "h" }

local plugins = require('plugins')

require("lazy").setup(plugins, {
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      -- 起動時に読み込まれる組み込みプラグインは、ここで rtp から外して無効化する
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tutor",
        "zipPlugin",
        "rplugin",
        "editorconfig",
        "spellfile",
      },
    },
  },
})
