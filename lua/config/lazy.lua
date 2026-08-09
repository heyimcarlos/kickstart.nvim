local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Failed to clone lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    { 'LazyVim/LazyVim', import = 'lazyvim.plugins' },

    -- Takuya Matsuyama uses the same pattern: let LazyVim Extras own complete
    -- language workflows, then keep personal changes in lua/plugins/.
    { import = 'lazyvim.plugins.extras.editor.telescope' },
    { import = 'lazyvim.plugins.extras.lang.typescript' },
    { import = 'lazyvim.plugins.extras.lang.json' },
    { import = 'lazyvim.plugins.extras.lang.tailwind' },
    { import = 'lazyvim.plugins.extras.lang.astro' },
    { import = 'lazyvim.plugins.extras.linting.eslint' },
    { import = 'lazyvim.plugins.extras.formatting.prettier' },
    { import = 'lazyvim.plugins.extras.lang.markdown' },
    { import = 'lazyvim.plugins.extras.lang.python' },
    { import = 'lazyvim.plugins.extras.lang.go' },
    { import = 'lazyvim.plugins.extras.lang.rust' },
    { import = 'lazyvim.plugins.extras.dap.core' },
    { import = 'lazyvim.plugins.extras.ai.copilot' },

    { import = 'plugins' },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { 'github_dark_default', 'tokyonight', 'habamax' } },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}
