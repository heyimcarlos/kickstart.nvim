return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        python = { 'pylint' },
        -- golang = { 'golangci-lint' },
        -- terraform = { 'tflint' },
        -- json = { 'jsonlint' },
        -- dockerfile = { 'hadolint' },
        -- text = { "vale" },
      }

      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })

      vim.keymap.set('n', '<leader>li', function()
        lint.try_lint()
      end, { desc = 'Trigger linting for current file' })
    end,
  },
}
