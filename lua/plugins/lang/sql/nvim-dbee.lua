return {
    "kndndrj/nvim-dbee",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    build = function()
        require("dbee").install()
    end,
    cmd = { "Dbee" },
    keys = {
        {
            "<leader>db",
            function()
                require("dbee").toggle()
            end,
            desc = "Toggle DBee",
        },
        {
            "<leader>do",
            function()
                require("dbee").open()
            end,
            desc = "Abrir DBee",
        },
        {
            "<leader>dc",
            function()
                require("dbee").close()
            end,
            desc = "Cerrar DBee",
        },
        {
            "<leader>de",
            function()
                require("dbee").execute(vim.fn.input("Query: "))
            end,
            desc = "Ejecutar Query",
        },
        {
            "<leader>dn",
            function()
                require("dbee").api.ui.result_page_next()
            end,
            desc = "DBee: Página siguiente",
        },
        {
            "<leader>dp",
            function()
                require("dbee").api.ui.result_page_prev()
            end,
            desc = "DBee: Página anterior",
        },
        {
            "<leader>df",
            function()
                require("dbee").api.ui.result_page_first()
            end,
            desc = "DBee: Primera página",
        },
        {
            "<leader>dl",
            function()
                require("dbee").api.ui.result_page_last()
            end,
            desc = "DBee: Última página",
        },
    },
    config = function()
        require("dbee").setup({
            sources = {
                require("dbee.sources").MemorySource:new({
                    {
                        name = "MCP-Requerimientos DB",
                        type = "postgres",
                        url = "[URL DE CONEXIÓN A LA BASE DE DATOS]",
                    },
                }),
            },
        })
    end,
}
