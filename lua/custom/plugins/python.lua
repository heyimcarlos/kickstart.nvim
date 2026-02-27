return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    'mfussenegger/nvim-dap-python', --optional
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  lazy = false,
  config = function()
    require('venv-selector').setup {
      -- settings = {
      --   search = {
      --     -- Custom search for virtual environments in the `Documents` directory
      --     find_documents_venvs = {
      --       command = 'fd /bin/python$ ~/Documents --full-path',
      --     },
      --     -- You can add more custom searches as needed
      --     find_code_venvs = {
      --       command = 'fd /bin/python$ ~/Code --full-path',
      --     },
      --   },
      -- },
    }
  end,
  keys = {
    { '<leader>vs', '<cmd>VenvSelect<cr>' },
  },
}
