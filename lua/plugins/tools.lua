return {
  {
    'ellisonleao/glow.nvim',
    cmd = 'Glow',
    ft = 'markdown',
    opts = {
      border = 'rounded',
      style = 'dark',
      width_ratio = 0.9,
      height_ratio = 0.9,
    },
    keys = {
      { '<leader>mg', '<cmd>Glow<cr>', desc = 'Markdown Preview (Glow)' },
    },
  },
}
