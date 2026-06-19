# Snyk IDE ecosystem

All repos are siblings under `~/Documents/commercial/`.

## Core relationship

The **CLI binary is the host**: `snyk-ls` (the language server) is embedded into the
`cli` binary and runs as the `snyk language server` subcommand. Both are Go and
**share common code via GAF** (`go-application-framework`) — the config engine,
flagset, auth, and config-resolver live there. `snyk-ls` also pulls the scan engines
in as Go modules (`cli-extension-*`).

So: `cli` ⊃ `snyk-ls` → `go-application-framework` (+ `cli-extension-*`).
Local cross-repo dev uses commented `replace` directives in `snyk-ls/go.mod` pointing
to the sibling repos.

The 4 IDE plugins are thin clients: they host the LS, render the HTML settings dialog
it serves, and forward LSP messages. **snyk-ls is authoritative; IDEs just forward.**

## Repos

| Path | What |
|------|------|
| `cli/` | Snyk CLI binary (Go). Host process; embeds the language server. Vendors GAF. |
| `snyk-ls/` | Language server (Go, DDD/hexagonal: application→domain→infrastructure→internal). Runs scans, owns config resolution, serves the HTML settings dialog. |
| `go-application-framework/` | GAF — Go lib shared by cli + snyk-ls. Owns `configuration.Configuration` engine, the pflag flagset (setting defs/scopes/remote keys), OAuth2/PAT auth, workflow engine, config-resolver (global/org/folder scope precedence). |
| `vscode-extension/` | VS Code plugin (TypeScript). Cleanest config path — JS preserves JSON nulls natively. |
| `snyk-intellij-plugin/` | IntelliJ/JetBrains plugin (Kotlin, JCEF webview, Gson). Gradle. Base branch: `master`. |
| `snyk-eclipse-plugin/` | Eclipse plugin (Java, SWT Browser, Jackson). Maven/Tycho; PMD in CI. Base branch: `main`. |
| `snyk-visual-studio-plugin/` | Visual Studio plugin (C#, WebView2, Json.NET). MSBuild/.NET Framework 4.8 — **Windows-only, won't build on macOS**. Base branch: `main`. |

## Build / test quick-ref

| Repo | Build | Test |
|------|-------|------|
| snyk-ls | `make build` | `make test` (~90m), `make lint-fix` |
| intellij | `./gradlew compileKotlin` | `./gradlew test --tests "*X*"` |
| eclipse | `./mvnw ... -pl plugin,tests` | tests run in `verify` phase (Tycho); `./mvnw pmd:check` |
| vsstudio | `dotnet build` (Windows) | `dotnet test` (Windows) |
