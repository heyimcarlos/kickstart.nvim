local function check(condition, message)
  if condition then
    return
  end

  vim.api.nvim_err_writeln('Neovim smoke checks: FAIL: ' .. message)
  vim.cmd 'cquit 1'
end

check(vim.g.colors_name == 'kanagawa', 'expected the kanagawa colorscheme')
check(vim.g.lazyvim_picker == 'telescope', 'expected telescope to be the configured picker')
check(vim.g.lazyvim_cmp == 'blink.cmp', 'expected blink.cmp to be the configured completion engine')
check(vim.g.lazyvim_ts_lsp == 'vtsls', 'expected vtsls to be the configured TypeScript LSP')

local expected_extras = {
  ['lazyvim.plugins.extras.ai.copilot'] = true,
  ['lazyvim.plugins.extras.dap.core'] = true,
  ['lazyvim.plugins.extras.editor.telescope'] = true,
  ['lazyvim.plugins.extras.formatting.prettier'] = true,
  ['lazyvim.plugins.extras.lang.astro'] = true,
  ['lazyvim.plugins.extras.lang.go'] = true,
  ['lazyvim.plugins.extras.lang.json'] = true,
  ['lazyvim.plugins.extras.lang.markdown'] = true,
  ['lazyvim.plugins.extras.lang.python'] = true,
  ['lazyvim.plugins.extras.lang.rust'] = true,
  ['lazyvim.plugins.extras.lang.tailwind'] = true,
  ['lazyvim.plugins.extras.lang.typescript'] = true,
  ['lazyvim.plugins.extras.linting.eslint'] = true,
}

local configured_extras = {}
local configured_extra_list = require('lazyvim.config').json.data.extras
check(#configured_extra_list == 13, 'expected exactly 13 Extras in lazyvim.json')
for _, module in ipairs(configured_extra_list) do
  configured_extras[module] = true
end
for module in pairs(expected_extras) do
  check(configured_extras[module], ('expected Extra %q in lazyvim.json'):format(module))
end
for module in pairs(configured_extras) do
  check(expected_extras[module], ('unexpected Extra %q in lazyvim.json'):format(module))
end

local runtime_extras = {}
for _, extra in ipairs(require('lazyvim.util.extras').get()) do
  runtime_extras[extra.module] = extra
end
for module in pairs(expected_extras) do
  local extra = runtime_extras[module]
  check(extra ~= nil, ('expected Extra %q to resolve at runtime'):format(module))
  check(extra.enabled, ('expected Extra %q to be enabled'):format(module))
  check(extra.managed, ('expected Extra %q to be managed by LazyExtras'):format(module))
end

check(vim.o.relativenumber, 'expected relativenumber to be enabled')
check(vim.o.numberwidth == 3, 'expected numberwidth to be 3')
check(vim.o.statuscolumn == '%s%=%{v:relnum == 0 ? v:lnum : v:relnum} ', 'unexpected statuscolumn configuration')

local plugins = require('lazy.core.config').plugins
for _, name in ipairs { 'kanagawa', 'telescope.nvim', 'snacks.nvim', 'nvim-lspconfig' } do
  check(plugins[name] ~= nil, ('expected resolved plugin %q'):format(name))
end
check(plugins.kanagawa.opts.theme == 'dragon', 'expected the Kanagawa dragon theme')

for _, name in ipairs { 'telescope.nvim', 'telescope-fzf-native.nvim', 'plenary.nvim' } do
  check(not plugins[name]._.loaded, ('expected %q to remain unloaded before interaction'):format(name))
end

local lsp_opts = require('lazy.core.plugin').values(plugins['nvim-lspconfig'], 'opts', false)
local lsp_keys = lsp_opts.servers['*'].keys
local intentional_lsp_keys = {
  ['grD'] = { desc = 'LSP: Goto Declaration', has = 'declaration' },
  ['grr'] = { desc = 'LSP: Goto References', has = 'references' },
  ['gri'] = { desc = 'LSP: Goto Implementation', has = 'implementation' },
  ['grd'] = { desc = 'LSP: Goto Definition', has = 'definition' },
  ['grt'] = { desc = 'LSP: Goto Type Definition', has = 'typeDefinition' },
  ['gO'] = { desc = 'LSP: Document Symbols', has = 'documentSymbol' },
  ['gW'] = { desc = 'LSP: Workspace Symbols', has = 'workspace/symbol' },
  ['<leader>th'] = { desc = 'LSP: Toggle Inlay Hints', has = 'inlayHint' },
}
local resolved_lsp_keys = {}
for _, key in ipairs(lsp_keys) do
  check(key[1] ~= 'grn' and key[1] ~= 'gra', ('expected Neovim to retain ownership of %q'):format(key[1]))
  local expected = intentional_lsp_keys[key[1]]
  if expected then
    check(not resolved_lsp_keys[key[1]], ('duplicate intentional LSP mapping %q'):format(key[1]))
    check(key.desc == expected.desc, ('unexpected description for LSP mapping %q'):format(key[1]))
    check(key.has == expected.has, ('unexpected capability filter for LSP mapping %q'):format(key[1]))
    check(type(key[2]) == 'function', ('expected LSP mapping %q to resolve to a callback'):format(key[1]))
    resolved_lsp_keys[key[1]] = true
  end
end
for lhs in pairs(intentional_lsp_keys) do
  check(resolved_lsp_keys[lhs], ('missing intentional LSP mapping %q'):format(lhs))
end

require('lazyvim.config').load 'keymaps'
for _, lhs in ipairs { '<leader>lg', 'sd', 'sn', 'sp' } do
  local mapping = vim.fn.maparg(lhs, 'n', false, true)
  check(type(mapping) == 'table' and type(mapping.desc) == 'string' and mapping.desc ~= '', ('expected %q to have a description'):format(lhs))
end

for lhs, desc in pairs { ['[d'] = 'Prev Diagnostic', [']d'] = 'Next Diagnostic' } do
  local mapping = vim.fn.maparg(lhs, 'n', false, true)
  check(type(mapping) == 'table' and mapping.desc == desc, ('expected inherited diagnostic mapping %q'):format(lhs))
end
for _, mode in ipairs { 'i', 'n', 's' } do
  local escape = vim.fn.maparg('<Esc>', mode, false, true)
  check(type(escape) == 'table' and escape.desc == 'Escape and Clear hlsearch', ('expected inherited Escape mapping in %s mode'):format(mode))
end
for _, mode in ipairs { 'n', 'x' } do
  for lhs, desc in pairs { j = 'Down', k = 'Up' } do
    local mapping = vim.fn.maparg(lhs, mode, false, true)
    check(type(mapping) == 'table' and mapping.desc == desc, ('expected inherited %q mapping in %s mode'):format(lhs, mode))
  end
end

local function feed(keys)
  vim.api.nvim_feedkeys(vim.keycode(keys), 'x', false)
end

local diagnostic_namespace = vim.api.nvim_create_namespace 'smoke-diagnostics'
vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight' })
vim.diagnostic.set(diagnostic_namespace, 0, {
  { lnum = 1, col = 0, message = 'two' },
  { lnum = 3, col = 0, message = 'four' },
  { lnum = 5, col = 0, message = 'six' },
  { lnum = 7, col = 0, message = 'eight' },
})
vim.api.nvim_win_set_cursor(0, { 1, 0 })
feed '3]d'
check(vim.api.nvim_win_get_cursor(0)[1] == 6, 'expected 3]d to jump forward three diagnostics')
local diagnostic_float = false
vim.wait(100, function()
  for _, window in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(window).relative ~= '' then
      diagnostic_float = true
    end
  end
  return diagnostic_float
end)
check(diagnostic_float, 'expected diagnostic jump to open floating context')
feed '2[d'
check(vim.api.nvim_win_get_cursor(0)[1] == 2, 'expected 2[d to jump backward two diagnostics')
vim.diagnostic.reset(diagnostic_namespace, 0)

local snippet_stopped = false
local snippet_stop = LazyVim.cmp.actions.snippet_stop
LazyVim.cmp.actions.snippet_stop = function()
  snippet_stopped = true
end
vim.fn.setreg('/', 'one')
vim.o.hlsearch = true
vim.fn.search 'one'
feed '<Esc>'
LazyVim.cmp.actions.snippet_stop = snippet_stop
check(snippet_stopped, 'expected Escape to stop the active snippet session')
check(vim.v.hlsearch == 0, 'expected Escape to clear search highlighting')

vim.api.nvim_buf_set_lines(0, 0, -1, false, { string.rep('wrapped ', 40), 'next line' })
vim.wo.wrap = true
vim.api.nvim_win_set_width(0, 40)
vim.api.nvim_win_set_cursor(0, { 1, 0 })
feed 'j'
local wrapped_cursor = vim.api.nvim_win_get_cursor(0)
check(wrapped_cursor[1] == 1 and wrapped_cursor[2] > 0, 'expected j to move down within a wrapped line')
feed 'k'
check(vim.deep_equal(vim.api.nvim_win_get_cursor(0), { 1, 0 }), 'expected k to move up within a wrapped line')
vim.bo.modified = false

local search_spec = require 'plugins.search'
local telescope_spec = search_spec[1]
local grug_spec = search_spec[2]
local noice_spec = search_spec[3]
local telescope_keys = telescope_spec.keys
check(#telescope_keys == 9, 'expected exactly nine intentional local Telescope mappings')
check(#grug_spec.keys == 2, 'expected one grug-far disable and one replacement mapping')
check(
  grug_spec.keys[1][1] == '<leader>sr' and grug_spec.keys[1][2] == false and vim.deep_equal(grug_spec.keys[1].mode, { 'n', 'x' }),
  'expected the upstream grug-far search key to be disabled in normal and visual modes'
)
check(grug_spec.keys[2][1] == '<leader>rr', 'expected grug-far search and replace on <leader>rr')
check(
  #noice_spec.keys == 1 and noice_spec.keys[1][1] == '<leader>sn' and noice_spec.keys[1][2] == false,
  'expected only the empty Noice parent key to be disabled'
)

local intentional_search_keys = {
  ['<leader>sf'] = '[S]earch [F]iles',
  ['<leader>ss'] = '[S]earch [S]elect Telescope',
  ['<leader>sr'] = '[S]earch [R]esume',
  ['<leader>s.'] = '[S]earch Recent Files',
  ['<leader>sc'] = '[S]earch [C]ommands',
  ['<leader><leader>'] = 'Find Existing Buffers',
  ['<leader>/'] = 'Search Current Buffer',
  ['<leader>s/'] = '[S]earch Open Files',
  ['<leader>sn'] = '[S]earch [N]eovim Files',
}
local declared_search_keys = {}
for _, key in ipairs(telescope_keys) do
  local lhs = key[1]
  check(intentional_search_keys[lhs] ~= nil, ('unexpected local Telescope mapping %q'):format(lhs))
  check(not declared_search_keys[lhs], ('duplicate local Telescope mapping %q'):format(lhs))
  declared_search_keys[lhs] = true
end
require('lazy').load { plugins = { 'telescope.nvim', 'noice.nvim', 'grug-far.nvim' } }
for lhs, desc in pairs(intentional_search_keys) do
  check(declared_search_keys[lhs], ('missing local Telescope mapping %q'):format(lhs))
  local mapping = vim.fn.maparg(lhs, 'n', false, true)
  check(type(mapping) == 'table' and mapping.desc == desc, ('expected %q to retain description %q'):format(lhs, desc))
end

for _, lhs in ipairs { '<leader>sh', '<leader>sk', '<leader>sw', '<leader>sg', '<leader>sd' } do
  local mapping = vim.fn.maparg(lhs, 'n', false, true)
  check(type(mapping) == 'table' and type(mapping.desc) == 'string' and mapping.desc ~= '', ('expected inherited mapping %q'):format(lhs))
end
local visual_word_search = vim.fn.maparg('<leader>sw', 'x', false, true)
check(type(visual_word_search) == 'table' and type(visual_word_search.desc) == 'string', 'expected inherited visual word search')

local resume = vim.fn.maparg('<leader>sr', 'n', false, true)
check(resume.rhs == '<cmd>Telescope resume<cr>' and resume.desc == '[S]earch [R]esume', 'expected Telescope Resume to own <leader>sr after plugin load')
local visual_resume = vim.fn.maparg('<leader>sr', 'x', false, true)
check(type(visual_resume) ~= 'table' or next(visual_resume) == nil, 'expected no visual grug-far handler on <leader>sr')
for _, mode in ipairs { 'n', 'x' } do
  local replace = vim.fn.maparg('<leader>rr', mode, false, true)
  check(type(replace) == 'table' and replace.desc == 'Search and Replace', ('expected grug-far replacement in %s mode'):format(mode))
end
for _, lhs in ipairs { '<leader>snl', '<leader>snh', '<leader>sna', '<leader>snd', '<leader>snt' } do
  local noice = vim.fn.maparg(lhs, 'n', false, true)
  check(type(noice) == 'table' and type(noice.desc) == 'string' and noice.desc ~= '', ('expected Noice child mapping %q'):format(lhs))
end

for _, name in ipairs { 'FloatBorder', 'TelescopePromptNormal', 'SnacksPickerTree' } do
  local ok, highlight = pcall(vim.api.nvim_get_hl, 0, { name = name })
  check(ok and type(highlight) == 'table' and next(highlight) ~= nil, ('expected highlight group %q to resolve to a non-empty definition'):format(name))
end

print 'Neovim smoke checks: PASS'
vim.cmd 'qa'
