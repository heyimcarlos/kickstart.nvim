return {
  {
    'folke/flash.nvim',
    -- Flash owns the bare `s` key and dims the buffer while waiting for a jump.
    -- That conflicts with this config's s-prefixed split/window vocabulary.
    enabled = false,
  },
  {
    'folke/snacks.nvim',
    keys = {
      {
        '<leader>ld',
        function()
          Snacks.terminal({ 'lazydocker' }, {
            cwd = vim.fn.getcwd(0),
            interactive = true,
            win = {
              position = 'float',
              border = 'rounded',
              width = 0.9,
              height = 0.9,
            },
          })
        end,
        desc = 'LazyDocker',
      },
    },
    opts = {
      picker = {
        sources = {
          explorer = {
            layout = {
              preset = 'sidebar',
              layout = { width = 30, min_width = 26 },
            },
          },
        },
      },
      lazygit = {
        configure = true,
        theme = {
          [241] = { fg = 'LazyGitInactiveBorder' },
          activeBorderColor = { fg = 'LazyGitActiveBorder', bold = true },
          inactiveBorderColor = { fg = 'LazyGitInactiveBorder' },
          searchingActiveBorderColor = { fg = 'LazyGitActiveBorder', bold = true },
          defaultFgColor = { fg = 'LazyGitNormal' },
          optionsTextColor = { fg = 'Function' },
          selectedLineBgColor = { bg = 'LazyGitSelectedLine' },
          unstagedChangesColor = { fg = 'DiagnosticError' },
          cherryPickedCommitBgColor = { fg = 'Identifier' },
          cherryPickedCommitFgColor = { fg = 'Function' },
        },
      },
      styles = {
        lazygit = {
          position = 'float',
          backdrop = 80,
          width = 0.92,
          height = 0.92,
          border = 'rounded',
          wo = {
            winhighlight = table.concat({
              'Normal:LazyGitNormal',
              'NormalNC:LazyGitNormal',
              'FloatBorder:LazyGitBorder',
              'WinSeparator:LazyGitBorder',
            }, ','),
          },
        },
      },
    },
  },
  {
    'akinsho/bufferline.nvim',
    opts = function(_, opts)
      local palette = require('config.theme').palette()

      opts.options = vim.tbl_deep_extend('force', opts.options or {}, {
        always_show_bufferline = true,
        separator_style = 'slant',
        show_buffer_close_icons = true,
        show_close_icon = false,
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        max_name_length = 18,
        tab_size = 18,
      })
      opts.highlights = vim.tbl_deep_extend('force', opts.highlights or {}, {
        fill = { bg = palette.ui.bg },
        background = { fg = palette.ui.nontext, bg = palette.ui.bg_m2 },
        buffer_visible = { fg = palette.ui.fg_dim, bg = palette.ui.bg_m1 },
        buffer_selected = {
          fg = palette.ui.fg,
          bg = palette.ui.bg_p1,
          bold = true,
          italic = false,
        },
        close_button = { fg = palette.ui.nontext, bg = palette.ui.bg_m2 },
        close_button_visible = { fg = palette.ui.fg_dim, bg = palette.ui.bg_m1 },
        close_button_selected = { fg = palette.diag.error, bg = palette.ui.bg_p1 },
        separator = { fg = palette.ui.bg, bg = palette.ui.bg_m2 },
        separator_visible = { fg = palette.ui.bg, bg = palette.ui.bg_m1 },
        separator_selected = { fg = palette.ui.bg, bg = palette.ui.bg_p1 },
      })
    end,
  },
  {
    'b0o/incline.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
      local palette = require('config.theme').palette()
      local devicons = require 'nvim-web-devicons'

      return {
        hide = {
          cursorline = false,
          focused_win = false,
          only_win = false,
        },
        ignore = {
          filetypes = {
            'neo-tree',
            'NvimTree',
            'snacks_dashboard',
            'snacks_layout_box',
            'snacks_picker_input',
            'snacks_picker_list',
          },
        },
        window = {
          margin = { horizontal = 0, vertical = 0 },
          padding = 0,
          placement = { horizontal = 'right', vertical = 'top' },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          filename = filename == '' and '[No Name]' or filename

          local icon, icon_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local background = props.focused and palette.ui.bg_p1 or palette.ui.bg_m1
          local foreground = props.focused and palette.ui.fg or palette.ui.fg_dim

          return {
            icon and { ' ' .. icon .. ' ', guifg = icon_color, guibg = background } or ' ',
            { filename, guifg = foreground, guibg = background, gui = modified and 'bold,italic' or 'bold' },
            {
              modified and ' ● ' or ' 󰅖 ',
              guifg = modified and palette.diag.warning or palette.ui.nontext,
              guibg = background,
            },
            guibg = background,
          }
        end,
      }
    end,
  },
  {
    'folke/which-key.nvim',
    opts = {
      -- LazyVim defaults to the right-aligned Helix layout. The old config
      -- used WhichKey's classic bottom popup with columns.
      preset = 'classic',
      delay = 0,
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'x' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'x' } },
        { 'gr', group = 'LSP Actions' },
      },
    },
  },
  {
    'folke/noice.nvim',
    opts = {
      notify = { enabled = false },
      lsp = {
        hover = { enabled = false },
        signature = { enabled = false },
        message = { enabled = false },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },
  {
    'saghen/blink.cmp',
    opts = {
      completion = {
        documentation = { auto_show = false },
      },
      signature = { enabled = true },
    },
  },
}
