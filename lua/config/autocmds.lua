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
