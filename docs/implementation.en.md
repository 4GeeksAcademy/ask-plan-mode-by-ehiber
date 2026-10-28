# 🔧 How to implement it in your harness

🌐 [Español](./implementation.md) | **English**

The prompts in [`/prompts-agnostic`](../prompts-agnostic/) work in any tool. This guide shows how to install them in the most common ones.

> Tools change fast. The folder and field names below may vary by version: when in doubt, check your tool's official documentation.

---

## ⚠️ Golden rule: the prompt advises, permissions enforce

A prompt that says "don't write code" is a **soft constraint**: the model can slip past it. A tool without write permission is a **hard constraint**: it can't.

For each role, use both layers:

| Role | Prompt | Tool permissions |
|---|---|---|
| Ask | `01-ask-architect.md` | Read-only: read, search, list. No editing or running commands |
| Plan | `02-plan-spec.md` | Read-only (same as Ask) |
| Agent | `03-agent-executor.md` | Read + write + execute, with human confirmation |

If your tool lets you choose tools per mode, **do it**. It turns this methodology into a guarantee instead of a suggestion.

---

## 1. Claude Code

**Option A: one subagent per role** (recommended). Create one file per role in `.claude/agents/` with tools limited in the header:

```markdown
---
name: ask-architect
description: Analyzes context, dependencies and edge cases. Never writes code.
tools: Read, Grep, Glob
---

<paste the contents of prompts-agnostic/01-ask-architect.md here>
```

Do the same for `plan-spec` (`tools: Read, Grep, Glob`) from `02`. The Agent role can be the default behavior or an `agent-executor` subagent with `tools: Read, Edit, Write, Bash, Grep, Glob` from `03`.

**Option B: native plan mode.** Claude Code ships a read-only planning mode (cycle modes with `Shift+Tab`, or start with `--permission-mode plan`). Use it for the Plan step and add the contents of `02-plan-spec.md` as project instructions.

**Persistent instructions:** if you want the flow to always apply, reference the prompts from your `CLAUDE.md`.

---

## 2. Cursor

Cursor already ships **Ask**, **Plan** and **Agent** modes, and this methodology gives them content.

- **Project rules:** create rules in `.cursor/rules/` (for example `ask.mdc`, `plan.mdc`, `agent.mdc`) with each prompt's content, and activate them manually (with `@`) when entering each mode.
- **Custom modes:** if your version supports them, define one mode per role with its instructions and **only the tools it needs** (read for Ask/Plan; edit and terminal for Agent).

---

## 3. GitHub Copilot (VS Code)

- **Repository instructions:** `.github/copilot-instructions.md` always applies. Use it for general rules, not for switching roles.
- **Custom modes/agents:** Copilot lets you define mode files with a tool list (in `.github/chatmodes/` or `.github/agents/`, depending on the version). Create three, copying each prompt as the body and limiting `tools` as in the table above.
- The native **Ask** and **Agent** modes match steps 1 and 3.

---

## 4. Windsurf and other editors

Almost all of them offer two pieces: **per-project rules/instructions** and **a chat-only mode versus an editing mode**. Map them like this:

- Ask and Plan → chat mode (no editing) + the matching prompt as a rule.
- Agent → editing mode + `03-agent-executor.md` as a rule.

---

## 5. Direct API or your own agent (any provider)

If you build your own agent loop, the pattern is:

1. Keep **one harness** (same loop, same model).
2. For each phase, change two things: the **system prompt** (the role's file) and the **list of tools** exposed to the model.
3. Make the Plan-to-Agent transition **require a human action** (a button, a flag, an `APPROVED` reply), never an automatic switch.

```text
phase = "ask"    → system = 01-ask-architect.md   · tools = [read, search]
phase = "plan"   → system = 02-plan-spec.md       · tools = [read, search]
phase = "agent"  → system = 03-agent-executor.md  · tools = [read, search, edit, run]
```

---

## 🔁 The flow in practice

1. Switch to the **Ask** role, describe the goal and answer its open questions.
2. Switch to the **Plan** role and pass in the previous step's output. Review and correct the plan.
3. Reply `APROBADO` (or `APROBADO pasos 1-3`), the approval keyword the prompts expect.
4. Switch to the **Agent** role with the approved plan as context and run **one step at a time**.

**Tip:** save the approved plan as a file (for example `PLAN.md`) in your repo. It survives a session change and you can hand it to the Agent as the source of truth.

---

## ✅ How to tell it's working

- The Ask role never returns implementation code.
- The plan stops and asks for approval before executing.
- Each Agent step ends with a report and a real verification (build or tests).
- If the plan doesn't match the code, the Agent asks instead of improvising.
