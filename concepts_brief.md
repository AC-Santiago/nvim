# Modernize Neovim for native Windows and make languages easier to add

- **Author** — AC-Santiago
- **Date** — 2026-11-21
- **Status** — Goldfish review complete. The author approved the first-release scope and Windows x64 as the initial Windows target.

## Overview

Keep NvChad as the base and use the same repository on Linux and native Windows. The first release makes Markdown, Python, and Typst usable on Windows without WSL. It also makes a language declaration sufficient to connect supported language servers, formatters, and linters to the editor. Go is the extension test.

## Analysis

- **Windows startup comes first.** Python discovery constructs paths ending in `bin/python` and stops walking parents only at `/`. The Windows path and stop condition need to work at a drive root, with spaces in the project path, and with or without a virtual environment. An environment or tool that is still being installed must leave the rest of the editor usable. Use the real configuration directory for file-opening commands. Check plugin build prerequisites and Tree-sitter installation before opening the first buffer. The supported Neovim version must reflect the tested plugin revisions. [Python discovery](./init.lua#L44) · [File-opening mappings](./lua/mappings.lua#L89) · [Tree-sitter setup](./lua/configs/treesitter.lua#L59) · [Requirements of the locked Tree-sitter revision](https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/04f17886f75416dfdc25374c950a52c63f0e98fe/README.md#requirements) · [Windows virtual environments](https://docs.python.org/3/library/venv.html#creating-virtual-environments)
- **A tool needs to be installed, executable, and active.** Today the language inventory, per-language imports, and editor registration are separate. Use the language declaration to decide what runs. Reuse Mason where the package works, and allow an executable already available to Neovim. Validate the actual command and show a recovery step if it fails. The inspected Typstyle recipe pairs `win_x64` with an ARM64 executable. Verify the package on the target machine and keep the upstream x64 binary as a fallback. [Language inventory](./lua/configs/languages.lua) · [Imports](./lua/plugins/init.lua#L44) · [Typstyle recipe](https://raw.githubusercontent.com/mason-org/mason-registry/main/packages/typstyle/package.yaml) · [Official Typstyle binaries](https://github.com/typstyle-rs/typstyle/releases/expanded_assets/v0.15.2)
- **Visible output can hide a broken tool.** Python gets diagnostics through LSP as well as lint. The current lint customization replaces Ruff's argument list, including the output settings its parser expects. Conform also supports LSP fallback. Use separate checks for LSP, lint, and format and record which tool produced each result. [Python lint](./lua/plugins/lang/python/lint.lua#L3) · [Format on save](./lua/configs/conform.lua#L6)
- **Optional integrations must let the editor start.** Keep the basic editing and terminal workflow available without tmux. Sidekick currently selects tmux explicitly. Use its existing editor terminal when helpful, and treat herdr as the external environment the user already uses. Keep optional image rendering, AI authentication, and preview dependencies out of the required first-run path. [Sidekick configuration](./lua/plugins/sidekick.lua#L31) · [Image plugin](./lua/plugins/image-nvim.lua#L1)

## Goals vs. Non-Goals

### First release

| Acceptance area | Check |
| --- | --- |
| Native Windows | Starting from a clean Neovim profile and the documented native prerequisites, open and save files and start a terminal from PowerShell without WSL or tmux. Use the same candidate lockfile for Windows and Linux. Repeat with a project path containing spaces. Test startup without a Python environment and Python discovery with `Scripts/python.exe`. |
| Markdown | Open a small notes workspace, verify that `markdown_oxide` connects, and navigate a link between two notes. |
| Python | Open a small project, verify an attached Python language server, format a file with Ruff, and see a diagnostic from the separate Ruff lint integration. Run the lint check on an unformatted fixture so Ruff formatting cannot remove the test issue first. |
| Typst | Open a Typst document, verify that `tinymist` connects, and format a file using Typstyle. |
| Linux | Repeat the three language workflows with the existing Linux configuration choices. Check that an existing installation keeps its shared tools and parsers through the update and that the new provisioning step can safely be run again. |
| Add Go | Add one Go entry to the language registry, use the documented Go toolchain prerequisite and provision the declared tools. Verify `gopls` attachment and `gofmt` output. Change one tool setting in the same entry and observe its effect. This requires no changes to the loader or to the plugin specs. Exercise the example on both platforms as an opt-in test. Disable the entry, restart, and verify that the server stays inactive even if its package remains installed. |

### Later work

Windows coverage for HTML, CSS, JavaScript, and Rust can follow the three required workflows. DAP, Typst browser preview, optional integrations, and a dedicated herdr backend are separate follow-ups. Existing Linux features remain in place unless a specific compatibility change requires its own decision.

## Alternatives Weighed

- **Patch Windows paths only.** This gets to the first boot faster. It leaves tool installation and editor setup spread across multiple files, so it works as the first milestone.
- **Keep a Windows-specific configuration.** Separate files simplify some platform work initially. They duplicate behavior and require synchronizing every later fix. Use targeted platform conditions inside the shared configuration.
- **Build a new universal plugin layer.** It could standardize arbitrary tools, at the cost of maintaining a second interface for Neovim LSP, Conform, and nvim-lint. Extend the existing inventory and accept the native settings of each tool for advanced cases.
- **Use Tinymist for Typstyle formatting.** This could avoid a separate executable. Start by validating the current Conform workflow with a native Typstyle binary. Consider Tinymist formatting if the separate binary complicates setup on Windows. [Typstyle installation and usage](https://github.com/typstyle-rs/typstyle#installation-and-usage)
- **Update all plugin pins together.** This changes the baseline while testing platform and language behavior. Audit the existing pins, update related plugins in small groups, and rerun their checks before moving on.

## Key Decisions & Staging for Next Steps

1. **Establish the baseline.** Start with the existing lockfile and record the Neovim and plugin revisions tested. Use Windows x64 and PowerShell as the proposed first Windows target. Confirm the target architecture and supported Neovim version before implementation. A native host or runner is needed for acceptance. Record which tools the user installs and which the configuration provisions. Keep a copy of the working Linux setup and lockfile for comparison and rollback.
2. **Modernize the required path.** Fix confirmed startup and tool configuration problems on the existing stack. Check plugin options against the pinned source and upstream changelogs. Validate fresh installation, parser readiness, and optional plugin behavior before broader plugin updates. Document the first run, how to see when provisioning is complete, and how to retry a failed tool installation. Missing optional tools must leave editing available.
3. **Extend the language registry.** Declare filetypes, editor tool identifiers and, when needed, packages and native overrides. Define the order of defaults and overrides and report missing executables with the tool name and the next step. Reuse Neovim's LSP API, Conform, and nvim-lint. Keep installation separate from activation so compatible external binaries also work. Preserve installed tools during migration and treat cleanup of shared tools as its own decision.
4. **Prove and record the result.** Run the Windows and Linux acceptance checks. Use Go to prove the one-entry path and an override. Update the README and EGM contracts with the tested versions, prerequisites, and verification steps.
