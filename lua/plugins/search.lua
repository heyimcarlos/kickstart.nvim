return {
  {
    'nvim-telescope/telescope.nvim',
    keys = {
      { '<leader>sf', LazyVim.pick 'files', desc = '[S]earch [F]iles' },
      { '<leader>ss', '<cmd>Telescope builtin<cr>', desc = '[S]earch [S]elect Telescope' },
      { '<leader>sr', '<cmd>Telescope resume<cr>', desc = '[S]earch [R]esume' },
      { '<leader>s.', '<cmd>Telescope oldfiles<cr>', desc = '[S]earch Recent Files' },
      { '<leader>sc', '<cmd>Telescope commands<cr>', desc = '[S]earch [C]ommands' },
      { '<leader><leader>', '<cmd>Telescope buffers<cr>', desc = 'Find Existing Buffers' },
      {
        '<leader>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        desc = 'Search Current Buffer',
      },
      {
        '<leader>s/',
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        desc = '[S]earch Open Files',
      },
      { '<leader>sn', LazyVim.pick.config_files(), desc = '[S]earch [N]eovim Files' },
    },
  },
  {
    'MagicDuck/grug-far.nvim',
    keys = {
      { '<leader>sr', false, mode = { 'n', 'x' } },
      {
        '<leader>rr',
        function()
          local grug = require 'grug-far'
          local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
            },
          }
        end,
        mode = { 'n', 'x' },
        desc = 'Search and Replace',
      },
    },
  },
  {
    'folke/noice.nvim',
    keys = {
      { '<leader>sn', false },
    },
  },
}
