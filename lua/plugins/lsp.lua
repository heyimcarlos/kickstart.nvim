local oxlint_markers = {
  '.oxlintrc.json',
  '.oxlintrc.jsonc',
  'oxlint.config.ts',
}

local function prefer_oxlint(server)
  return function(_, opts)
    local fallback_root = vim.lsp.config[server].root_dir
    opts.root_dir = function(bufnr, on_dir)
      if vim.fs.root(bufnr, oxlint_markers) then
        return
      end
      fallback_root(bufnr, on_dir)
    end
  end
end

local function project_effect_tsgo(dispatchers, config)
  local cmd = 'tsgo'
  local root_dir = (config or {}).root_dir
  if root_dir then
    local effect_tsgo = vim.fs.joinpath(root_dir, 'node_modules', '@effect', 'tsgo', 'package.json')
    local tsc = vim.fs.joinpath(root_dir, 'node_modules', '.bin', 'tsc')
    local tsgo = vim.fs.joinpath(root_dir, 'node_modules', '.bin', 'tsgo')
    if vim.fn.filereadable(effect_tsgo) == 1 and vim.fn.executable(tsc) == 1 then
      cmd = tsc
    elseif vim.fn.executable(tsgo) == 1 then
      cmd = tsgo
    end
  end
  return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
end

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- hide inferred-type inlay hints; hover (<K>) or <leader>th shows them
      inlay_hints = { enabled = false },
      servers = {
        tsgo = {
          -- Effect projects own the patched @effect/tsgo binary locally.
          cmd = project_effect_tsgo,
          mason = false,
        },
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
      setup = {
        biome = prefer_oxlint 'biome',
        eslint = prefer_oxlint 'eslint',
      },
    },
  },
}
