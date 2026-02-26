if vim.fn.has('nvim') == 0 then
    return
end

local augroup = vim.api.nvim_create_augroup(
    'AzurePR',
    { clear = true }
)

vim.api.nvim_create_user_command(
    'AzurePRSetup',
    function(opts)
        require('azure_pr').setup({
            org = opts.fargs[1] or '',
            proj = opts.fargs[2] or '',
            repo = opts.fargs[3] or '',
            pat = os.getenv('AZURE_PAT') or '',
            pr_id = opts.fargs[4] or nil,
        })
    end,
    {
        nargs = '*',
        desc = 'Setup Azure PR Navigator',
    }
)

vim.api.nvim_create_user_command(
    'AzurePRLoad',
    function(opts)
        require('azure_pr').load_pr(opts.fargs[1])
    end,
    {
        nargs = '*',
        desc = 'Load Azure PR Comments',
    }
)

vim.api.nvim_create_user_command(
    'AzurePRNext',
    function(opts)
        require('azure_pr').next()
    end,
    {
        desc = 'Navigate to next Azure PR Comment Thread',
    }
)

vim.api.nvim_create_user_command(
    'AzurePRPrev',
    function(opts)
        require('azure_pr').prev()
    end,
    {
        desc = 'Navigate to previous Azure PR Comment Thread',
    }
)

vim.api.nvim_create_user_command(
    'AzurePRReset',
    function(opts)
        require('azure_pr').reset()
    end,
    {
        desc = 'Reset to first Azure PR Comment Thread',
    }
)

vim.api.nvim_create_user_command(
    'AzurePRStop',
    function(opts)
        require('azure_pr').stop()
    end,
    {
        desc = 'Stop navigating the current Azure PR Comment Thread',
    }
)
