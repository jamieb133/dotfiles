-- Set keybindings for jump to def, hover etc
local on_attach = function(_, _)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {})
    vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, {})
end

-- Essential for nvim-cmp integration
local capabilities = require('cmp_nvim_lsp').default_capabilities() 

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { 
        "clangd",
        "ts_ls",
    }
})

require("cmp").setup({
    sources = {
        { name = 'nvim_lsp' }
    }
})

require("lspconfig").clangd.setup {
    on_attach = on_attach
}

require("lspconfig").ts_ls.setup {
    on_attach = on_attach
}

require('lspconfig').ts_ls.setup({
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
