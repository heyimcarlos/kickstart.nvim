local map = vim.keymap.set
local silent = { silent = true }
local delete_buffer = function()
  Snacks.bufdelete()
end

map('n', '<Esc>', '<cmd>nohlsearch<cr>')
map('i', 'jj', '<Esc>')
map('i', 'jk', '<Esc>')

map('v', 'J', ":m '>+1<cr>gv=gv")
map('v', 'K', ":m '<-2<cr>gv=gv")
map('v', '<Tab>', '>gv')
map('v', '<S-Tab>', '<gv')

-- Keep the tab, split, and window motions shared by the old config and
-- Takuya Matsuyama's setup.
map('n', 'te', '<cmd>tabedit<cr>', { desc = 'New Tab' })
map('n', '<Tab>', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<S-Tab>', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
map('n', 'ss', '<cmd>split<cr><C-w>w', { desc = 'Split Below' })
map('n', 'sv', '<cmd>vsplit<cr><C-w>w', { desc = 'Split Right' })
map('n', 'sh', '<C-w>h', silent)
map('n', 'sj', '<C-w>j', silent)
map('n', 'sk', '<C-w>k', silent)
map('n', 'sl', '<C-w>l', silent)
map('n', 's', '<Nop>', { desc = 'Window/Buffer Prefix' })

map('n', 'sn', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', 'sp', '<cmd>bprevious<cr>', { desc = 'Previous Buffer' })
map('n', 'sd', delete_buffer, { desc = 'Delete Buffer' })
map('n', 'tn', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', 'tp', '<cmd>bprevious<cr>', { desc = 'Previous Buffer' })
map('n', 'td', delete_buffer, { desc = 'Delete Buffer' })
map('n', 'tk', '<cmd>cnext<cr>zz', { desc = 'Next Quickfix' })
map('n', 'tj', '<cmd>cprevious<cr>zz', { desc = 'Previous Quickfix' })

map('n', '<C-w><Left>', '<C-w><')
map('n', '<C-w><Right>', '<C-w>>')
map('n', '<C-w><Up>', '<C-w>+')
map('n', '<C-w><Down>', '<C-w>-')

map('n', '<leader>su', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Substitute Word' })
map('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open netrw' })
map('n', '<leader>lg', function()
  Snacks.lazygit()
end, { desc = '[L]azy[G]it' })
map('n', '[d', function()
  vim.diagnostic.jump { count = -1 }
end, { desc = 'Previous Diagnostic' })
map('n', ']d', function()
  vim.diagnostic.jump { count = 1 }
end, { desc = 'Next Diagnostic' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show Diagnostic Error' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic Quickfix List' })

-- Preserve the search vocabulary from the Kickstart configuration. LazyVim's
-- <leader>f mappings remain available as aliases, but search lives under S.
map('n', '<leader>sh', '<cmd>Telescope help_tags<cr>', { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', '<cmd>Telescope keymaps<cr>', { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sf', '<cmd>Telescope find_files<cr>', { desc = '[S]earch [F]iles' })
map('n', '<leader>ss', '<cmd>Telescope builtin<cr>', { desc = '[S]earch [S]elect Telescope' })
map({ 'n', 'x' }, '<leader>sw', '<cmd>Telescope grep_string<cr>', { desc = '[S]earch current [W]ord' })
map('n', '<leader>sg', '<cmd>Telescope live_grep<cr>', { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', '<cmd>Telescope diagnostics<cr>', { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', '<cmd>Telescope resume<cr>', { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', '<cmd>Telescope oldfiles<cr>', { desc = '[S]earch Recent Files' })
map('n', '<leader>sc', '<cmd>Telescope commands<cr>', { desc = '[S]earch [C]ommands' })
map('n', '<leader><leader>', '<cmd>Telescope buffers<cr>', { desc = 'Find Existing Buffers' })
map('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'Search Current Buffer' })
map('n', '<leader>s/', function()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch Open Files' })
map('n', '<leader>sn', function()
  require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim Files' })

map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
