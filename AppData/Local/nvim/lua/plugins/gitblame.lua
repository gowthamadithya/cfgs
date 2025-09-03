-- git blame
vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text

return {
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",

    opts = {
        enabled = true,  -- if you want to enable the plugin
        -- message_template = "<summary> • <date> • <author>",
        message_template = "<author> • <date> • <summary>",
        -- message_template = " <summary> • <date> • <author> • <<sha>>",
        date_format = "%r", -- template for the date, check Date format section for more options
        virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
    },

}
