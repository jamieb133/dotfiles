vim.diagnostic.config({
    -- This is the crucial part for showing text directly on the line
    virtual_text = {
        enabled = true,
        -- You can choose the format. 'text' often looks cleaner.
        -- 'prefix' adds a symbol like '•' before the message.
        -- 'separator' is the string between prefix and message.
        -- Example:
        -- prefix = '•',
        -- separator = ' ',
        -- severity = { min = vim.diagnostic.severity.HINT }, -- Show all levels
    },
    -- Show signs (the icons in the sign column like W, E)
    signs = {
        enabled = true,
        -- You can customize the signs if you want
        -- like: text = { [vim.diagnostic.severity.ERROR] = 'E', ... }
    },
    -- Underline the problematic text
    underline = true,
    -- Configure the behavior of floating windows when diagnostics are hovered
    float = {
        -- Set to true to show the float automatically when hovering
        -- (this is useful to see full messages)
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
    -- Set to false to disable diagnostics in insert mode (can be distracting)
    update_in_insert = false,
})

-- Set keybindings for jump to def, hover etc
local on_attach = function(_, _)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {})
    vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, {})
end

local has_words_before = function()
    -- Check if the line is empty or if the cursor is at the very beginning
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    if col == 0 then
        return false
    end

    local current_line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]

    -- Check if the line is empty after the cursor
    if col >= #current_line_text then
        return false
    end

    -- Adjust column for 1-based indexing for string manipulation
    local char_before_cursor = current_line_text:sub(col, col)

    -- Check if the character before the cursor is NOT a whitespace character
    -- We use `find` here which is more robust than `match` for this purpose
    return char_before_cursor:find("%S") ~= nil
end

-- Essential for nvim-cmp integration
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local cmp = require('cmp')
local lspconfig = require('lspconfig')
local luasnip = require('luasnip')

mason.setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    }
})

mason_lspconfig.setup({
    ensure_installed = {
        "gopls",
        "clangd",
        "ts_ls",
        "pyright",
        "htmx",
        "html",
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

lspconfig.html.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        -- Settings here
    }
}
lspconfig.htmx.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        -- Settings here
    }
}

lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
}

lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
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

