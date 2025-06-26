vim.lsp.config("roslyn", {
    on_attach = function()
        print("This will run when the server attaches!")
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
        vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {})
        vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, {})
    end,
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
    },
})

return require('roslyn').setup {
    
}
