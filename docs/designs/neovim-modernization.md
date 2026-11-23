# Neovim modernization for native Windows and Linux

- **Author** — AC-Santiago
- **Status** — Proposed
- **Date** — 2026-11-21
- **EGM review** — Stage 9 complete on 2026-11-22. Runtime acceptance pending.

## Overview

Use one Neovim configuration with NvChad on native Windows x64 and Linux. The first release makes Markdown, Python, and Typst usable from a clean Windows installation and preserves those workflows on Linux. Adding a language should take one declaration for its supported tools, with room for tool-specific settings. [Approved concept brief](../../concepts_brief.md)

## The Problem

The current configuration records which tools belong to a language, while plugin imports and per-language modules decide which tools actually run. Adding a language requires changes in several places, and successful installation alone does not show whether a tool can launch or attach to a buffer. [Language inventory](../../lua/configs/languages.lua) · [Plugin imports](../../lua/plugins/init.lua#L44)

Several paths and plugin settings assume a Linux environment. Python discovery uses POSIX virtual environment paths and a POSIX root condition. Sidekick selects tmux explicitly, although the author now uses herdr. These assumptions can affect startup or workflows on an otherwise valid native Windows installation. [Python discovery](../../init.lua#L44) · [Sidekick configuration](../../lua/plugins/sidekick.lua#L31)

## Goals

- **Native Windows startup.** Using the documented prerequisites and a clean Neovim profile, launch Neovim from PowerShell on Windows x64, open and save a file, and start an editor terminal without WSL or tmux. Prepare missing language tools with one explicit command. Repeat from a project path containing spaces. Confirm startup without a Python virtual environment and interpreter discovery with a native virtual environment.
- **Markdown.** Open a small notes workspace, verify that `markdown_oxide` attaches, and follow a link to another note.
- **Python.** Verify that a Python LSP client attaches in a project, Ruff formats a file, and the separate lint integration reports an intentional error in another fixture. Capture the formatter and diagnostic source so LSP fallback cannot mask a failed check.
- **Typst.** Verify that Tinymist attaches to a Typst document and that Typstyle changes a deliberately unformatted fixture. Confirm that the selected executable runs on native Windows x64.
- **Lua.** Verify Lua LS attaches on the first Lua buffer and follows a definition across files in a project path with spaces. A project `.luarc.json` or `.luarc.jsonc` takes precedence over an ancestor config with the other extension. Verify StyLua formatting.
- **Linux compatibility.** Repeat the required language checks with the same candidate lockfile. Verify that an existing Linux profile retains its language choices and installed tools shared by enabled languages.
- **Language extension.** Add Go through a single declaration. Verify `gopls` attachment, `gofmt` output, and one tool-specific setting on Windows and Linux. After disabling Go and restarting, verify that `gopls` stays inactive even if it remains installed.
- **Plugin modernization and recovery.** Fix obsolete options and compatibility issues that affect these workflows. Document the tested versions and native prerequisites. Verify that a failed tool installation identifies the tool and a recovery step, leaves editing available, and can be retried.

## Non-Goals

- NvChad replacement or a separate configuration repository for Windows.
- Windows coverage for HTML, CSS, JavaScript, and Rust in the first release. Existing Linux language choices are part of the compatibility check.
- SQL server compatibility as a release gate. The optional SQL profile and the documented recovery remain available.
- DAP, Typst browser preview, optional image and AI integrations, or a dedicated herdr backend as acceptance requirements for the first release. Basic edit, save, and terminal operations must work without tmux.
- An update of every plugin pin in one batch. Plugin changes are grouped by the workflows they affect.

## Critical User Journeys (CUJs)

### First use on native Windows

- **Given** a clean Neovim profile on Windows x64, the documented native prerequisites, and a project path that may contain spaces.
- **When** the user starts Neovim from PowerShell, opens and saves a file, and starts an editor terminal before running `:LanguageToolsInstall`.
- **Then** the editor can open, save, and launch a terminal without WSL or tmux. The command reports found commands, verified launches where a probe is required, missing native prerequisites, and failed installs in Neovim messages. The user can reopen them with `:messages`. If all package requirements are met, it reports that no packages need installation. Markdown, Python, and Typst pass their named tool checks after provisioning completes.

### Add or disable a language

- **Given** an installation with the required language profiles working and a Go toolchain available.
- **When** the user adds a Go declaration, restarts Neovim, and runs `:LanguageToolsInstall` if any tools are missing.
- **Then** the same path used for the other languages resolves `gopls` and `gofmt`, applies the declared override, and makes the tools available in Go buffers. Disabling Go and restarting removes activation while leaving the binaries available on disk.

## Technical Plan (Architecture)

### One registry and existing adapters

Extend `lua/configs/languages.lua` as the source of enabled languages and their tools. Each declaration identifies its filetypes and lists the LSP servers, formatters, and linters it needs. An entry can name a known tool by its editor integration ID. When the tool's package name or command differs, declare that mapping separately. Merge integration defaults, profile settings, and explicit tool options in that order, then bind the vetted launch command. Keep formatter order within each filetype. [Language inventory](../../lua/configs/languages.lua)

The registry normalizes declarations on demand and exposes the enabled tools to the existing LSP, Conform, and nvim-lint configuration modules. Mason install requests are deduplicated by package ID. For example, Ruff can serve several roles from one installation. Markdown, Python, Typst, base tools such as Lua LS, and enabled legacy profiles use the same explicit provisioning path. Legacy settings modules supply integration options. The existing LSP setup owns activation of Neovim-managed servers. Plugin-owned servers, such as the Rust server managed by Rustaceanvim, keep their existing owner. Add Go through the registry and verify that the loader and plugin specs need no Go-specific change. [Language loader](../../lua/utils/lang_loader.lua) · [LSP](../../lua/configs/lsp.lua) · [Conform](../../lua/configs/conform.lua) · [Lint](../../lua/configs/lint.lua)

```text
Enabled languages + base tools
            |
            v
  Resolve commands and check availability
       |                             |
       |                          Commands missing
       v                             |
 LSP, Conform, nvim-lint             v
 apply buffer conditions    :LanguageToolsInstall only
                                     |
                           Recheck before installation
                          /                            \
               Usable now or external          Missing supported package
                 prerequisite found                       |
                                                         v
                                                    Mason install
                                                         |
                                             Recheck the selected command
                                                         |
                                           Available to the existing adapters
```

#### Example registry entry

The Go profile is opt-in and covers the `go` filetype. It illustrates which values come from the editor integrations, Mason, and the system.

| Role | Integration ID | Install source | Runtime command and native options |
| --- | --- | --- | --- |
| Language server | `gopls` | Mason package `gopls` when the command is missing | Use the server definition's `gopls` command. In this entry, set `settings.gopls.hints.assignVariableTypes` to `true` to enable variable type hints. |
| Formatter | `gofmt` | External Go toolchain | Use Conform's `gofmt` command. Set an explicit executable path only if the one on PATH should be overridden. |
| Linter | None in the Go example | None | Python supplies the separate linter acceptance check. |

The Go declaration can omit an explicit command when the integration already defines it. An external tool leaves the Mason package field empty. For Python, the declared Conform order is `ruff_fix`, `ruff_format`, then `ruff_organize_imports`. These three formatter IDs, the Ruff linter, and the Ruff server share the same Mason package.

### Provisioning, readiness, and activation

Keep provisioning and activation separate. Provisioning obtains declared tools from Mason where the platform package works. An external executable can satisfy a declaration if Neovim can resolve and run it. A tool with an unsupported package or failed launch gets an actionable message with its name, the failing step, and the recovery path. At startup, resolve an explicit absolute executable override from the user's Neovim configuration first. Otherwise resolve the integration's command through Neovim's effective PATH. The pinned NvChad revision adds the profile's Mason bin directory to PATH during startup. Mason leaves that PATH in place. On Windows, resolve supported wrappers using the installed receipt schema. Windows Typstyle uses the external x64 executable. Readiness uses local metadata. Only the explicit command refreshes the registry in the new language-tool workflow. Linux DAP and user-initiated Mason commands retain their separate behavior.

A resolved executable has been found and is eligible for use. That result is distinct from a verified launch. On Windows x64, run one asynchronous, noninteractive `--version` probe with a five-second timeout for each selected Typstyle path after checking it against the requesting workspace. Use the same verified absolute path in Conform. Each adapter evaluates its buffer conditions and workspace root. If an unprobed command fails on first use, its adapter reports the failing executable and a recovery step. [LSP integration](../../lua/utils/language_lsp.lua) · [Typstyle integration](../../lua/plugins/lang/typst/conform.lua)

Enable language servers from the declarations rather than from the set of packages already installed. Once ready, a server becomes eligible to attach to matching buffers. Formatter and linter registration follows the same enabled filetypes. Disabling a language and restarting stops its registrations. Keep existing packages and parsers on disk during migration. Preserve shared tools used by other enabled languages. [LSP configuration](../../lua/configs/lsp.lua) · [Cleanup entry point](../../lua/utils/lang_loader.lua) · [Parser cleanup](../../lua/configs/treesitter.lua#L39)

#### User-initiated installation

`:LanguageToolsInstall` reads the enabled declarations and requests installation of the missing packages that Mason supports on the current platform. It reuses usable executables and skips packages already installed or in progress. The command leaves the editor responsive while installations run, reports each failure with a recovery step, and can be run again to retry. If the tool requires an external installation, the command reports the native prerequisite and rechecks it on the next run. If a package is marked installed and its command probe fails, report the failing path and leave the package in place. Repair or reinstall that package in Mason, or set the registry entry to the absolute path of a verified native executable. If a broken Typstyle shim comes first on PATH, use the explicit path override even when the external executable is already on PATH. If the registry entry changes, restart Neovim before running `:LanguageToolsInstall` again. After a repair at the same path, running the command again rechecks any previous probe failure without requiring a restart.

Startup resolves and activates tools that are already usable. Opening a buffer or changing the registry does not trigger language-tool downloads. Remove or disable overlapping automatic provisioning for the migrated tools so the command is the single installation entry point for those packages. After installation, refresh the loaded adapters. Adapters loaded later resolve each tool from the current inventory and local executable state. A reopened or newly opened buffer can use a successful installation without restarting Neovim. Report the outcome and recovery actions in Neovim messages. When the install requirements are satisfied, report that no packages need installation. Keep any missing external prerequisite or failed launch visible as a separate outcome. Plugin and parser setup retain their own documented steps. Disabling a language does not uninstall anything.

#### Manual cleanup and its snapshot

`nvim_language_state.json` in Neovim's data directory records which languages were enabled in the previous cleanup baseline, along with the time and Neovim version. Seed it during baseline initialization only when absent, with no removal. A valid empty snapshot supplies no candidates. An unreadable or invalid snapshot blocks removal and reports how to recover it. Run `:lua require("utils.lang_loader").manual_cleanup()` to compare the baseline with the current registry and list unique removable packages. If a previous profile is no longer declared, report its name and leave its packages installed. Require affirmative confirmation for every nonempty set and default to keeping the packages. Protect packages still used by an enabled profile. After accepting the current enabled set as the new baseline, run `:lua require("utils.lang_loader").update_language_state()`, which writes the snapshot without removing packages. Startup and saves leave installed tools in place.

### Native startup and migration

- Use Neovim's platform paths and native process invocation for file-opening commands and Python discovery. Detect the Windows virtual environment executable and stop the parent search when it reaches a root that has no new parent. Verify both POSIX and Windows discovery using project paths with spaces. [Startup](../../init.lua#L44) · [Mappings](../../lua/mappings.lua#L89)
- Review plugin options against the versions under test. Start with the installation and first-buffer behavior of Tree-sitter, Python lint arguments, and tools whose setup expects a terminal, credentials, or a build utility. Keep parser setup from blocking editing when a parser is missing and report how to prepare it. [Tree-sitter](../../lua/configs/treesitter.lua) · [Ruff](../../lua/plugins/lang/python/lint.lua) · [Image integration](../../lua/plugins/image-nvim.lua)
- Use Neovim's terminal for the basic workflow. Replace the forced tmux dependency in the applicable Sidekick path with its supported editor terminal where Sidekick is available. herdr remains an external way to run Neovim. [Sidekick](../../lua/plugins/sidekick.lua#L31)
- Use the baseline pins for the startup changes, then introduce the registry changes and narrowly scoped plugin updates. Run the same candidate lockfile on both platforms. Native Windows 11 acceptance is the final step. Use a fresh profile when repeating the bootstrap checks. Keep the working Linux configuration and tool data available for rollback. Check that retrying setup or disabling a profile preserves shared tools. [Lockfile](../../lazy-lock.json) · [Approved concept brief](../../concepts_brief.md)

## Alternatives Considered

### Fix Windows paths as the entire release

- **Benefit.** A small change can make Python discovery and file-opening mappings work on Windows early.
- **Trade-off.** Adding a language would still require changes across the inventory, plugin imports, and tool configurations.
- **Disposition.** Keep the path fixes as the first milestone. The release also needs the single-declaration Go check.

### Maintain a separate Windows configuration

- **Benefit.** Windows-specific defaults could be adjusted in isolation.
- **Trade-off.** Shared language behavior, plugin settings, and fixes would need to be kept in sync across two configurations.
- **Disposition.** Use one NvChad configuration with targeted platform checks. Validate the same candidate lockfile on both systems.

### Create a universal plugin layer

- **Benefit.** One API could cover tools beyond the current LSP, formatting, and lint integrations.
- **Trade-off.** The new layer would duplicate plugin settings and need to keep up with changes in each integration.
- **Disposition.** Extend the existing registry and use the native tool settings for overrides. Go is the test for whether that smaller design is sufficient.

### Install tools automatically in the background

- **Benefit.** A newly enabled language begins provisioning as soon as Neovim starts.
- **Trade-off.** Startup can trigger downloads on a slow or offline connection. The first buffer can open before its tools are ready.
- **Disposition.** The author chose `:LanguageToolsInstall`. It installs missing tools in one action, gives the user control over when downloads happen, and can be run again after a failure.

### Format Typst through Tinymist

- **Benefit.** Tinymist can use Typstyle formatting without a separate Typstyle executable.
- **Trade-off.** Formatting would depend on the language server being attached and would use a different integration from the current Conform setup.
- **Disposition.** Validate the official standalone x64 Typstyle executable with Conform on Windows and the Mason package on Linux. Revisit Tinymist formatting if the official x64 executable fails the Windows launch or formatting checks. [Typstyle integration options](https://github.com/typstyle-rs/typstyle#installation-and-usage)

### Update every plugin pin together

- **Benefit.** A single update reaches a newer plugin baseline sooner.
- **Trade-off.** Simultaneous API changes make failures harder to trace during the Windows and language migrations.
- **Disposition.** Audit compatibility against the current lockfile. Change pins in groups tied to a workflow and verify each group on the supported platforms. [Current lockfile](../../lazy-lock.json)

## Non-Functional Requirements

- **Startup and responsiveness.** A clean editor can open and save files before language tools or parsers are ready. Startup performs no LSP, formatter, or linter package downloads. `:LanguageToolsInstall` runs its network and install work asynchronously.
- **Executable sources.** Use integration defaults, the effective PATH, and executable overrides in the user's Neovim configuration. Workspace files cannot supply registry overrides. Reject an implicitly resolved project-local executable rather than running it as a language tool. Allow a deliberate absolute override in the user's configuration. Pass executable paths and arguments separately without shell interpolation.
- **Work limits and repeatability.** Startup normally checks executable paths. The exceptional Typstyle launch probe runs asynchronously, has a timeout, and is reused within the same session while the resolved path remains unchanged. The install command rechecks it after a relevant install or executable change and invalidates previous failed probes when explicitly retried. Keep Mason's existing per-session concurrency limit of 10 installers. Within one Neovim process, deduplicate by package and reuse in-flight work. A later run retries failed packages and keeps successful installs. Cross-process coordination remains with Mason.
- **Compatibility and rollback.** Test the same candidate lockfile on Windows x64 and Linux. Use disposable profiles and a copy of existing Linux data for upgrade tests. Restore the previous configuration, lockfile, and the same profile's saved Mason packages and shims, Tree-sitter parsers, and language state snapshot together. Restore the prior plugin checkouts, including lazy.nvim, with those files. Compare the restored behavior against the measured pre-change baseline.

## Detailed Implementation Plan

### Sequence and exit checks

1. **Baseline and native startup.** Record the untouched Linux workflows, lockfile, actual plugin checkouts, and tool data before making changes. Then fix bootstrap, terminals, paths, parsers, and optional Windows plugin loads. Record the post-fix startup checks separately. Leave lint registration and installer ownership in place for this checkpoint.
2. **Prepare the replacement path in an isolated profile.** Define the registry, resolver, installer, and consumer interfaces. Test Markdown, Python, Typst, Lua LS, StyLua, and the legacy web, JavaScript, Rust, and Linux DAP workflows named in the parity checks using that isolated candidate with the old adapters disabled. The regular profile continues to use its existing registrations and adapters during preparation.
3. **Cut over in one change.** Enable new ownership with the required declarations and adapter consumers. Remove the old automatic installation adapters, duplicate registrations, and their lock entries in the same change. Move lint readiness gating into this change. The cutover passes when the parity checks succeed with missing tools, already installed tools, and the legacy modules enabled. Then enable Go in the test profile and show that adding its declaration alone is enough.
4. **Verify and document.** Run the Windows and Linux acceptance checks, the copied Linux upgrade, and the rollback. Publish the tested prerequisites and the tool setup and recovery instructions.

### Registry and adapter contract

Use the existing language enable flags and `configs` table in `lua/configs/languages.lua`. Defaults come from OS detection. A clean Windows x64 profile enables Markdown, Python, and Typst. Rust and the web profiles are opt-in there. Linux retains its existing defaults. Preserve explicit user enable flags in both environments, including while migrating existing Linux data.

A migrated profile adds `filetypes`, `lsp`, `format`, and `lint` lists to its configuration. Each tool record has a required native integration `id`, an optional Mason `package` ID, a `bin` executable lookup name for Mason and external tools, an optional absolute `executable` override, and optional integration-native `options`. An omitted package identifies a tool installed by the user or its language toolchain. The bin defaults to the first command name from the integration when it is static. A tool with a dynamic native command declares the bin explicitly. Preserve legacy fields and functions for profiles and DAP that have yet to migrate. When the new and legacy fields coexist, the migrated lists are authoritative for that role. Installation policy can exclude a package on a platform even if its identity is known.

An optional per-tool `filetypes` list replaces profile defaults for that role. VTSLS and Oxlint cover JavaScript, TypeScript and their React variants. Prettier also covers JSON and JSONC. The HTML server covers HTML, and the HTML formatter also covers XHTML. CSS, SCSS and Less keep their native assignments. Preserve roots and formatter conditions.

The loader normalizes tools for all known profiles, including disabled ones. Keep a full inventory keyed by profile, filetype and role for cleanup. Activation and installation use base tools plus the enabled projection. Resolve paths only for that projection. Keep native ID, package, bin, and options in the inventory and bind the selected path in each adapter. Process profiles deterministically and keep the declared formatter order. Deduplicate only the installer requests by package ID. Resolve integration defaults, merge the profile's native settings from its existing trusted modules, then merge explicit native options. Bind the authoritative launch command last. Replace complete argument lists when overridden. Preserve root and filetype conditions. Keep formatter options scoped to their profiles when a shared executable, such as Prettier, needs different settings. A native LSP ID has one effective configuration and one activation owner. Report conflicting overrides for that ID instead of choosing one silently.

Go example, shown as declaration pseudocode:

```text
enable flag: go = false
configs.go:
  filetypes: [go]
  lsp: [{ id: gopls, package: gopls, bin: gopls,
          options: { root_markers: [go.work, go.mod, .git],
                     settings: { gopls: { hints: { assignVariableTypes: true } } } } }]
  format: [{ id: gofmt, bin: gofmt }]
  lint: []
```

| Profile | Integration IDs | Package and command mapping | Owner |
| --- | --- | --- | --- |
| Base | `lua_ls`, `stylua`, `luacheck` | Mason `lua-language-server` and `stylua`, with matching commands. External `luacheck`, excluded from Mason installation. | Neovim LSP, Conform, nvim-lint on Linux. |
| Markdown | `markdown_oxide`, `dprint` | Mason `markdown-oxide` and `dprint`, with matching commands. | Neovim LSP and Conform. Keep dprint's `dprint.json` root condition. |
| Python | `pyrefly`, `ruff` LSP and lint, `ruff_fix`, `ruff_format`, `ruff_organize_imports` | Mason `pyrefly` and one `ruff` package. Keep the listed formatter order. | Neovim LSP, Conform, and the Python lint route for the platform. |
| Typst | `tinymist`, `typstyle` | Mason `tinymist`. Mason `typstyle` on Linux. Exclude Mason installation on Windows and require the official v0.15.2 asset `typstyle-x86_64-pc-windows-msvc.exe`. The inspected Mason v0.15.3 recipe names an ARM64 asset for `win_x64`. [Official release assets](https://github.com/typstyle-rs/typstyle/releases/expanded_assets/v0.15.2) | Neovim LSP and Conform. |
| Go | `gopls`, `gofmt` | Mason `gopls`. External `gofmt` from the Go toolchain. | Neovim LSP and Conform. |
| Legacy web | `html`, `cssls`, `vtsls`, `prettier`, `oxlint` | Mason packages `html-lsp` and `css-lsp` expose `vscode-html-language-server` and `vscode-css-language-server`. Mason `vtsls`, `prettier`, and `oxlint` expose matching names. | Common LSP activation after legacy settings, Conform, and nvim-lint on Linux. |
| Legacy SQL and Rust | `sqlls`, `sql-formatter`, `rust_analyzer` | Mason `sqlls` exposes `sql-language-server`. Mason `sql-formatter` and `rust-analyzer` expose matching names. | Common LSP activation for SQL, Conform, and Rustaceanvim for Rust. |

### Resolution and runtime behavior

Use an explicit absolute override from the user's configuration first. If it is invalid, report it and leave the tool unavailable. Otherwise take the first match for the bin on Neovim's effective PATH. If that implicit match is workspace-local, stop and report the path. Recovery is to remove the shadowing PATH entry or set an explicit trusted override. No later PATH candidate or adapter-local lookup is used.

Use the selected LSP root for a server launch and the formatter or linter's configured workspace root when available. Explicit LSP root markers replace the stock root callback unless the declaration also supplies its own callback. Otherwise use the nearest applicable marker from the tool settings or `.git`, followed by the named buffer's containing directory. Use Neovim's working directory for an unnamed buffer or a command without a file. Canonicalize roots and paths with symlink resolution, separator normalization, Windows case folding, and directory-boundary checks. Leave the tool unavailable if an implicit path cannot be canonicalized.

Check trust just before dispatch in each LSP, formatter, and linter launch hook and before every Typstyle probe. Startup can resolve a path without launching it. Defer the first Typstyle probe until a Typst buffer or an explicit installation request provides a workspace. A cached probe never bypasses trust checks. Pass the same verified command to the adapter with its native arguments, roots, and conditions.

On Windows, recognize only the expected `<bin>.cmd` basename in this profile's Mason bin directory for a declared package. Guard package lookup and `get_receipt()`, which can fail when JSON is invalid. Unwrap its Optional result and validate the receipt fields before looking up the link. With `get_schema_version()`, choose the exact wrapper basename in `get_links().bin` for schema 2.0 and the bare bin name for schema 1.0. Unsupported schemas, absent or malformed receipts, and missing or non-string links leave the tool unavailable.

Resolve the recorded relative target under `get_install_path()`. Require the canonical target to stay inside the package directory, pass the workspace trust check, and be a native executable `.exe`. Never parse or launch the wrapper. On failure report its path and the repair or native override. Reject a Windows Typstyle wrapper before receipt lookup and direct the user to the external x64 asset, including on retry. The Windows installer never requests the Typstyle package.

Mason can load for local metadata without refreshing the registry. In the new language-tool flow only `:LanguageToolsInstall` refreshes. Linux DAP and user-invoked Mason commands keep their own behavior.

Each adapter reads the eligible records at setup and vets the executable at launch. On installation completion, recheck command availability and refresh the loaded adapters. LSP applies settings before enabling each Neovim-managed server once. Conform and lint re-register the affected filetype entries and vetted commands, preserving buffer conditions. An unloaded adapter uses the updated record when it loads. Rustaceanvim retains its independent Linux server, outside the shared executable policy and the first Windows release.

On Windows, run Ruff lint for Python directly through `vim.system` using the approved absolute `ruff.exe`. Use the pinned Ruff JSON parser and the namespace from `lint.get_namespace("ruff")`. Preserve `check`, `--force-exclude`, `--quiet`, `--stdin-filename`, `--no-fix`, `--output-format json`, and stdin input. Capture the buffer, filename, and project directory before launching. Accept exit codes 0 and 1 with a JSON array containing the code, message, and numeric start and end locations required by the parser. Validate the array and entries and guard the shared parser call. Schedule publication on Neovim’s main loop and confirm the buffer is valid, the filename and change tick match, and the request generation is current. Launch errors, malformed output, and parser failures leave the last valid diagnostics and report the error. A valid empty array clears them. The native runner owns Ruff lint for that Windows buffer. Do not call the shell-wrapped nvim-lint runner for the same event. Linux uses nvim-lint with its native Ruff arguments.

### Target Files to Create, Modify, or Remove

| Phase | Operation | Files | Change and reason |
| --- | --- | --- | --- |
| Startup | Modify | [init.lua](../../init.lua) | Clone lazy.nvim into a temporary sibling owned by the bootstrap. Promote it only after Git succeeds and `lua/lazy/init.lua` exists. If the configured destination exists without a valid entry point, show the path and recovery instructions. Leave unknown data in place. Discover Python through `VIRTUAL_ENV`, then `.venv`, `venv`, and `.virtualenv` by name across the current directory and its parents, then system Python. Use `Scripts/python.exe` on Windows and `bin/python` on Linux. Stop at an absent or unchanged parent, including drive and share roots. Leave the provider path unset if no interpreter is found and make `:PythonPath` report that safely. |
| Startup | Modify | [lua/mappings.lua](../../lua/mappings.lua) | Preserve both Telescope `<C-y>` actions for a typed module name. Resolve it under the picker directory, append `.lua` as the existing actions do, and pass the path as one structured `:edit` argument with `magic = { file = false, bar = false }`. |
| Startup | Modify | [lua/plugins/sidekick.lua](../../lua/plugins/sidekick.lua), [lua/plugins/image-nvim.lua](../../lua/plugins/image-nvim.lua), [lua/plugins/copilot.lua](../../lua/plugins/copilot.lua), [lua/plugins/copilot-chat.lua](../../lua/plugins/copilot-chat.lua), [lua/plugins/lang/typst/typst-preview.lua](../../lua/plugins/lang/typst/typst-preview.lua) | Remove Sidekick's forced tmux backend. Keep its optional editor terminal on Linux. Disable Sidekick and Copilot completion in the first Windows release. Keep Copilot Chat's commands and model picker, and skip its optional tokenizer build on Windows if the compiler or build utility is absent. Remove Copilot build-time authentication. Skip image rendering and browser preview on Windows. Preserve existing Linux image and preview settings. |
| Startup | Modify | [lua/plugins/blink-cmp.lua](../../lua/plugins/blink-cmp.lua) | Omit Copilot completion and `cmp-dap` dependencies, providers, and source selections on Windows. Apply the selection wherever the providers or sources are registered, including DAP prompts. Preserve the Linux configuration. |
| Startup | Modify | [lua/plugins/init.lua](../../lua/plugins/init.lua), [lua/plugins/nvim-dap.lua](../../lua/plugins/nvim-dap.lua), [lua/plugins/lang/python/dap.lua](../../lua/plugins/lang/python/dap.lua) | Disable Mason DAP, shared DAP, and the Python DAP adapter in the first Windows release before testing the startup checkpoint. Preserve Linux debugging and its separate provisioning. |
| Startup | Modify | [lua/plugins/nvim-treesitter.lua](../../lua/plugins/nvim-treesitter.lua), [lua/configs/treesitter.lua](../../lua/configs/treesitter.lua) | Use the pinned revision with Neovim 0.12 or later, a standalone Tree-sitter CLI 0.26.1 or later, tar, curl, and a native C compiler on PATH. Record the tested versions. Set eager loading, clear inherited lazy buffer events and obsolete lazy command triggers, and use `:TSUpdate` as the build hook. Prepare a deduplicated parser list and document `:TSInstall` for missing parsers. Omitted parser declarations are valid, including Go. Remove automatic parser uninstall. Guard buffer startup so folding and indentation are enabled only when the parser is present. |
| Startup | Modify | [lua/autocmds.lua](../../lua/autocmds.lua), [after/ftplugin/markdown.lua](../../after/ftplugin/markdown.lua), [after/ftplugin/python.lua](../../after/ftplugin/python.lua), [after/ftplugin/typst.lua](../../after/ftplugin/typst.lua), [after/ftplugin/rust.lua](../../after/ftplugin/rust.lua) | Use the existing Tree-sitter configuration as the shared guarded startup path. Preserve buffer-specific settings and Rust mappings. Keep the current lint dispatch until the cutover. |
| Cutover | Modify | [lua/configs/languages.lua](../../lua/configs/languages.lua), [lua/utils/lang_loader.lua](../../lua/utils/lang_loader.lua) | Add the registry fields and mappings above. Keep existing Linux enable choices and legacy fields. Normalize tool descriptors on demand, select canonical executable paths, and refresh loaded adapters after installation. Remove startup and save-triggered tool removals. |
| Cutover | Modify | [lua/plugins/mason.lua](../../lua/plugins/mason.lua) | Add `:LanguageToolsInstall` as a lazy command and register its implementation when Mason loads. The loader may also load Mason locally to read a Windows package receipt. Refresh the registry for this workflow only on explicit command. Reuse usable executables and skip packages already installed or in progress. Exclude `typstyle` from Windows install requests before checking Mason package availability. Report unsupported packages and broken installed commands. Deduplicate per process and update tool readiness from actual install outcomes. |
| Cutover | Modify | [lua/plugins/init.lua](../../lua/plugins/init.lua), [lazy-lock.json](../../lazy-lock.json) | Retire the three overlapping automatic installation specs and their pins in the same candidate that switches activation and provisioning. Keep Mason, the startup phase DAP selection, and unrelated working-tree edits. |
| Cutover | Delete | `lua/configs/mason-lspconfig.lua`, `lua/configs/mason-conform.lua`, `lua/configs/mason-lint.lua` | Retire the setup modules when their package maps and actual install paths have passed the base, required, and legacy parity checks. |
| Cutover | Modify | [lua/utils/mason_cleanup.lua](../../lua/utils/mason_cleanup.lua) | Use the unfiltered package inventory. Find candidates from formerly enabled profiles now disabled, including legacy declarations. Report any missing profile declaration and leave its packages installed. Protect base, shared, explicitly protected, and still-enabled DAP packages. Seed an absent snapshot during baseline initialization. An empty snapshot yields no candidates and a malformed or unreadable snapshot blocks removal. List distinct candidates and require Yes. No and Escape cancel. Wait for actual outcomes and report failures so another run can retry. Preserve an existing snapshot until the explicit baseline update. |
| Cutover | Modify | [lua/configs/lsp.lua](../../lua/configs/lsp.lua), [lua/plugins/nvim-lspconfig.lua](../../lua/plugins/nvim-lspconfig.lua), [lua/plugins/lang/html/lsp.lua](../../lua/plugins/lang/html/lsp.lua), [lua/plugins/lang/css/lsp.lua](../../lua/plugins/lang/css/lsp.lua), [lua/plugins/lang/javascript/lsp.lua](../../lua/plugins/lang/javascript/lsp.lua), [lua/plugins/lang/sql/lsp.lua](../../lua/plugins/lang/sql/lsp.lua) | Have legacy LSP modules return settings for the common LSP setup. Keep existing native roots, options, and diagnostics. Bind resolved commands for HTML and CSS in place of the stock project-local executable lookup. Preserve native arguments and the Rustaceanvim exception. Move native Copilot activation only after the Linux Sidekick check below passes. |
| Cutover | Delete | [lsp/copilot.lua](../../lsp/copilot.lua) | Delete the native definition after an isolated Linux test shows that the plugin-owned server supplies Sidekick Next Edit Suggestions with native activation disabled. If that check fails, keep the native definition and activation and record the handoff as pending. |
| Cutover | Modify | [lua/configs/conform.lua](../../lua/configs/conform.lua), [lua/plugins/conform.lua](../../lua/plugins/conform.lua), [lua/plugins/lang/html/conform.lua](../../lua/plugins/lang/html/conform.lua), [lua/plugins/lang/css/conform.lua](../../lua/plugins/lang/css/conform.lua), [lua/plugins/lang/javascript/conform.lua](../../lua/plugins/lang/javascript/conform.lua), [lua/plugins/lang/sql/conform.lua](../../lua/plugins/lang/sql/conform.lua) | Have legacy modules return formatter settings. Register active chains in the shared Conform configuration with Lua, per-role filetypes, profile options, and format-on-save preserved. Replace the dynamic command lookup for Prettier and dprint while preserving their arguments and conditions. Use the same vetted command for manual and automatic formatting. Register `:ConformInfo` as a lazy command. |
| Cutover | Modify | [lua/configs/lint.lua](../../lua/configs/lint.lua), [lua/autocmds.lua](../../lua/autocmds.lua), [lua/plugins/lang/python/lint.lua](../../lua/plugins/lang/python/lint.lua), [lua/plugins/lang/javascript/lint.lua](../../lua/plugins/lang/javascript/lint.lua) | Move readiness gating here. Have per-language modules supply settings instead of registering linters on import. Dispatch only eligible, ready linters for each filetype, using the vetted command. Preserve Lua and legacy Linux lint behavior. Replace the Ruff argument override and use the Python module for the direct Windows Ruff route. |
| Cutover | Modify | [lua/plugins/lang/markdown/init.lua](../../lua/plugins/lang/markdown/init.lua), [lua/plugins/lang/python/init.lua](../../lua/plugins/lang/python/init.lua), [lua/plugins/lang/typst/init.lua](../../lua/plugins/lang/typst/init.lua), [lua/plugins/lang/html/init.lua](../../lua/plugins/lang/html/init.lua), [lua/plugins/lang/css/init.lua](../../lua/plugins/lang/css/init.lua), [lua/plugins/lang/sql/init.lua](../../lua/plugins/lang/sql/init.lua), [lua/plugins/lang/rust/init.lua](../../lua/plugins/lang/rust/init.lua) | Remove early language-tool setup via `load_lang_configs` from these spec imports. Remove the empty JavaScript spec import. Preserve enable checks and existing platform selection for plugin imports. Keep Markdown notes and rendering, Python uv, HTML live preview, CSS completion, and the Linux Typst preview, Python DAP, Rustaceanvim, crates, and DBUI workflows. |
| Cutover | Modify | [Rustaceanvim settings](../../lua/plugins/lang/rust/rustaceanvim.lua), [SQL formatting settings](../../.sqlformatterrc.json) | Move Cargo, Clippy, and hint settings to the rust-analyzer schema. Use the current SQL Formatter option names to preserve uppercase keywords and four-space indentation. |
| Cutover | Modify | [lua/plugins/lang/markdown/lsp.lua](../../lua/plugins/lang/markdown/lsp.lua), [lua/plugins/lang/python/lsp.lua](../../lua/plugins/lang/python/lsp.lua) | Return native settings for consumption by the common LSP setup. Preserve Python settings and Ruff hover policy. Apply Markdown watched-file capabilities to a per-server copy. Reuse the native server definitions in `lsp/`. |
| Cutover | Modify | [lua/plugins/lang/markdown/conform.lua](../../lua/plugins/lang/markdown/conform.lua), [lua/plugins/lang/python/conform.lua](../../lua/plugins/lang/python/conform.lua), [lua/plugins/lang/typst/conform.lua](../../lua/plugins/lang/typst/conform.lua) | Make these modules return native formatter options without registering chains on import. The registry provides the ordered chains. Keep dprint's root constraint and use Conform's stdin Typstyle definition with the verified absolute path when it passes the fixture. |
| Verification | Modify | [README.md](../../README.md), [docs/README_LANGUAGE_SYSTEM.md](../README_LANGUAGE_SYSTEM.md), [docs/MASON_CLEANUP_GUIDE.md](../MASON_CLEANUP_GUIDE.md) | Document tested versions, native PowerShell and Linux prerequisites, the explicit install and parser commands, the one-entry Go example, override retry and restart, and manual cleanup, snapshot and rollback behavior. |
| Verification | Modify | [EGM.md](../../EGM.md), [after/ftplugin/EGM.md](../../after/ftplugin/EGM.md), [lua/utils/EGM.md](../../lua/utils/EGM.md), [language guide](../README_LANGUAGE_SYSTEM.md) | Update the startup, ownership, and cleanup contracts. Keep profile-specific usage in the language guide. Record the retirement of the three installation adapters and the conditional handoff of native Copilot. |
| Verification | Create | `tests/neovim_language_smoke.lua` | Use one headless smoke script with temporary fixtures. Wait for startup and exit zero on success or nonzero after a failed assertion. Keep account login, optional integrations and interactive terminal checks out of this script. |

### Verification Plan

- **Profiles and invocation.** Run end-user bootstrap manually from native PowerShell with a fresh Neovim profile. For controlled checks on Windows x64 and Linux, set a unique `NVIM_APPNAME` and point `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME`, and `XDG_CACHE_HOME` at disposable roots. From those environments, query `stdpath("config")` and `stdpath("data")`. Put the candidate configuration and lockfile in the former. Put the same pinned lazy.nvim checkout at `lazy/lazy.nvim` under the latter and stage the lockfile-pinned plugin checkouts under its `lazy` directory. Verify the effective paths and revisions. Record the Neovim and parser prerequisite versions. Run `nvim --headless -c "luafile tests/neovim_language_smoke.lua"` from the candidate repository root. For the Linux upgrade and rollback, restore a copy in an isolated Linux VM or mount namespace with the original home hidden at the original absolute home, config and data paths so existing absolute launchers resolve to the copy. Keep the host profile unmounted and off PATH. Check the effective subprocess paths.
- **Native startup and parsers.** Verify an interrupted clone can retry and that a pre-existing incomplete checkout is reported. Test a drive root and a directory with spaces. Check `:PythonPath` for an activated Windows environment, an unactivated project environment with `Scripts/python.exe`, and no eligible interpreter. On Linux check the same priority and `bin/python`. Open, edit, and save before a parser is installed, run `:TSInstall` with the required parser, reopen, and check parser-backed behavior. Start Neovim's built-in terminal under PowerShell and Linux without tmux. Test the optional Sidekick terminal under herdr on Linux separately. Open Python on Windows with debugger packages absent and confirm Blink loads neither Copilot completion nor DAP dependencies. Verify both Telescope actions with typed module names containing spaces or literal filename characters such as `#`.
- **Explicit installation and retry.** With Ruff missing, verify startup requests no LSP, formatter, or linter package download or registry refresh for the new flow. Run `:LanguageToolsInstall` and observe one Ruff install. Reopen Python in the same session and check Ruff server attachment, the three Ruff formatters in Conform, and an actual Ruff lint diagnostic. Check once with adapters already loaded and once with an adapter first loaded after the command. Inject a failed install callback, preserve previously successful packages, and retry the failed package. Run again with all packages present and check the result message. On Windows, check the real Ruff and Pyrefly Mason schema 2.0 receipts and launch their native executables. Use fixtures for legacy schema 1.0, an absent receipt, malformed JSON, an invalid link, and a link outside the package. Rejected links must leave the tool unavailable and identify the wrapper.
- **Windows Typstyle provisioning.** Verify zero Mason Typstyle installation requests on clean Windows and on retry with a broken Typstyle shim first on PATH. Report the shim path and use the linked official v0.15.2 x64 executable through an absolute override. Restart, rerun the command, and verify the executable starts and Conform uses that path. Repair a failed probe at the same path and confirm explicit retry rechecks it without a restart. Record the x64 asset and checksum separately from the five-second version probe and formatting result.
- **Markdown.** Use a notes directory with `.moxide.toml`, `index.md`, and `target.md`. Require Markdown Oxide to attach at that root and resolve the link from the index to the target. Exercise dprint in a separate configured fixture and verify its root condition.
- **Python.** Use a project with `pyproject.toml` and an imported local symbol. Verify Pyrefly attachment and returned definition. Run Conform with LSP fallback disabled. Compare `x=1` with `x = 1` plus the original final newline and record the three Ruff formatters. In a separate unformatted file with an unused `import os`, assert F401 in Ruff's nvim-lint namespace. On Windows, use a fixture path with spaces and shell-significant characters and verify direct invocation of the vetted Ruff executable. Verify a valid empty array clears diagnostics. Malformed output and entries missing required fields preserve the last valid diagnostics. An older request that finishes late or returns after a buffer edit or rename cannot replace the current result.
- **Typst.** Use `typst.toml` and a `main.typ` fixture with `#let x=1`. Require Tinymist attachment at the expected root. Disable LSP fallback and record that Conform's Typstyle changes the fixture to `#let x = 1`. Confirm a second pass is unchanged.
- **Lua.** Open the Lua fixture as the first buffer and confirm Lua LS attaches using the installed command. Use a child project with `.luarc.jsonc` and a parent with `.luarc.json` to verify the selected root. Resolve a definition into another Lua file and verify StyLua formatting. On Linux, Luacheck remains a separate lint tool.
- **Go.** Add and enable the one registry declaration while retaining the existing enabled profiles. Run `:LanguageToolsInstall` with the Go toolchain on PATH. Require `gopls` attachment in a project with `go.mod`. Format a file containing `package main`, a blank line, and `func answer()int{return 42}`. Expect `package main`, a blank line, and `func answer() int { return 42 }`, with a final newline. Use a separate Go module with a function that declares `count := 42` and returns `count`. Compare the actual `textDocument/inlayHint` results at that declaration with `settings.gopls.hints.assignVariableTypes` disabled and enabled, restarting between runs. Disable Go and restart. Confirm the server stays inactive and the package remains installed.
- **Provisioning parity.** On clean Linux, exercise missing Lua LS and StyLua through the command and keep Luacheck external. With legacy profiles enabled and their tools missing, install and exercise HTML and CSS LSP and formatting, VTSLS, Oxlint and Prettier. Compare role eligibility against the baseline, including Prettier's JSON and JSONC, HTML's XHTML formatting, and CSS-family assignments. Verify that Rustaceanvim still attaches its Rust server, and that the separate Linux Python DAP workflow still provisions and starts a debug session. Check both already installed tools and explicit installation. Before removing native Copilot activation or its definition, verify Sidekick Next Edit Suggestions with the plugin-owned server in an isolated Linux session. Record authentication separately from whether the server launches and supplies suggestions.
- **Launch trust.** Put a workspace-local candidate first on PATH. Verify that neither an adapter nor the Typstyle version probe launches it and that no later PATH candidate runs. Test the rootless file case and a symlink into the workspace. Set a trusted absolute override and verify that executable launches. In separate fixtures with a trusted PATH selection, put competing project-local executables where HTML, CSS, dprint and Prettier would look. Verify the adapters launch the selected trusted path with their original arguments and conditions.
- **Manual cleanup.** Use test packages from a disabled profile as removal candidates. Include a test-only formerly enabled profile that also declares `ruff` and leave Python enabled so Ruff is retained by shared ownership. Check that an absent snapshot is seeded without deletion, an empty snapshot yields no candidates, and an invalid snapshot blocks removal. A profile name with no declaration must be reported without package removal. With one removable package, verify No and Escape cancel and Yes removes it. In a separate run with two test packages removable, fail one deletion and verify only the failed deletion is retried. An existing baseline stays unchanged on startup, save and cleanup. Confirm the explicit baseline update writes the new state without deleting tools.
- **Rollback.** In the isolated Linux environment, restore the previous configuration, lockfile, checkouts including lazy.nvim, Mason packages and shims, installed parsers, and language snapshot as one set. After a fresh start, open and save a file and let deferred tasks finish. Compare actual subprocess paths, revisions, package and parser inventories, and measured workflows with the pre-change baseline. Check the logs for unexpected installation and verify that each restored absolute launcher resolves inside the isolated copy.

*Drafted with EGM*
