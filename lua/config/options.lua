-- TypeScript server ownership comes from the managed tsgo Extra. Effect
-- projects provide its patched project-local node_modules/.bin/tsc binary.
vim.g.lazyvim_python_lsp = 'ty'
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = 'telescope'
vim.g.lazyvim_cmp = 'blink.cmp'
vim.g.have_nerd_font = true

vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = 'yes:1'
vim.opt.foldcolumn = '0'
vim.opt.statuscolumn = '%s%=%{v:relnum == 0 ? v:lnum : v:relnum} '
vim.opt.showtabline = 2
vim.opt.winborder = 'rounded'
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
