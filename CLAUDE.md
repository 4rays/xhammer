# xbridge

## Architecture

- `xbridge` — user-facing CLI; connects to daemon over Unix socket, auto-starts it if missing
- `xbridged` — background daemon; owns the single long-lived `xcrun mcpbridge` connection
- `XbridgeCore` — shared library (LocalRPC protocol, MCP messages, JSON types, paths)
- CLI↔daemon protocol: newline-delimited JSON (`LocalRPCRequest` / `LocalRPCResponse`)

## Build & Install

- `swift build` — debug build
- `swift build -c release` — release build
- `make install` — release build + install to `~/.local/bin` (no sudo needed)
- Binaries: `.build/debug/xbridge`, `.build/debug/xbridged`
- `swift test` — run unit tests (XbridgeCoreTests: LocalRPC, MCPMessages)

## Running

- Start daemon manually: `.build/debug/xbridged &`
- After rebuilding xbridged, run `xbridge stop` first — old daemon is still bound to the socket
- Daemon socket: `~/Library/Application Support/xbridge/daemon.sock`
- Daemon log: `~/Library/Application Support/xbridge/daemon.log`

## Xcode MCP Bridge

- Tool names are PascalCase: `XcodeListWindows`, `BuildProject`, `XcodeGrep`, etc.
- Run `xbridge tools` to see the live list from the bridge
- Run `xbridge tool-schema <name>` to inspect argument schemas
- Bridge response format: `{"structuredContent":{"message":"..."},"content":[...]}`
- `structuredContent.message` is plain text; `content[0].text` is JSON-encoded

## Swift Concurrency (Swift 6)

- All global state must be `Sendable`; `Command` closures need `@Sendable`
- `FileHandle` in structs needs `@unchecked Sendable`
- Non-Sendable types stored in actors need `nonisolated(unsafe)`
