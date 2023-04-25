local default_plugins = {
  "nvim-lua/plenary.nvim",
  "catppuccin/nvim",
  "navarasu/onedark.nvim",
  "onsails/lspkind.nvim",

  { 
    "svrana/neosolarized.nvim",
    requires = { 'tjdevries/colorbuddy.nvim' },
    init = function()
      require("core.utils").lazy_load "neosolarized.nvim"
    end
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return require "plugins.configs.lualine"
    end,
    config = function(_, opts)
      require('lualine').setup(opts)
    end   
  },

  { 
    "mg979/vim-visual-multi",
    init = function()
      require("lazy").load { plugins = "vim-visual-multi" }
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit" },
    init = function()
      require("core.utils").load_mappings "lazygit"
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    config = function(_, opts)
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
 
  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      require("core.utils").load_mappings "blankline"
    end,
    opts = function()
      return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
      require("indent_blankline").setup(opts)
    end,
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    ft = "gitcommit",
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. vim.fn.expand "%:p:h" .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
            vim.schedule(function()
              require("lazy").load { plugins = "gitsigns.nvim" }
            end)
          end
        end,
      })
    end,
    opts = function()
      return require("plugins.configs.others").gitsigns
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = function(_, opts)
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})
    end,
  },

  {
    "neovim/nvim-lspconfig",
    init = function()
      require("core.utils").lazy_load "nvim-lspconfig"
    end,
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },

    opts = function()
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    'akinsho/bufferline.nvim', 
    version = "v3.*", 
    dependencies = 'nvim-tree/nvim-web-devicons',
    init = function()
      require("core.utils").lazy_load "bufferline.nvim"
      require("core.utils").load_mappings "bufferline"
    end,
    opts = function()
      return require "plugins.configs.bufferline"
    end,
    config = function(_, opts)
      vim.opt.termguicolors = true
      require("bufferline").setup(opts)
    end
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      vim.g.nvimtree_side = opts.view.side
    end,
  },

  {
    "nvim-telescope/telescope.nvim", 
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings "telescope"
    end,
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      
      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    "numToStr/Comment.nvim",
    -- keys = { "gc", "gb" },
    init = function()
      require("core.utils").load_mappings "comment"
    end,
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "anuvyklack/fold-preview.nvim",
    dependencies = "anuvyklack/keymap-amend.nvim",
    requires = "anuvyklack/keymap-amend.nvim",
    config = function()
      local fp = require('fold-preview')
      local map = require('fold-preview').mapping
      local keymap = vim.keymap
      keymap.amend = require('keymap-amend')

      fp.setup({ 
        default_keybindings = false,
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder'
      })

      keymap.amend('n', 'K', function(original)
         if not fp.toggle_preview() then original() end
      end)
      keymap.amend('n', 'h',  map.close_preview_open_fold)
      keymap.amend('n', 'l',  map.close_preview_open_fold)
      keymap.amend('n', 'zo', map.close_preview)
      keymap.amend('n', 'zO', map.close_preview)
      keymap.amend('n', 'zc', map.close_preview_without_defer)
      keymap.amend('n', 'zR', map.close_preview)
      keymap.amend('n', 'zM', map.close_preview_without_defer)
    end
  },
  
   {
    "folke/which-key.nvim",
    keys = { "<leader>", '"', "'", "`" },
    init = function()
      require("core.utils").load_mappings "whichkey"
    end,
    opts = function()
      return require "plugins.configs.whichkey"
    end,
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
}


local lazy_config = require "plugins.configs.lazy"
require("lazy").setup(default_plugins, lazy_config)
