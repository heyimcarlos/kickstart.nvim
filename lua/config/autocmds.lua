-- LazyVim already provides yank highlighting and the other general-purpose
-- autocommands that were previously maintained in this configuration.

local function set_ui_highlights()
  local colors = {
    background = '#0d1117',
    surface = '#0d1117',
    overlay = '#161b22',
    foreground = '#e6edf3',
    muted = '#8b949e',
    subtle = '#b1bac4',
    accent = '#ffffff',
  }

  if vim.g.colors_name and vim.g.colors_name:match '^kanagawa' then
    local theme = require('kanagawa.colors').setup({ theme = 'dragon' }).theme
    colors = {
      background = theme.ui.bg,
      surface = theme.ui.bg_m1,
      overlay = theme.ui.bg_p1,
      foreground = theme.ui.fg,
      muted = theme.ui.nontext,
      subtle = theme.ui.fg_dim,
      accent = theme.ui.special,
    }
  end

  -- Snacks panels and LazyGit keep dedicated surfaces. Other floats use the
  -- transparent Kanagawa highlights configured by the colorscheme.
  vim.api.nvim_set_hl(0, 'SnacksNormal', { fg = colors.foreground, bg = colors.surface })
  vim.api.nvim_set_hl(0, 'SnacksNormalNC', { fg = colors.subtle, bg = colors.surface })
  vim.api.nvim_set_hl(0, 'SnacksWinBar', { fg = colors.accent, bg = colors.surface, bold = true })
  vim.api.nvim_set_hl(0, 'SnacksWinBarNC', { fg = colors.muted, bg = colors.surface })

  vim.api.nvim_set_hl(0, 'LazyGitNormal', { fg = colors.foreground, bg = colors.surface })
  vim.api.nvim_set_hl(0, 'LazyGitBorder', { fg = colors.muted, bg = colors.surface })
  vim.api.nvim_set_hl(0, 'LazyGitInactiveBorder', { fg = colors.subtle, bg = colors.surface })
  vim.api.nvim_set_hl(0, 'LazyGitActiveBorder', { fg = colors.accent, bg = colors.surface, bold = true })
  vim.api.nvim_set_hl(0, 'LazyGitSelectedLine', { bg = colors.overlay })
end

set_ui_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('personal-ui-colors', { clear = true }),
  callback = set_ui_highlights,
})

-- Preserve the previous LSP vocabulary while using LazyVim's managed servers.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('personal-lsp-keymaps', { clear = true }),
  callback = function(event)
    local builtin = require 'telescope.builtin'
    local function map(keys, action, description, mode)
      vim.keymap.set(mode or 'n', keys, action, {
        buffer = event.buf,
        desc = 'LSP: ' .. description,
      })
    end

    map('grn', vim.lsp.buf.rename, 'Rename')
    map('gra', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
    map('grD', vim.lsp.buf.declaration, 'Goto Declaration')
    map('grr', builtin.lsp_references, 'Goto References')
    map('gri', builtin.lsp_implementations, 'Goto Implementation')
    map('grd', builtin.lsp_definitions, 'Goto Definition')
    map('grt', builtin.lsp_type_definitions, 'Goto Type Definition')
    map('gO', builtin.lsp_document_symbols, 'Document Symbols')
    map('gW', builtin.lsp_dynamic_workspace_symbols, 'Workspace Symbols')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
      end, 'Toggle Inlay Hints')
    end
  end,
})
