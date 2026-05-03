return {
  {
    name = 'searchandreplace',
    dir = vim.fn.stdpath('config'),
    lazy = false,
    config = function()
      require('searchandreplace').setup()
    end,
  },
}
