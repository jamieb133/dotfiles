-- Set keybindings for jump to def, hover etc
local on_attach = function(_, _)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {})
    vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, {})
end

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Essential for nvim-cmp integration
local capabilities = require('cmp_nvim_lsp').default_capabilities() 

local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local cmp = require('cmp')
local lspconfig = require('lspconfig')
local luasnip = require('luasnip')

mason.setup()

mason_lspconfig.setup({
    ensure_installed = {
        "clangd",
        "ts_ls",
        "pyright",
    }
})

cmp.setup({
    sources = {
        { name = 'nvim_lsp' }
    },
    mapping = cmp.mapping.preset.insert ({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<s-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<c-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select=true }),
      }),
})

lspconfig.clangd.setup {
    on_attach = on_attach
}

lspconfig.ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
        typescript = {
             inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
        completions = {
            completeFunctionCalls = true,
        },
    },
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
})

lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                -- Set your Python interpreter path
                -- If not set, Pyright will try to discover it
                -- If you use virtual environments, you might not need this if Pyright can find it.
                -- interpreter = '/usr/bin/python3', # Example: explicit path

                -- Enable or disable specific diagnostic checks
                diagnosticSeverityOverrides = {
                    -- reportMissingImport = "information",
                    -- reportUndefinedVariable = "warning",
                },

                autoSearchPaths = true, -- Search for pyproject.toml, setup.py, etc.
                extraPaths = {},
            },
        },
    },
    filetypes = { "python" },
})

