local options = {
  options = {
    -- mode = "tabs",
    separator_style = "slope",
    indicator = {
      style = 'underline' ,
    },
    close_icon = '',
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = true,
    offsets = {
      {
        filetype = "NvimTree",
        -- text = "File Explorer",
        text = function()
          return vim.fn.getcwd()
        end,
        highlight = "Directory",
        text_align = "left",
        separator = true,
      }
    },
    -- hover = {
    --   enabled = true,
    --   delay = 200,
    --   reveal = {'close'}
    -- },
    -- highlight = {
    --   buffer_selected = {
    --     fg = normal_fg,
    --     bold = true,
    --     italic = true,
    --   },
    -- },
  }
}

return options
