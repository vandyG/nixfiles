---
description: "Use when generating, rewriting, reviewing, or suggesting Git commit messages. Enforces Conventional Commits 1.0.0 and commitlint config-conventional rules."
---

# Conventional Commit Messages

When asked to generate, rewrite, review, or suggest a Git commit message, produce a Conventional Commits 1.0.0 message that also satisfies `@commitlint/config-conventional` unless the user explicitly requests a different project convention.

Use this structure:

```text
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

## Header

- Start every message with a type, optional scope, optional breaking-change marker, colon, space, and short description.
- Use `feat` for user-visible features and `fix` for bug fixes.
- Prefer the commitlint conventional type set when another type is needed: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, or `test`.
- Keep the type lowercase and non-empty.
- Add a scope only when it adds useful context. Write it as a noun in parentheses, such as `fix(parser):` or `docs(readme):`.
- Keep the subject non-empty, lowercase or mixed case, and without a trailing period.
- Do not use sentence case, start case, PascalCase, or all caps for the subject.
- Keep the full header at or below 100 characters.
- Write the subject as an imperative, concise summary of the change.

## Body

- Add a body only when the header cannot explain the why, context, tradeoffs, or notable implementation details.
- Separate the body from the header with one blank line.
- The body may contain multiple free-form paragraphs.
- Wrap body lines at 100 characters or less.

## Footers

- Separate footers from the body, or from the header when there is no body, with one blank line.
- Write footer tokens in Git trailer style: `Token: value` or `Token #value`.
- Use hyphens instead of whitespace in footer tokens, except for the special `BREAKING CHANGE` token.
- Multiple footers are allowed, for example `Reviewed-by: Name` and `Refs: #123`.
- Wrap footer lines at 100 characters or less.

## Breaking Changes

- Mark every breaking API or behavior change with either `!` before the colon or a footer.
- For prefix notation, write `feat!:` or `feat(scope)!:`.
- For footer notation, write `BREAKING CHANGE: <description>` in uppercase exactly. `BREAKING-CHANGE:` is also valid.
- If `!` is used without a breaking footer, make the header subject clearly describe the break.
- Breaking changes may use any type, not only `feat` or `fix`.

## SemVer Meaning

- `fix` indicates a patch-level change.
- `feat` indicates a minor-level change.
- Any commit with `!`, `BREAKING CHANGE:`, or `BREAKING-CHANGE:` indicates a major-level change.
- Other types have no inherent SemVer effect unless they mark a breaking change.

## Selection Rules

- If the changes span unrelated concerns, recommend splitting them into multiple commits when practical.
- If a single message is still required, choose the type that represents the most user-visible or release-relevant change.
- Use `revert:` for revert commits and include a footer such as `Refs: <sha>` when useful.
- Do not invent issue numbers, reviewers, or scopes not supported by the provided context.

## Examples

```text
fix(shells): preserve direnv prompt status
```

```text
feat(vscode): add shared Copilot instruction modules

Load repository instructions through Home Manager so VS Code receives the same
guidance on every configured profile.
```

```text
refactor(profiles)!: rename WSL profile outputs

BREAKING CHANGE: existing flake output names for WSL profiles have changed.
```
