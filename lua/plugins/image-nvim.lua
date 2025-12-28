return {
    "3rd/image.nvim",
    build = false,
    ft = { "markdown", "quarto", "qmd", "python" },
    opts = {
        backend = "sixel", -- Works with Kitty, WezTerm, and iTerm2
        processor = "magick_cli", -- or "magick_rock"
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
                only_render_image_at_cursor_mode = "popup", -- or "inline"
                floating_windows = false, -- if true, images will be rendered in floating markdown windows
                filetypes = { "markdown", "vimwiki", "quarto", "qmd" }, -- markdown extensions (ie. quarto) can go here
            },
            neorg = {
                enabled = true,
                filetypes = { "norg" },
            },
            typst = {
                enabled = true,
                filetypes = { "typst" },
            },
            html = {
                enabled = false,
            },
            css = {
                enabled = false,
            },
        },
        max_width = 100,
        max_height = 12,
        max_width_window_percentage = math.huge,
        max_height_window_percentage = math.huge,
        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = false,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },
}
