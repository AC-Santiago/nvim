local conform = require("conform")

conform.formatters_by_ft.markdown = { "dprint" }

conform.formatters.dprint = {
    command = "dprint",
    args = { "fmt", "--stdin", "$FILENAME" },
    stdin = true,
    require_cwd = true,
    cwd = require("conform.util").root_file({ "dprint.json" }),
}
