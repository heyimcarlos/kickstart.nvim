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

map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
