---
name: tech-stack
description: >
    Update or introduce new dependencies and technologies. Use this whenever
    you need to add dependencies or external services to a project. Use when
    choosing/developing a tech stack for a project.
---

# Tech Stack

These are my general preferences. If you have questions or suggestions, make sure to ask the user. All of this can be overridden by the user.

## General Rules

- Avoid over engineering the stack. Only introduce complexity if features or performance demand it.
- Avoid dependency creep. Every dependency creates a supply chain risk.
- Don’t reinvent the wheel: rely on battle-tested, reliable, open software that already exists.
- Always confirm with the user before adding tech. Make sure to give reasons.

## Languages and package managers

My preferred language is Rust. Use `cargo` & `crates.io`.
Occasionally use TypeScript for complex UI stuff. Prefer `pnpm`.

## Backend

Rust.
`tokio`, `axum`, `tracing`, `thiserror`, `anyhow`. Use when appropriate.

## Web

This will generally depend on the project. Ask the user which web framework to use (generally SvelteKit or Leptos).

## Data & Databases

Start simple with SQLite. Use forks/rewrites such as LibSQL or Turso if you need the features.
Introduce Postgres if you need a centralized data store.

Only add caching & specialized systems (like Redis, ElasticSearch, Kafka, …) when bottlenecks appear or features demand it.

## Dependencies

When adding packages to a projects dependencies (typically via `cargo` or `pnpm`):
- use dependency auditing tools such as `cargo-deny` to make sure they are safe and the licence is appropriate.
- Avoid adding too many dependencies (dependency creep). This just bloats build times & increases the supply chain attack surface.

## Testing

In Rust, prefer `nextest`.
