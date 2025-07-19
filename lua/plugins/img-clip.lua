return {
    -- support for image pasting
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
        -- recommended settings
        default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
                enabled = false,
                insert_mode = false,
            },
            -- required for Windows users
            use_absolute_path = false,
        },
        disable_not_image_warning = true,
        show_not_image_warning = false, -- Deshabilitar advertencias cuando el contenido no es una imagen
        notify_on_error = false, -- Deshabilitar notificaciones de error

        filetypes = {
            typst = {
                template = [[
#figure(
  image("$FILE_PATH",),
  caption: [$CURSOR],
) <fig-$LABEL>
    ]], ---@type string | fun(context: table): string
            },
        },
    },
}
