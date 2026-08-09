return {
  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      theme = 'dragon',
      background = {
        dark = 'dragon',
        light = 'lotus',
      },
      overrides = function(colors)
        local theme = colors.theme
        local color = require 'kanagawa.lib.color'
        local function diagnostic_background(foreground)
          return {
            fg = foreground,
            bg = color(foreground):blend(theme.ui.bg, 0.95):to_hex(),
          }
        end

        return {
          -- Transparent floating windows with Kanagawa's native border colors.
          NormalFloat = { fg = theme.ui.float.fg, bg = 'none' },
          FloatBorder = { fg = theme.ui.float.fg_border, bg = 'none' },
          FloatTitle = { fg = theme.ui.special, bg = 'none', bold = true },

          -- Explicit dark surfaces for plugin managers that should remain solid.
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
          LazyNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
          MasonNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Block-style Telescope using Dragon surfaces instead of waveBlue.
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.float.fg_border, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.float.fg_border, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = 'none' },
          TelescopePreviewBorder = { fg = theme.ui.float.fg_border, bg = 'none' },

          -- Snacks links Explorer tree guides to LineNr by default, which also
          -- copies the gutter background. Keep only the subdued guide color.
          SnacksPickerTree = { fg = theme.ui.nontext, bg = 'none' },

          -- Current Kanagawa exposes ui.fg instead of the README's older ui.shade0.
          Pmenu = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          DiagnosticVirtualTextHint = diagnostic_background(theme.diag.hint),
          DiagnosticVirtualTextInfo = diagnostic_background(theme.diag.info),
          DiagnosticVirtualTextWarn = diagnostic_background(theme.diag.warning),
          DiagnosticVirtualTextError = diagnostic_background(theme.diag.error),
        }
      end,
    },
  },
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = 'kanagawa-dragon',
    },
  },
}
