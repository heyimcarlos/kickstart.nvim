local theme = require 'config.theme'
theme.setup()

return {
  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      theme = 'dragon',
      background = {
        dark = 'dragon',
        light = 'lotus',
      },
      overrides = theme.overrides,
    },
  },
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = 'kanagawa-dragon',
    },
  },
}
