local builtin = require('telescope.builtin')
local telescope = require('telescope')

telescope.setup {
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = "which_key"
            }
        }
    },
    pickers = {
        find_files = {
            hidden = true
        }
    },
    extensions = {

    }
}

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files ' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
