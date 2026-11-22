return {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "LanguageToolsInstall" },
    opts = function()
        dofile(vim.g.base46_cache .. "mason")

        return {
            PATH = "skip",

            ui = {
                icons = {
                    package_pending = " ",
                    package_installed = " ",
                    package_uninstalled = " ",
                },
            },

            max_concurrent_installers = 10,
        }
    end,
    config = function(_, opts)
        require("mason").setup(opts)
        vim.api.nvim_create_user_command("LanguageToolsInstall", function()
            local tools = require("utils.language_tools")
            local workspace = tools.workspace()
            local function report_results(report)
                require("utils.lang_loader").refresh_tools()
                local messages = {}
                for _, name in ipairs(vim.fn.sort(vim.tbl_keys(report))) do
                    local result = report[name]
                    local message = result.message and (". " .. result.message) or ""
                    messages[#messages + 1] = ("%s: %s%s"):format(name, result.status, message)
                end
                if #messages == 0 then
                    messages[1] = "No language tools need installation."
                end
                vim.notify(table.concat(messages, "\n"), vim.log.levels.INFO)
            end

            local installer = require("utils.language_install")
            local started = installer.run(workspace, function(report)
                if vim.fn.has("win32") == 1 then
                    local typstyle = vim.iter(require("utils.language_registry").inventory()):find(function(record)
                        return record.enabled and record.role == "format" and record.id == "typstyle"
                    end)
                    if typstyle then
                        require("plugins.lang.typst.conform").probe(typstyle, workspace, true, function(path, message)
                            if not path then
                                report[installer.report_key(typstyle)] = {
                                    status = "external",
                                    message = (message or "Typstyle unavailable") .. ". Use the official Windows x64 Typstyle executable.",
                                }
                            end
                            report_results(report)
                        end)
                        return
                    end
                end
                report_results(report)
            end)
            if not started then
                vim.notify("Language tool installation is already running.", vim.log.levels.INFO)
            end
        end, { desc = "Install missing tools for enabled language profiles" })
    end,
}
