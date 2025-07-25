local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'ellisonleao/gruvbox.nvim' -- Theme
  use "rebelot/kanagawa.nvim" -- Theme
  use 'nvim-lualine/lualine.nvim' -- Status line
  use 'nvim-treesitter/nvim-treesitter' -- Syntax Highlighting
  use 'nvim-tree/nvim-tree.lua' -- File explorer
  use {
    'nvim-telescope/telescope.nvim', -- Fuzzy Finder
    tag = '0.1.8',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use 'seblyng/roslyn.nvim'
  use 'kvrohit/rasmus.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
