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
