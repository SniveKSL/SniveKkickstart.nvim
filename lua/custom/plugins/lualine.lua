-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  -- Status line configuration
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'onedark',
        fmt = string.upper,
      },
      sections = { lualine_a = {
        {
          'mode',
          fmt = function(str)
            return str:sub(1, 3)
          end,
        },
      } },
    },
  },
  -- End of status line config
}
