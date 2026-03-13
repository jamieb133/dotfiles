local M = {}

local config = {
    org = '',
    proj = '',
    repo = '',
    pat = '',
}

local state = {
    comments = {},
    index = 0,
    pr_id = nil,
    popup = nil,
}

local function validate_config()
  if not config.org or config.org == "" then
    error("organization not configured")
  end
  if not config.proj or config.proj == "" then
    error("project not configured")
  end
  if not config.repo or config.repo == "" then
    error("repo not configured")
  end
  if not config.pat or config.pat == "" then
    error("pat (Personal Access Token) not configured")
  end
end

local function validate_state()
  if not state.pr_id then
    error("pr_id invalid")
  end
  if not #state.comments == 0 then
    error("no comments loaded")
  end
end

local function azure_get(api)
    validate_config()
    local url = 'https://dev.azure.com/'..config.org..'/'..config.proj..'/_apis/git/repositories/'..config.repo..'/'..api
    local auth = 'Basic ' .. vim.fn.system(string.format("echo -n ':%s' | base64", config.pat)):gsub('\n', '')
    local cmd = "curl -s -H 'Authorization: "..auth.."' '"..url.."'"
    local result = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
        error('GET failed: '..result)
    end
    local ok, decoded = pcall(vim.fn.json_decode, result)
    if not ok then
        error('Failed to decode response: '..decoded)
    end
    return decoded
end

local function fetch_pr(pr_id)
    return azure_get('pullrequests/'..pr_id)
end

local function fetch_comments(pr_id)
    return azure_get('pullrequests/'..pr_id..'/threads')
end

local function close_popup()
    if state.popup and vim.api.nvim_win_is_valid(state.popup) then
        vim.api.nvim_win_close(state.popup, true)
        state.popup = nil
    end
end

local function navigate_to_comment()
    validate_config()
    validate_state()
    close_popup()

    if state.index < 1 or state.index > #state.comments + 1 then
        error("invalid comment index")
    end

    local comment = state.comments[state.index]

    -- Navigate to file
    local root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
    if vim.v.shell_error ~= 0 then
        vim.notify('Not in a git repository', vim.log.levels.ERROR)
        return
    end
    local path = root..comment.path
    if vim.fn.filereadable(path) == 0 then
        vim.notify('File not found: '..path, vim.log.levels.WARN)
        return
    end
    vim.cmd('edit '..path)
    vim.cmd(':'..comment.line)

    -- Display comment thread
    local lines = {}
    table.insert(lines, '========================================')
    local status_line_index = #lines
    table.insert(lines, 'Status: '..comment.status)
    table.insert(lines, 'File: '..comment.path)
    table.insert(lines, 'Line: '..comment.line)
    table.insert(lines, 'Date: '..'TODO')
    table.insert(lines, '')
    for _, c in ipairs(comment.comments) do
        local comment_lines = vim.split(c.content, '\n')
        table.insert(lines, ' > '..c.author..': "'..comment_lines[1]..'"')
        for i, l in ipairs(comment_lines) do
            if i > 1 then
                table.insert(lines, '   '..l)
            end
        end
    end
    table.insert(lines, '========================================')
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'text')
    -- Highlight status
    local hl = comment.status == 'fixed' and 'AzurePRFixed' or 'AzurePROther'
    vim.api.nvim_buf_add_highlight(buf, -1, hl, status_line_index, 0, -1)
    -- Open split window
    vim.cmd('belowright split')
    state.popup = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(state.popup, buf)
    vim.api.nvim_win_set_height(state.popup, #lines)
    -- Go back to code window
    vim.cmd('wincmd p')
    -- Keymap to close
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':AzurePRClose<CR>', { noremap = true, silent = true})
end

local function next_comment()
    if state.index == #state.comments then
        vim.notify('PR comments finished (run AzurePRReset to start again)')
        close_popup()
        return
    end
    state.index = state.index + 1
    navigate_to_comment()
end

local function prev_comment()
    if state.index == 1 then
        vim.notify('Already at oldest comment thread', vim.log.levels.WARN)
        return
    end
    state.index = state.index - 1
    navigate_to_comment()
end

local function reset_pr()
    validate_config()
    validate_state()
    state.index = 1
end

local function parse_branch(path)
    local branch = url:match('refs/heads/(.+)$')
    return branch or nil
end

local function parse_pr(response)
    local pr_info = {}
    if not response.value or #response.value == 0 then
        return comments
    end
    table.insert(pr_info, {status = response.status})
    table.insert(pr_info, {sourceBranch = response.status})
end

local function parse_comments(response)
    local comments = {}
    if not response.value or #response.value == 0 then
        return comments
    end
    for _, thread in ipairs(response.value) do
        if thread.threadContext and thread.threadContext ~= vim.NIL then
            local threadEntry
            if thread.threadContext.filePath ~= vim.NIL then
                threadEntry = { 
                    id = thread.id, 
                    path = thread.threadContext.filePath or '', 
                    line = thread.threadContext.rightFileStart.line or '',
                    status = thread.status,
                    comments = {},
                }
            else
                goto continue
            end
            for _, comment in ipairs(thread.comments) do
                table.insert(threadEntry.comments, {
                    author = comment.author.displayName,
                    content = comment.content,
                })
            end
            table.insert(comments, threadEntry)
            ::continue::
        end
    end
    return comments
end

function M.setup(opts)
    vim.notify('Azure PR Navigator Setup', vim.log.levels.INFO)
    config.org = opts.org
    config.proj = opts.proj
    config.repo = opts.repo
    config.pat = opts.pat
    if opts.pr_id then
        M.load_pr(opts.pr_id)
    end

    print(config.pat)
end

function M.load_pr(pr_id)
    state.pr_id = tonumber(pr_id)
    local ok, response

    -- Get PR info
    ok, response = pcall(fetch_pr, state.pr_id)
    if not ok then
        vim.notify('Error: '..response, vim.log.levels.ERROR)
        return
    end
    state.pr_info = parse_pr(response)

    -- Get comments
    ok, response = pcall(fetch_comments, state.pr_id)
    if not ok then
        vim.notify('Error: '..response, vim.log.levels.ERROR)
        return
    end
    state.comments = parse_comments(response)
    vim.notify('Fetched '..#state.comments..' PR threads', vim.log.levels.INFO)
    state.index = 0 -- Note, this is immediatelly incremented in next()
    M.next()
end

function M.next()
    local ok, result = pcall(next_comment)
    if not ok then
        vim.notify('Failed to get next comment ('..result..')', vim.log.levels.ERROR)
    end
end

function M.prev()
    local ok, result = pcall(prev_comment)
    if not ok then
        vim.notify('Failed to get previous comment ('..result..')', vim.log.levels.ERROR)
    end
end

function M.stop()
    state.pr_id = nil
    state.index = 0
    state.comments = {}
    close_popup()
end

function M.reset()
    local ok, result = pcall(reset_pr)
    if not ok then
        vim.notify('Failed to reset PR ('..result..')', vim.log.levels.ERROR)
    end
end

vim.api.nvim_set_hl(0, 'AzurePRFixed', { fg = '#00ff00', bold = true })
vim.api.nvim_set_hl(0, 'AzurePROther', { fg = '#ffff00', bold = true })

return M

