local conform = require("conform")

conform.formatters_by_ft.typst = { "typstyle" }

conform.formatters.typstyle = {
    command = "typstyle",
    args = { "-i", "$FILENAME" },
    stdin = false,
}
