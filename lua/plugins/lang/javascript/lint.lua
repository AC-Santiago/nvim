local lint = require("lint")

-- Configurar oxlint para JavaScript y TypeScript
lint.linters_by_ft.javascript = { "oxlint" }
lint.linters_by_ft.javascriptreact = { "oxlint" }
lint.linters_by_ft.typescript = { "oxlint" }
lint.linters_by_ft.typescriptreact = { "oxlint" }

-- Configuración personalizada de oxlint
lint.linters.oxlint = {
    cmd = "oxlint",
    stdin = false,
    args = {
        "--format",
        "json", -- Formato JSON para parsing más fácil
        "--quiet", -- Solo mostrar errores y warnings
    },
    stream = "stdout",
    ignore_exitcode = true,
    parser = function(output, _)
        local ok, decoded = pcall(vim.json.decode, output)
        if not ok or not decoded or not decoded.diagnostics then
            return {}
        end

        local diagnostics = {}
        for _, diagnostic in ipairs(decoded.diagnostics) do
            if diagnostic.severity and diagnostic.labels and #diagnostic.labels > 0 then
                local severity = vim.diagnostic.severity.ERROR
                if diagnostic.severity == "warning" then
                    severity = vim.diagnostic.severity.WARN
                elseif diagnostic.severity == "info" then
                    severity = vim.diagnostic.severity.INFO
                elseif diagnostic.severity == "hint" then
                    severity = vim.diagnostic.severity.HINT
                end

                local label = diagnostic.labels[1]
                local span = label.span

                table.insert(diagnostics, {
                    lnum = (span.line or 1) - 1,
                    col = (span.column or 1) - 1,
                    end_lnum = (span.line or 1) - 1,
                    end_col = ((span.column or 1) + (span.length or 1)) - 1,
                    severity = severity,
                    message = diagnostic.message or "",
                    source = "oxlint",
                    code = diagnostic.code,
                })
            end
        end
        return diagnostics
    end,
}
