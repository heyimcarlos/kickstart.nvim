return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        component_separator = '|',
        section_separators = '',
      },
      sections = {
        lualine_x = {
          {
            require('noice').api.status.mode.get,
            cond = require('noice').api.status.mode.has,
            color = { fg = '#ff9e64' },
          },
        },
        lualine_a = {
          'buffers',
        },
      },
      inactive_sections = {
        lualine_a = { 'mode' },
      },
    }
  end,
}
