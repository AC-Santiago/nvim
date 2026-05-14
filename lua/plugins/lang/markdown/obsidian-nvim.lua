local vault_path = os.getenv("OBSIDIAN_VAULT_PATH") or (vim.fn.expand("~") .. "/Escritorio/Notas/SantiagoAC-Vault/")

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    enabled = function()
        return vim.fn.isdirectory(vim.fn.expand(vault_path)) == 1
    end,
    ft = "markdown",
    cmd = { "Obsidian" },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
        legacy_commands = false,

        workspaces = {
            {
                name = "SantiagoAC",
                path = function()
                    return vault_path
                end,
            },
        },

        notes_subdir = "1 - Rough Notes (Limbo)",
        new_notes_location = "5 - Apuntes",

        --- Follow vault-cli naming: YYYYMMDDHHMMSS-slug-title.md
        --- Path: {vault}/{new_notes_location}/{timestamp}-{slug}.md
        note_path_func = function(spec)
            local timestamp = os.date("%Y%m%d%H%M%S")
            local title = spec.title or ""
            -- Generate slug from title
            local slug = title:gsub("%s+", "-"):lower()
            slug = slug:gsub("[^A-Za-z0-9áéíóúÁÉÍÓÚñÑüÜ%-]", "")
            slug = slug:gsub("-+", "-"):gsub("^-*", ""):gsub("-*$", "")
            if slug == "" or slug == "-" then
                slug = "nota"
            end
            local filename = timestamp .. "-" .. slug .. ".md"
            return spec.dir / filename
        end,

        note_id_func = function(title)
            -- Following vault-cli naming convention: YYYYMMDDHHMMSS-slug-title.md
            local timestamp = os.date("%Y%m%d%H%M%S")
            if title ~= nil and title ~= "" then
                -- Convert title to slug (preserve accents, lowercase, replace spaces with -)
                local slug = title:gsub("%s+", "-"):lower()
                slug = slug:gsub("[^A-Za-z0-9áéíóúÁÉÍÓÚñÑüÜ%-]", "")
                slug = slug:gsub("-+", "-"):gsub("^-*", ""):gsub("-*$", "")
                if slug == "" or slug == "-" then
                    return timestamp
                end
                return timestamp .. "-" .. slug
            else
                return timestamp
            end
        end,

        frontmatter = {
            enabled = true,
            sort = { "tipo", "fuente", "estado", "creado", "actualizado", "tags", "relacionadas" },
            func = function(note)
                local now_date = os.date("%Y-%m-%d-%a")
                local now_time = os.date("%H:%M")
                local now_full = now_date .. " " .. now_time

                local out = {
                    tipo = note.metadata and note.metadata.tipo or "permanente",
                    fuente = note.metadata and note.metadata.fuente or "",
                    estado = note.metadata and note.metadata.estado or "activo",
                    creado = note.metadata and note.metadata.creado or now_full,
                    actualizado = now_full, -- Siempre se actualiza
                    tags = note.tags or {},
                    relacionadas = note.metadata and note.metadata.relacionadas or {},
                }

                if note.metadata ~= nil then
                    for k, v in pairs(note.metadata) do
                        if out[k] == nil then
                            out[k] = v
                        end
                    end
                end

                return out
            end,
        },

        templates = {
            folder = "6 - Templates",
            date_format = "%Y-%m-%d-%a",
            time_format = "%H:%M",
            substitutions = {
                yesterday = function()
                    return os.date("%Y-%m-%d-%a", os.time() - 86400)
                end,
                tomorrow = function()
                    return os.date("%Y-%m-%d-%a", os.time() + 86400)
                end,
                week = function()
                    return os.date("%Y-W%V")
                end,
                -- Variables para tu frontmatter
                datetime = function()
                    return os.date("%Y-%m-%d-%a %H:%M")
                end,
            },
        },

        daily_notes = {
            folder = "0 - Daily",
            date_format = "%Y-%m-%d-%a",
            alias_format = "%A, %d de %B de %Y",
            default_tags = { "daily", "journal" },
            template = "daily.md",
            workdays_only = false,
        },

        link = {
            style = "wiki",
            format = "shortest",
            auto_update = false,
        },

        attachments = {
            folder = "attachments",
            img_name_func = function()
                return string.format("img-%s", os.date("%Y%m%d%H%M%S"))
            end,
            confirm_img_paste = true,
        },

        completion = {
            nvim_cmp = {
                enabled = false,
            },
            suggest = {
                from_notes = true,
            },
            blink = true,
            min_chars = 2,
            match_case = true,
            create_new = true,
        },

        picker = {
            name = "telescope.nvim",
            note_mappings = {
                new = "<C-x>",
                insert_link = "<C-l>",
            },
            tag_mappings = {
                tag_note = "<C-x>",
                insert_tag = "<C-l>",
            },
        },

        ui = {
            enable = true,
            update_debounce = 200,
            max_file_length = 5000,
            -- checkboxes = {
            --     [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
            --     ["x"] = { char = "", hl_group = "ObsidianDone" },
            --     [">"] = { char = "", hl_group = "ObsidianRightArrow" },
            --     ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
            --     ["!"] = { char = "", hl_group = "ObsidianImportant" },
            --     ["/"] = { char = "󰡖", hl_group = "ObsidianTodo" },
            --     ["-"] = { char = "󰰱", hl_group = "ObsidianTilde" },
            -- },
            bullets = { char = "•", hl_group = "ObsidianBullet" },
            external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
            reference_text = { hl_group = "ObsidianRefText" },
            highlight_text = { hl_group = "ObsidianHighlightText" },
            tags = { hl_group = "ObsidianTag" },
            block_ids = { hl_group = "ObsidianBlockID" },
            hl_groups = {
                ObsidianTodo = { bold = true, fg = "#f78c6c" },
                ObsidianDone = { bold = true, fg = "#89ddff" },
                ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
                ObsidianTilde = { bold = true, fg = "#ff5370" },
                ObsidianImportant = { bold = true, fg = "#d73128" },
                ObsidianBullet = { bold = true, fg = "#89ddff" },
                ObsidianRefText = { underline = true, fg = "#c792ea" },
                ObsidianExtLinkIcon = { fg = "#c792ea" },
                ObsidianTag = { italic = true, fg = "#89ddff" },
                ObsidianBlockID = { italic = true, fg = "#89ddff" },
                ObsidianHighlightText = { bg = "#75662e" },
            },
        },

        footer = {
            enabled = true,
            format = "󰿨 {{backlinks}} backlinks │ 󰠱 {{properties}} props │ 󰈙 {{words}} words",
            hl_group = "Comment",
            separator = string.rep("─", 80),
        },

        callbacks = {
            enter_note = function(note)
                local actions = require("obsidian.actions")
                vim.opt_local.spell = true
                vim.opt_local.spelllang = { "es", "en" }
                vim.keymap.set("n", "]o", function()
                    actions.nav_link("next")
                end, { buffer = true, desc = "Obsidian: Next link" })
                vim.keymap.set("n", "[o", function()
                    actions.nav_link("prev")
                end, { buffer = true, desc = "Obsidian: Previous link" })
            end,
            -- Forzar actualizar frontmatter al guardar cualquier nota en el vault
            write_pre = function(note)
                local now_date = os.date("%Y-%m-%d-%a")
                local now_time = os.date("%H:%M")
                note.metadata = note.metadata or {}
                note.metadata.actualizado = now_date .. " " .. now_time
            end,
        },

        open = {
            use_advanced_uri = false,
            func = vim.ui.open,
        },

        checkbox = {
            enabled = true,
            create_new = true,
            order = { " ", "/", "x", "~", "!", ">" },
        },
    },

    keys = {
        { "<leader>on", "<cmd>Obsidian new<CR>", desc = "Obsidian: Nueva nota" },
        { "<leader>oo", "<cmd>Obsidian open<CR>", desc = "Obsidian: Abrir en app" },
        { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Obsidian:  Buscar notas" },
        { "<leader>oq", "<cmd>Obsidian quick_switch<CR>", desc = "Obsidian: Cambiar nota" },
        { "<leader>ot", "<cmd>Obsidian today<CR>", desc = "Obsidian: Nota de hoy" },
        { "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "Obsidian: Nota de ayer" },
        { "<leader>om", "<cmd>Obsidian tomorrow<CR>", desc = "Obsidian:  Nota de mañana" },
        { "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Obsidian: Backlinks" },
        { "<leader>ol", "<cmd>Obsidian links<CR>", desc = "Obsidian: Links en nota" },
        { "<leader>og", "<cmd>Obsidian tags<CR>", desc = "Obsidian:  Buscar por tags" },
        { "<leader>oc", "<cmd>Obsidian toggle_checkbox<CR>", desc = "Obsidian: Toggle checkbox" },
        { "<leader>op", "<cmd>Obsidian paste_img<CR>", desc = "Obsidian:  Pegar imagen" },
        { "<leader>oT", "<cmd>Obsidian template<CR>", desc = "Obsidian: Insertar template" },
        { "<leader>or", "<cmd>Obsidian rename<CR>", desc = "Obsidian: Renombrar nota" },
        -- Modo visual
        { "<leader>oe", ":'<,'>Obsidian extract_note<CR>", mode = "v", desc = "Obsidian:  Extraer a nueva nota" },
        { "<leader>ok", ":'<,'>Obsidian link<CR>", mode = "v", desc = "Obsidian: Crear link" },
        { "<leader>oK", ":'<,'>Obsidian link_new<CR>", mode = "v", desc = "Obsidian: Link a nueva nota" },
    },
}
