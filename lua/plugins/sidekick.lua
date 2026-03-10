-- sidekick.nvim - AI sidekick para Neovim (by folke)
-- Integra Copilot NES (Next Edit Suggestions) + Terminal CLI para herramientas AI
local M = {
    "folke/sidekick.nvim",
    event = "LspAttach",
    dependencies = {
        "zbirenbaum/copilot.lua", -- necesario: incluye el copilot-language-server
    },
}

M.opts = {
    -- NES: Next Edit Suggestions (sugerencias de edicion multi-linea de Copilot)
    nes = {
        enabled = true,
        debounce = 100,
        diff = {
            inline = "words",
        },
    },

    -- CLI: Terminal integrado para herramientas AI
    cli = {
        watch = true, -- recargar archivos automaticamente cuando las herramientas AI los modifiquen
        win = {
            layout = "right",
            split = {
                width = 80,
                height = 20,
            },
        },
        -- Sin tmux/zellij disponible, desactivar persistencia de sesiones
        mux = {
            enabled = false,
        },
        -- Herramientas AI disponibles en el sistema
        tools = {
            gemini = { cmd = { "gemini" } },
            opencode = {
                cmd = { "opencode" },
                env = { OPENCODE_THEME = "system" },
            },
        },
        -- Usar telescope como picker (no snacks.nvim)
        picker = "telescope",
    },

    -- Estado de Copilot en statusline
    copilot = {
        status = {
            enabled = true,
            level = vim.log.levels.WARN,
        },
    },
}

M.keys = {
    -- NES: Saltar a la siguiente sugerencia o aplicarla
    -- Usa <C-y> en vez de <Tab> para no interferir con el cambio de buffers
    {
        "<C-y>",
        function()
            if not require("sidekick").nes_jump_or_apply() then
                -- Si no hay sugerencia NES, dejar pasar la tecla normalmente
                return "<C-y>"
            end
        end,
        mode = { "n", "i" },
        expr = true,
        desc = "Sidekick: Ir a / Aplicar sugerencia NES",
    },

    -- CLI: Toggle de la terminal AI
    {
        "<c-.>",
        function()
            require("sidekick.cli").toggle()
        end,
        desc = "Sidekick: Toggle CLI",
        mode = { "n", "t", "i", "x" },
    },

    -- CLI: Toggle con leader
    {
        "<leader>aa",
        function()
            require("sidekick.cli").toggle()
        end,
        desc = "Sidekick: Toggle CLI",
    },

    -- CLI: Selector de herramientas AI
    {
        "<leader>as",
        function()
            require("sidekick.cli").select()
        end,
        desc = "Sidekick: Seleccionar CLI",
    },

    -- CLI: Cerrar/desconectar sesion
    {
        "<leader>ad",
        function()
            require("sidekick.cli").close()
        end,
        desc = "Sidekick: Cerrar CLI",
    },

    -- CLI: Enviar contexto actual (posicion del cursor o seleccion)
    {
        "<leader>at",
        function()
            require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "x", "n" },
        desc = "Sidekick: Enviar esto",
    },

    -- CLI: Enviar archivo actual
    {
        "<leader>af",
        function()
            require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Sidekick: Enviar archivo",
    },

    -- CLI: Enviar seleccion visual
    {
        "<leader>av",
        function()
            require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Sidekick: Enviar seleccion visual",
    },

    -- CLI: Abrir biblioteca de prompts
    {
        "<leader>ap",
        function()
            require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick: Seleccionar prompt",
    },

    -- CLI: Atajos directos para herramientas instaladas
    {
        "<leader>ag",
        function()
            require("sidekick.cli").toggle({ name = "gemini", focus = true })
        end,
        desc = "Sidekick: Toggle Gemini",
    },
    {
        "<leader>ao",
        function()
            require("sidekick.cli").toggle({ name = "opencode", focus = true })
        end,
        desc = "Sidekick: Toggle OpenCode",
    },
}

return M
