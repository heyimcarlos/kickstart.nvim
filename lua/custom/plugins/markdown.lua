return {
  -- Terminal-native Markdown preview backed by the Arch-packaged Glow CLI.
  -- Use this when you want to stay inside Neovim.
  {
    'ellisonleao/glow.nvim',
    cmd = 'Glow',
    ft = { 'markdown' },
    opts = {
      glow_path = vim.fn.exepath 'glow',
      border = 'rounded',
      style = 'dark',
      width_ratio = 0.9,
      height_ratio = 0.9,
    },
    keys = {
      { '<leader>mg', '<cmd>Glow<cr>', desc = '[M]arkdown preview ([G]low)' },
      { '<leader>mG', '<cmd>Glow!<cr>', desc = '[M]arkdown [G]low close' },
    },
  },

  -- Browser-based live preview. This is the most popular dedicated
  -- Neovim Markdown preview plugin and is useful when you want GitHub-like
  -- rendered HTML with synchronized scrolling.
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_echo_preview_url = 1
    end,
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', desc = '[M]arkdown browser [P]review' },
      { '<leader>ms', '<cmd>MarkdownPreviewStop<cr>', desc = '[M]arkdown preview [S]top' },
    },
  },
}
