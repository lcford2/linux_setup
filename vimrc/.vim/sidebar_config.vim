lua << EOF
local sidebar = require("sidebar-nvim")
local opts = {
    open = true,
    side = "right",
    initial_width = 35,
    hide_statusline = false,
    datetime = { 
        format = "%a %b %d, %I:%M %p",
        clocks = { { name = "local" } }
    },
    sections = { 
        "datetime", 
        "git",
        "buffers",
        "diagnostics",
    },
    buffers = {
        sorting = "name",
        show_numbers = false,
    },
    section_separator = {""},
}
sidebar.setup(opts)
EOF

