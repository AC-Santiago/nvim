local prompts = {
    Explain = "Please explain how the following code works.",
    Review = "Please review the following code and provide suggestions for improvement.",
    Tests = "Please explain how the selected code works, then generate unit tests for it.",
    Refactor = "Please refactor the following code to improve its clarity and readability.",
    FixCode = "Please fix the following code to make it work as intended.",
    FixError = "Please explain the error in the following text and provide a solution.",
    BetterNamings = "Please provide better names for the following variables and functions.",
    Documentation = "Please provide documentation for the following code.",
    JsDocs = "Please provide JsDocs for the following code.",
    DocumentationForGithub = "Please provide documentation for the following code ready for GitHub using markdown.",
    CreateAPost = "Please provide documentation for the following code to post it in social media, like Linkedin, it has be deep, well explained and easy to understand. Also do it in a fun and engaging way.",
    SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
    SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
    Summarize = "Please summarize the following text.",
    Spelling = "Please correct any grammar and spelling errors in the following text.",
    Wording = "Please improve the grammar and wording of the following text.",
    Concise = "Please rewrite the following text to make it more concise.",
}

return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        keys = {
            { "<leader>cc", "<cmd>CopilotChat<CR>", desc = "Abrir CopilotChat" },
            { "<leader>ce", "<cmd>CopilotChatExplain<CR>", desc = "Explicar código", mode = { "n", "v" } },
            { "<leader>ct", "<cmd>CopilotChatTests<CR>", desc = "Generar pruebas", mode = { "n", "v" } },
            { "<leader>cr", "<cmd>CopilotChatReview<CR>", desc = "Revisar código", mode = { "n", "v" } },
            { "<leader>cf", "<cmd>CopilotChatFixCode<CR>", desc = "Arreglar código", mode = { "n", "v" } },
            { "<leader>cd", "<cmd>CopilotChatDocumentation<CR>", desc = "Generar documentación", mode = { "n", "v" } },
            { "<leader>cb", "<cmd>CopilotChatBetterNamings<CR>", desc = "Mejorar nombres", mode = { "n", "v" } },
            { "<leader>cs", "<cmd>CopilotChatSummarize<CR>", desc = "Resumir texto", mode = { "n", "v" } },
        },
        opts = function()
            local user = vim.env.USER or "User"
            user = user:sub(1, 1):upper() .. user:sub(2)
            return {
                prompts = prompts,
                system_prompt = "Soy un estudiante de ingeniería de sistemas y ciencia de datos. Por favor, proporciona respuestas claras y concisas, enfocándote en buenas prácticas de programación y explicaciones técnicas precisas. Cuando expliques conceptos: \n\n2. Usa ejemplos prácticos en Python o Java cuando sea relevante\n2. Incluye referencias a librerías comunes de ciencia de datos (pandas, numpy, scikit-learn, etc.) cuando sea apropiado\n3. Si la respuesta involucra matemáticas o estadística, proporciona explicaciones intuitivas junto con la teoría\n4. Para documentación extensa, sugiere estructuras en LaTeX\n5. Prioriza métodos modernos y eficientes en tus sugerencias de código\n6. Incluye consideraciones sobre complejidad computacional cuando sea relevante\n7. Sugiere pruebas unitarias cuando sea apropiado\n\nPrefiero explicaciones directas y prácticas con ejemplos concretos.",
                model = "gpt-4o",
                auto_insert_mode = true,
                question_header = "  " .. user .. " ",
                answer_header = "  Copilot ",
                window = {
                    layout = "float",
                },
            }
        end,
        config = function(_, opts)
            local chat = require("CopilotChat")
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "copilot-chat",
                callback = function()
                    vim.opt_local.relativenumber = false
                    vim.opt_local.number = false
                end,
            })
            chat.setup(opts)
        end,
    },
}
