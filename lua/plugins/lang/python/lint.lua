local lint = require("lint")

lint.linters_by_ft.python = { "ruff" }

lint.linters.ruff.args = {
    "--fix",
    "--no-unsafe-fixes",
}
