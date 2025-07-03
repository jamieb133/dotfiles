vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
    
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.keymap.set('n', '<leader>ee', ':Ex<CR>')
vim.keymap.set('n', '<leader>sp', ':vsplit<CR><C-w>l', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>qq', ':q<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>ww', ':w<CR>', { noremap = true, silent = false })

