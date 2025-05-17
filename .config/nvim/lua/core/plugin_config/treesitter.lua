require'nvim-treesitter.configs'.setup {
    -- Required languages
    ensure_installed = {
        "lua",
        "vim",
        "bash",
        "c",
        "cpp",
        "c_sharp",
        "cmake",
        "css",
        "csv",
        "doxygen",
        "gitignore",
        "rust",
        "html",
        "jinja",
        "json",
        "make",
        "ninja",
        "objdump",
        "odin",
        "powershell",
        "python",
        "sql",
        "javascript",
        "typescript",
        "zig",
        "xml"
    },

    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
}
