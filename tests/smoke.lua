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

require 'config.keymaps'
for _, lhs in ipairs { '<leader>lg', '<leader>sf', 'sd', 'sn', 'sp' } do
  local mapping = vim.fn.maparg(lhs, 'n', false, true)
  check(type(mapping) == 'table' and type(mapping.desc) == 'string' and mapping.desc ~= '', ('expected %q to have a description'):format(lhs))
end

for _, name in ipairs { 'FloatBorder', 'TelescopePromptNormal', 'SnacksPickerTree' } do
  local ok, highlight = pcall(vim.api.nvim_get_hl, 0, { name = name })
  check(ok and type(highlight) == 'table' and next(highlight) ~= nil, ('expected highlight group %q to resolve to a non-empty definition'):format(name))
end

print 'Neovim smoke checks: PASS'
vim.cmd 'qa'
