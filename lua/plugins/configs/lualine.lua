local options = {
  options = {
    theme = 'onedark',
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = {
      {
        'branch',
        -- icon = '',
      },
      {
        'diff',
        symbols = { 
          added = ' ',
          modified = '柳',
          removed = ' '
        },
      },
      {
        'diagnostics',
        symbols = { 
          error = ' ', 
          warn = ' ', 
          info = ' '
        },
      }
    },
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2, gui = 'bold' },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}

return options
