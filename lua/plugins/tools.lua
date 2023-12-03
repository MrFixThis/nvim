local set_keymap = require('utils').set_keymap
return {
  -- ChatGPT.nvim
  {
    'jackMort/ChatGPT.nvim',
    enabled = false,
    cmd = {
      'ChatGPT',
      'ChatGPTActAs',
      'ChatGPTEditWithInstructions',
      'ChatGPTCompleteCode',
      'ChatGPTRunCustomCodeAction',
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = {
      keymaps = {
        close = { '<C-c>' },
        yank_last = '<C-y>',
        yank_last_code = '<C-k>',
        scroll_up = '<C-u>',
        scroll_down = '<C-d>',
        toggle_settings = '<C-o>',
        new_session = '<C-n>',
        cycle_windows = '<Tab>',
        -- in the Sessions pane
        select_session = 's',
        rename_session = 'r',
        delete_session = 'd',
      },
      popup_input = {
        submit = '<CR>',
      },
      popup_layout = {
        default = 'center',
        center = {
          width = '90%',
          height = '80%',
        },
      },
      openai_params = { max_tokens = 555 },
    },
  },

  -- Toggleterm
  {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    version = '*',
    opts = {
      open_mapping = [[<A-t>]],
      shade_filetypes = {},
      shading_factor = 1,
      direction = 'float',
      float_opts = {
        border = 'curved',
        winblend = 0,
      },
    },
    config = function(_, opts)
      local dark_orange = vim.api.nvim_get_color_by_name('DarkOrange')
      opts = vim.tbl_deep_extend('force', {
        opts,
        highlights = {
          FloatBorder = {
            guifg = dark_orange,
          },
        },
      }, opts)
      require('toggleterm').setup(opts)

      --Term spawner
      local spawn_term = function(cmd, dir)
        require('toggleterm.terminal').Terminal
          :new({
            cmd = cmd,
            dir = dir or vim.fn.expand('%:p:h'),
            direction = 'float',
            start_in_insert = true,
            close_on_exit = true,
          })
          :toggle()
      end

      -- Toggleterm keymaps
      set_keymap({
        {
          'n',
          '<localleader>gg',
          function()
            spawn_term('lazygit')
          end,
          { desc = 'Toggle Lazygit' },
        },
        {
          'n',
          '<localleader>gd',
          function()
            spawn_term('lazydocker')
          end,
          { desc = 'Toggle Lazydocker' },
        },
      })
    end,
  },

  -- Crate versioning
  {
    'saecki/crates.nvim',
    ft = 'toml',
    tag = 'stable',
    event = { 'BufReadPre Cargo.toml' },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      popup = {
        autofocus = true,
        show_version_date = true,
        max_height = 20,
        border = 'rounded',
      },
    },
    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)
      set_keymap({
        {
          'n',
          '<localleader>ct',
          function()
            crates.toggle()
          end,
          { desc = 'Crates: Toggle' },
        },
        {
          'n',
          '<localleader>cf',
          function()
            crates.show_features_popup()
          end,
          { desc = 'Crates: Show features' },
        },
        {
          'n',
          '<localleader>cv',
          function()
            crates.show_versions_popup()
          end,
          { desc = 'Crates: Show versions' },
        },
        {
          'n',
          '<localleader>cd',
          function()
            crates.show_dependencies_popup()
          end,
          { desc = 'Crates: Show dependencies' },
        },
        {
          'n',
          '<localleader>cH',
          function()
            crates.open_homepage()
          end,
          { desc = 'Crates: Go to homepage' },
        },
        {
          'n',
          '<localleader>cR',
          function()
            crates.open_repository()
          end,
          { desc = 'Crates: Go to repository' },
        },
        {
          'n',
          '<localleader>cD',
          function()
            crates.open_documentation()
          end,
          { desc = 'Crates: Go to documentation' },
        },
        {
          'n',
          '<localleader>cC',
          function()
            crates.open_crates_io()
          end,
          { desc = 'Crates: Go to crates.io' },
        },
      })
    end,
  },

  -- Markdown preview
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
  },

  -- Colorizer
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      filetypes = { '*', '!lazy' },
      buftype = { '*', '!prompt', '!nofile' },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = 'background', -- Set the display mode.
        virtualtext = '■',
      },
    },
  },

  -- Harpoon
  {
    'ThePrimeagen/harpoon',
    event = 'VeryLazy',
    config = function()
      local hpm = require('harpoon.mark')
      local hpui = require('harpoon.ui')

      set_keymap({
        { 'n', '<leader>hm', hpui.toggle_quick_menu, { desc = 'Telescope: Harpoon marks' } },
        { 'n', '<leader>ha', hpm.add_file, { desc = 'Harpoon: Add file' } },
        { 'n', '<leader>hn', hpui.nav_prev, { desc = 'Harpoon: Previous file' } },
        { 'n', '<leader>hp', hpui.nav_next, { desc = 'Harpoon: Next file' } },
      })
    end,
  },

  -- Persistence.nvim
  {
    'folke/persistence.nvim',
    event = 'VeryLazy',
    config = function()
      local persistence = require('persistence')
      persistence.setup()
      set_keymap({
        -- restore the session for the current directory
        {
          'n',
          '<localleader>ls',
          persistence.load,
          { desc = 'Persistence: Restore current dir session' },
        },
        {
          'n',
          '<localleader>ll',
          function()
            persistence.load({ last = true })
          end,
          { desc = 'Persistence: Restore last session' },
        },
        {
          'n',
          '<localleader>ld',
          persistence.stop,
          { desc = 'Persistence: Stop persistence' },
        },
      })
    end,
  },

  -- Leap
  {
    'ggandor/leap.nvim',
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, desc = 'Leap: forward to' },
      { 'S', mode = { 'n', 'x', 'o' }, desc = 'Leap: backward to' },
      { 'gs', mode = { 'n', 'x', 'o' }, desc = 'Leap: from windows' },
    },
    config = function(_, opts)
      local leap = require('leap')
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ 'x', 'o' }, 'x')
      vim.keymap.del({ 'x', 'o' }, 'X')
    end,
  },

  --Todo-comments
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'BurntSushi/ripgrep',
    },
    keys = {
      {
        '<localleader>tc',
        '<CMD>TodoTelescope<CR>',
        desc = 'TODO Comments: All',
        silent = true,
      },
    },
    opts = {
      gui_style = {
        fg = 'NONE',
        bg = 'NONE',
      },
      highlight = {
        keyword = 'fg',
      },
    },
  },

  -- Trouble.nivm
  {
    'folke/trouble.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    keys = {
      {
        '<localleader>tt',
        '<CMD>TroubleToggle<CR>',
        desc = 'Trouble: Toggle',
        silent = true,
      },
    },
    opts = {
      position = 'top',
    },
  },

  -- Ssr.nvim
  {
    'cshuaimin/ssr.nvim',
    keys = {
      {
        '<localleader>s',
        function()
          require('ssr').open()
        end,
        desc = 'Structural replace',
        mode = { 'n', 'x' },
      },
    },
  },

  -- Yanky.nvim
  {
    'gbprod/yanky.nvim',
    enabled = false,
    event = 'BufReadPost',
    config = function() end, -- TODO: Config Yanky
  },

  -- Undo tree
  {
    'mbbill/undotree',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      set_keymap({
        { 'n', '<leader>u', '<CMD>UndotreeShow<CR>', { desc = 'Undotree toggle' } },
      })
    end,
  },

  -- Maximizer
  {
    'szw/vim-maximizer',
    keys = {
      {
        '<leader>ma',
        '<CMD>MaximizerToggle!<CR>',
        desc = 'Maximizer toggle',
        silent = true,
      },
    },
  },
}
