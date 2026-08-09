return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ['*'] = {
          keys = {
            { 'grD', vim.lsp.buf.declaration, desc = 'LSP: Goto Declaration', has = 'declaration' },
            {
              'grr',
              function()
                require('telescope.builtin').lsp_references()
              end,
              desc = 'LSP: Goto References',
              has = 'references',
            },
            {
              'gri',
              function()
                require('telescope.builtin').lsp_implementations()
              end,
              desc = 'LSP: Goto Implementation',
              has = 'implementation',
            },
            {
              'grd',
              function()
                require('telescope.builtin').lsp_definitions()
              end,
              desc = 'LSP: Goto Definition',
              has = 'definition',
            },
            {
              'grt',
              function()
                require('telescope.builtin').lsp_type_definitions()
              end,
              desc = 'LSP: Goto Type Definition',
              has = 'typeDefinition',
            },
            {
              'gO',
              function()
                require('telescope.builtin').lsp_document_symbols()
              end,
              desc = 'LSP: Document Symbols',
              has = 'documentSymbol',
            },
            {
              'gW',
              function()
                require('telescope.builtin').lsp_dynamic_workspace_symbols()
              end,
              desc = 'LSP: Workspace Symbols',
              has = 'workspace/symbol',
            },
            {
              '<leader>th',
              function()
                local buffer = vim.api.nvim_get_current_buf()
                local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = buffer }
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = buffer })
              end,
              desc = 'LSP: Toggle Inlay Hints',
              has = 'inlayHint',
            },
          },
        },
      },
    },
  },
}
