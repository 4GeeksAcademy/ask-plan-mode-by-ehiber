# 🔧 Cómo implementarlo en tu harness

🌐 **Español** | [English](./implementation.en.md)

Los prompts de [`/prompts-agnostic`](../prompts-agnostic/) funcionan en cualquier herramienta. Esta guía muestra cómo instalarlos en las más comunes.

> Las herramientas cambian rápido. Los nombres de carpetas y campos de abajo pueden variar según tu versión: ante la duda, revisa la documentación oficial de tu herramienta.

---

## ⚠️ Regla de oro: el prompt aconseja, los permisos obligan

Un prompt que dice "no escribas código" es una **restricción blanda**: el modelo puede saltársela. Una herramienta que no tiene permiso de escritura es una **restricción dura**: no puede.

Para cada rol, usa las dos capas:

| Rol | Prompt | Permisos de herramientas |
|---|---|---|
| Ask | `01-ask-architect.md` | Solo lectura: leer, buscar, listar. Sin editar ni ejecutar comandos |
| Plan | `02-plan-spec.md` | Solo lectura (igual que Ask) |
| Agent | `03-agent-executor.md` | Lectura + escritura + ejecución, con confirmación humana |

Si tu herramienta permite elegir herramientas por modo, **hazlo**. Es lo que convierte esta metodología en una garantía y no en una sugerencia.

---

## 1. Claude Code

**Opción A: subagentes por rol** (recomendada). Crea un archivo por rol en `.claude/agents/` con las herramientas limitadas en el encabezado:

```markdown
---
name: ask-architect
description: Analiza el contexto, dependencias y edge cases. Nunca escribe código.
tools: Read, Grep, Glob
---

<pega aquí el contenido de prompts-agnostic/01-ask-architect.md>
```

Haz lo mismo con `plan-spec` (`tools: Read, Grep, Glob`) a partir del `02`. El rol Agent puede ser el comportamiento por defecto o un subagente `agent-executor` con `tools: Read, Edit, Write, Bash, Grep, Glob` a partir del `03`.

**Opción B: modo plan nativo.** Claude Code trae un modo de planificación de solo lectura (alterna modos con `Shift+Tab`, o inicia con `--permission-mode plan`). Úsalo para el paso Plan y añade el contenido de `02-plan-spec.md` como instrucciones del proyecto.

**Instrucciones persistentes:** si quieres que el flujo aplique siempre, referencia los prompts desde tu `CLAUDE.md`.

---

## 2. Cursor

Cursor ya trae los modos **Ask**, **Plan** y **Agent**, y esta metodología les da contenido.

- **Reglas de proyecto:** crea reglas en `.cursor/rules/` (por ejemplo `ask.mdc`, `plan.mdc`, `agent.mdc`) con el contenido de cada prompt, y actívalas manualmente (con `@`) al entrar a cada modo.
- **Modos personalizados:** si tu versión los soporta, define un modo por rol con sus instrucciones y **solo las herramientas que le tocan** (lectura para Ask/Plan; edición y terminal para Agent).

---

## 3. GitHub Copilot (VS Code)

- **Instrucciones de repositorio:** `.github/copilot-instructions.md` aplica siempre. Úsalo para reglas generales, no para cambiar de rol.
- **Modos/agentes personalizados:** Copilot permite definir archivos de modo con lista de herramientas (en `.github/chatmodes/` o `.github/agents/`, según la versión). Crea tres, copiando cada prompt como cuerpo y limitando `tools` igual que en la tabla de arriba.
- Los modos nativos **Ask** y **Agent** encajan con los pasos 1 y 3.

---

## 4. Windsurf y otros editores

Casi todos ofrecen dos piezas: **reglas/instrucciones por proyecto** y **un modo de solo conversación frente a uno que edita**. Mapea así:

- Ask y Plan → modo de conversación (sin edición) + el prompt correspondiente como regla.
- Agent → modo que edita + `03-agent-executor.md` como regla.

---

## 5. API directa o tu propio agente (cualquier proveedor)

Si construyes tu propio bucle de agente, el patrón es:

1. Mantén **un solo harness** (mismo bucle, mismo modelo).
2. Por cada fase, cambia dos cosas: el **system prompt** (el archivo del rol) y la **lista de herramientas** expuestas al modelo.
3. Haz que el paso de Plan a Agent **requiera una acción humana** (un botón, un flag, una respuesta `APROBADO`), nunca un cambio automático.

```text
fase = "ask"    → system = 01-ask-architect.md   · tools = [read, search]
fase = "plan"   → system = 02-plan-spec.md       · tools = [read, search]
fase = "agent"  → system = 03-agent-executor.md  · tools = [read, search, edit, run]
```

---

## 🔁 Flujo en la práctica

1. Cambia al rol **Ask**, describe el objetivo y responde sus preguntas abiertas.
2. Cambia al rol **Plan** y pasa el resultado del paso anterior. Revisa y corrige el plan.
3. Responde `APROBADO` (o `APROBADO pasos 1-3`).
4. Cambia al rol **Agent** con el plan aprobado como contexto y ejecuta **un paso a la vez**.

**Consejo:** guarda el plan aprobado como archivo (por ejemplo `PLAN.md`) en tu repo. Así sobrevive a un cambio de sesión y puedes dárselo al Agent como fuente de verdad.

---

## ✅ Cómo saber si funciona

- El rol Ask nunca devuelve código de implementación.
- El plan se detiene y pide aprobación antes de ejecutar.
- Cada paso del Agent termina con un reporte y una verificación real (build o tests).
- Si el plan no cuadra con el código, el Agent pregunta en lugar de improvisar.
