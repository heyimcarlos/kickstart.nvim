local oxfmt_filetypes = {
  'astro',
  'javascript',
  'javascriptreact',
  'json',
  'jsonc',
  'svelte',
  'typescript',
  'typescriptreact',
  'vue',
}

local biome_filetypes = {
  'css',
  'graphql',
  'scss',
}

return {
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.oxfmt = vim.tbl_deep_extend('force', opts.formatters.oxfmt or {}, {
        require_cwd = true,
      })

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, filetype in ipairs(oxfmt_filetypes) do
        opts.formatters_by_ft[filetype] = {
          'oxfmt',
          'biome-check',
          'prettier',
          stop_after_first = true,
        }
      end
      for _, filetype in ipairs(biome_filetypes) do
        opts.formatters_by_ft[filetype] = {
          'biome-check',
          'prettier',
          stop_after_first = true,
        }
      end
    end,
  },
}
