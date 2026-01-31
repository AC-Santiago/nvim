require("nvchad.options")

local o = vim.o
local g = vim.g

-- Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- o.cursorlineopt ='both' -- to enable cursorline!

-- set filetype for .CBL COBOL files.
-- vim.cmd([[ au BufRead,BufNewFile *.CBL set filetype=cobol ]])

o.relativenumber = true
o.termguicolors = true
-- Database options

if pcall(require, "vim_dadbod_completion") then
    g.dbs = {
        {
            name = "Oracle SQL HR DB",
            url = function()
                local url_oracle_sql_db = os.getenv("ORACLE_CURSO_SQL_DB_HR_URL")
                    or "[URL DE CONEXIÓN A LA BASE DE DATOS]"
                return url_oracle_sql_db
            end,
        },
    }
end
