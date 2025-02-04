------------------------------------------------------------------------------
-- HEADER telescope
------------------------------------------------------------------------------
require('telescope').setup({
    defaults = {
        mapping = {
            i = {
                ['<C-h>'] = 'which_key'
            }
        },
        layout_strategy = 'vertical'
    }
})

require('telescope').load_extension('fzf')
require("telescope").load_extension('file_browser')

vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"
