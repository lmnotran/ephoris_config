------------------------------------------------------------------------------
-- HEADER nvim-cmp
------------------------------------------------------------------------------
local cmp = require('cmp')
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

vim.opt.completeopt = 'menu,menuone,noselect'

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0
		and vim.api.nvim_buf_get_lines(
			0, line - 1, line, true)[1]:sub( col, col):match("%s") == nil
end

local lsp_symbols = {
    Text = "   (Text) ",
    Method = "   (Method)",
    Function = "   (Function)",
    Constructor = "   (Constructor)",
    Field = " ﴲ  (Field)",
    Variable = "[] (Variable)",
    Class = "   (Class)",
    Interface = " ﰮ  (Interface)",
    Module = "   (Module)",
    Property = " 襁 (Property)",
    Unit = "   (Unit)",
    Value = "   (Value)",
    Enum = " 練 (Enum)",
    Keyword = "   (Keyword)",
    Snippet = "   (Snippet)",
    Color = "   (Color)",
    File = "   (File)",
    Reference = "   (Reference)",
    Folder = "   (Folder)",
    EnumMember = "   (EnumMember)",
    Constant = " ﲀ  (Constant)",
    Struct = " ﳤ  (Struct)",
    Event = "   (Event)",
    Operator = "   (Operator)",
    TypeParameter = "   (TypeParameter)",
}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    formatting = {
        format = function(entry, item)
            item.kind = lsp_symbols[item.kind]
            item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
            })[entry.source.name]
            return item
        end,
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
            c = function(fallback)
                if cmp.visible() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end
        }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
    },
    sources = cmp.config.sources({
        { name = 'nvim_diagnostic' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    })
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

