return {
  -- Theme configuration
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    name = 'onedark',
    init = function()
      vim.cmd.colorscheme 'onedark'
      vim.cmd.hi 'Comment gui=none'
    end,
    opts = {
      style = 'darker',
      transparent = true,
      code_style = {
        comments = 'none',
        functions = 'italic',
        keywords = 'bold',
      },
    },
  },
  -- End of theme configuration
}
