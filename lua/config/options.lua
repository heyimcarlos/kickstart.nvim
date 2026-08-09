-- This remains on vtsls intentionally. It automatically selects the workspace
-- TypeScript SDK, which is required for project-local plugins such as
-- @effect/language-service. TypeScript 7 + @effect/tsgo needs a separate
-- command override; stock tsgo does not include Effect's language service.
vim.g.lazyvim_ts_lsp = 'vtsls'
vim.g.lazyvim_picker = 'telescope'
vim.g.lazyvim_cmp = 'blink.cmp'
vim.g.have_nerd_font = true

vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = 'yes:1'
vim.opt.foldcolumn = '0'
vim.opt.statuscolumn = '%s%=%{v:relnum == 0 ? v:lnum : v:relnum} '
vim.opt.showtabline = 2
vim.opt.clipboard = 'unnamedplus'
vim.opt.scrolloff = 10
vim.opt.colorcolumn = '100'
vim.opt.wrap = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
