# 🧭 Ask → Plan → Agent

🌐 [Español](./README.md) | **English**

> **AI doesn't write spaghetti code. It writes it when nobody gave it an architecture.**

One engine (the *harness*), three different roles. You change the context constraints, not the tool, and the output goes from "pretty demo that breaks" to code you can maintain.

---

## 💡 The concept: Same Harness, Three Roles

Almost every AI editor and agent (Cursor, Claude Code, Copilot, Windsurf, etc.) is the same engine: a model + tools + context. What changes output quality is **what you allow it to do at each moment**.

| Role | Question it answers | Can write code | Can touch files | Output |
|---|---|:---:|:---:|---|
| 🔎 **Ask** (Architect/Consultant) | What exists and what can go wrong? | ❌ | ❌ (read-only) | Context map, dependencies, edge cases, open questions |
| 📐 **Plan** (Tech Lead) | What are we building and in what order? | ❌ (contracts only) | ❌ | Spec: atomic steps, types, file tree |
| ⚙️ **Agent** (Executor) | Do it, exactly like this. | ✅ | ✅ | Code that follows the approved plan |

**Agent** mode is what most harnesses ship by default. What this methodology changes is that it comes **after** Ask and Plan, and is **bounded** to the approved plan.

**The core idea:** the human sets the architecture *before* a single line of code exists. The AI executes inside that frame.

---

## 🪜 The 3-step methodology

### 1️⃣ Ask: understand before touching
You use the analyst role. It is **forbidden from writing code**. Its job is to map the context: which modules exist, who depends on whom, which assumptions are in play, which edge cases will bite us.
👉 Prompt: [`prompts-agnostic/01-ask-architect.md`](./prompts-agnostic/01-ask-architect.md)

### 2️⃣ Plan: design and approve
You use the tech lead role. It turns the analysis into a specification: atomic steps, type contracts and the final file tree. **It stops and waits for your approval.** This is where you fix the architecture, which is cheap. Fixing it later in code is expensive.
👉 Prompt: [`prompts-agnostic/02-plan-spec.md`](./prompts-agnostic/02-plan-spec.md)

### 3️⃣ Agent: execute against the contract
With the plan approved, the agent implements **one step at a time**. If something doesn't match the plan, it **asks; it doesn't improvise**.
👉 Prompt: [`prompts-agnostic/03-agent-executor.md`](./prompts-agnostic/03-agent-executor.md)

```
 Ask ──► Plan ──► (✋ human approval) ──► Agent
 map      spec                            code
```

---

## 🚀 How to use it

1. Copy the contents of `01-ask-architect.md` as the *system prompt* (or project instructions) in your favorite tool.
2. Describe your task and let it map the context. Answer its open questions.
3. Switch to the `02-plan-spec.md` prompt, give it the previous step's output and review the plan.
4. Only once you approve the plan, switch to `03-agent-executor.md` and run **one step at a time**.

The prompts are **agnostic**: they don't depend on any provider or IDE. They work in any chat or agent that accepts system instructions.

👉 **How do I install it in my tool?** Guide for Claude Code, Cursor, Copilot, Windsurf and direct API: [`docs/implementation.en.md`](./docs/implementation.en.md). Spoiler: the prompt advises, but **tool permissions** are what enforce.

📦 **Prefer copy and paste?** Ready-made files for Claude Code, Cursor and Copilot are in [`adapters/`](./adapters/).

> Note: the prompts are currently written in Spanish. Most models follow them fine in any language, and you can ask your assistant to translate them before use.

```
.
├── README.md
├── README.en.md
├── docs/
│   ├── implementation.md
│   └── implementation.en.md
├── adapters/             # generated from prompts-agnostic/
│   ├── claude-code/
│   ├── cursor/
│   └── copilot/
├── scripts/
│   └── build-adapters.sh
└── prompts-agnostic/
    ├── 01-ask-architect.md
    ├── 02-plan-spec.md
    └── 03-agent-executor.md
```

---

## 🧠 Why it works

- **Separating thinking from typing** stops the model from "solving" before understanding.
- **Contracts first** (types, interfaces) limit what the AI can invent.
- **Atomic steps** make every change reviewable and reversible.
- **Human approval** is the checkpoint where your engineering judgment matters most.

---

## 🎓 Learn to work this way

This repo comes from what we see every day teaching AI-assisted engineering. If you want to take this way of working further, [4Geeks Academy](https://4geeksacademy.com) offers programs built for it:

- **AI Engineer**: to build AI systems end to end.
- **AI Engineer for Devs**: for developers who already code and want to integrate AI with an architect's mindset.

---

## 🤝 Contributing

PRs are welcome: prompt improvements, real-world examples or adaptations to other tools. Open an issue with your case before large changes.

---

## 🌐 Connect

**Author**
- 💼 LinkedIn: [linkedin.com/in/ehiber](https://linkedin.com/in/ehiber)

**4Geeks Academy**
- 📸 Instagram: [@4geeksacademy](https://instagram.com/4geeksacademy)
- 🐦 X: [@4geeksacademy](https://x.com/4geeksacademy)
- 🐙 GitHub: [github.com/4GeeksAcademy](https://github.com/4GeeksAcademy)
- 🌍 Web: [4geeksacademy.com](https://4geeksacademy.com)

---

<sub>MIT License. Use it, adapt it, improve it.</sub>
