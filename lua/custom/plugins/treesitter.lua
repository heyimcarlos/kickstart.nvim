return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require 'nvim-treesitter'
    treesitter.setup {
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      ensure_installed = {
        'markdown',
        'markdown_inline',
        'c_sharp',
        'c',
        'cpp',
        'go',
        'lua',
        'css',
        'cmake',
        'scss',
        'python',
        'ninja',
        'rust',
        'http',
        'sql',
        'gitignore',
        'vimdoc',
        'bash',
        'html',
        'markdown',
        'markdown_inline',
        'astro',
      },
    }
  end,
}
