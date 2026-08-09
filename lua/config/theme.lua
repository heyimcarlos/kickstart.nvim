local M = {
  variant = 'dragon',
}

function M.palette()
  return require('kanagawa.colors').setup({ theme = M.variant }).theme
end

function M.overrides(colors)
  local palette = colors.theme
  local color = require 'kanagawa.lib.color'
  local function diagnostic_background(foreground)
    return {
      fg = foreground,
      bg = color(foreground):blend(palette.ui.bg, 0.95):to_hex(),
    }
  end

  return {
    -- Transparent floating windows with Kanagawa's native border colors.
    NormalFloat = { fg = palette.ui.float.fg, bg = 'none' },
    FloatBorder = { fg = palette.ui.float.fg_border, bg = 'none' },
    FloatTitle = { fg = palette.ui.special, bg = 'none', bold = true },

    -- Explicit dark surfaces for plugin managers that should remain solid.
    NormalDark = { fg = palette.ui.fg_dim, bg = palette.ui.bg_m3 },
    LazyNormal = { fg = palette.ui.fg_dim, bg = palette.ui.bg_m3 },
    MasonNormal = { fg = palette.ui.fg_dim, bg = palette.ui.bg_m3 },

    -- Block-style Telescope using Dragon surfaces instead of waveBlue.
    TelescopeTitle = { fg = palette.ui.special, bold = true },
    TelescopePromptNormal = { bg = palette.ui.bg_p1 },
    TelescopePromptBorder = { fg = palette.ui.float.fg_border, bg = palette.ui.bg_p1 },
    TelescopeResultsNormal = { fg = palette.ui.fg_dim, bg = palette.ui.bg_m1 },
    TelescopeResultsBorder = { fg = palette.ui.float.fg_border, bg = palette.ui.bg_m1 },
    TelescopePreviewNormal = { bg = 'none' },
    TelescopePreviewBorder = { fg = palette.ui.float.fg_border, bg = 'none' },

    -- Snacks links Explorer tree guides to LineNr by default, which also
    -- copies the gutter background. Keep only the subdued guide color.
    SnacksPickerTree = { fg = palette.ui.nontext, bg = 'none' },

    -- Snacks panels and LazyGit keep dedicated surfaces. Other floats use the
    -- transparent Kanagawa highlights configured above.
    SnacksNormal = { fg = palette.ui.fg, bg = palette.ui.bg_m1 },
    SnacksNormalNC = { fg = palette.ui.fg_dim, bg = palette.ui.bg_m1 },
    SnacksWinBar = { fg = palette.ui.special, bg = palette.ui.bg_m1, bold = true },
    SnacksWinBarNC = { fg = palette.ui.nontext, bg = palette.ui.bg_m1 },
    LazyGitNormal = { fg = palette.ui.fg, bg = palette.ui.bg_m1 },
    LazyGitBorder = { fg = palette.ui.nontext, bg = palette.ui.bg_m1 },
    LazyGitInactiveBorder = { fg = palette.ui.fg_dim, bg = palette.ui.bg_m1 },
    LazyGitActiveBorder = { fg = palette.ui.special, bg = palette.ui.bg_m1, bold = true },
    LazyGitSelectedLine = { bg = palette.ui.bg_p1 },

    -- Current Kanagawa exposes ui.fg instead of the README's older ui.shade0.
    Pmenu = { fg = palette.ui.fg, bg = palette.ui.bg_p1 },
    PmenuSel = { fg = 'NONE', bg = palette.ui.bg_p2 },
    PmenuSbar = { bg = palette.ui.bg_m1 },
    PmenuThumb = { bg = palette.ui.bg_p2 },

    DiagnosticVirtualTextHint = diagnostic_background(palette.diag.hint),
    DiagnosticVirtualTextInfo = diagnostic_background(palette.diag.info),
    DiagnosticVirtualTextWarn = diagnostic_background(palette.diag.warning),
    DiagnosticVirtualTextError = diagnostic_background(palette.diag.error),
  }
end

function M.apply()
  for group, highlight in pairs(M.overrides { theme = M.palette() }) do
    vim.api.nvim_set_hl(0, group, highlight)
  end
end

function M.setup()
  vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup('personal-theme', { clear = true }),
    pattern = 'LazyLoad',
    callback = function(event)
      if event.data == 'telescope.nvim' then
        M.apply()
      end
    end,
  })
end

return M
