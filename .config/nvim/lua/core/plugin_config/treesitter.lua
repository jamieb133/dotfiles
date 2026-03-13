require'nvim-treesitter'.setup {
    -- Required languages
    ensure_installed = {
        "lua",
        "vim",
        "bash",
        "c",
        "cpp",
        "cmake",
        "css",
        "csv",
        "json",
        "ninja",
        "powershell",
        "python",
    },

    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
}
