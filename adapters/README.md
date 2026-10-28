# 📦 Adaptadores listos para copiar

Archivos ya armados para instalar los tres roles en cada herramienta. Copia la carpeta de tu herramienta **a la raíz de tu proyecto**.

| Herramienta | Copia esto | Cómo se usa |
|---|---|---|
| Claude Code | `claude-code/.claude/` | Subagentes `ask-architect`, `plan-spec`, `agent-executor`, con herramientas limitadas por rol |
| Cursor | `cursor/.cursor/` | Reglas `ask`, `plan`, `agent`: actívalas con `@` al cambiar de modo |
| GitHub Copilot | `copilot/.github/` | Modos de chat con lista de herramientas por rol |

```bash
# Ejemplo: instalar para Claude Code en tu proyecto
cp -r adapters/claude-code/.claude /ruta/a/tu/proyecto/
```

## Importante

- **Los adaptadores se generan.** La fuente de verdad es [`prompts-agnostic/`](../prompts-agnostic/). Si cambias un prompt, regenera con `bash scripts/build-adapters.sh` y no edites `adapters/` a mano.
- **Ask y Plan son de solo lectura** (sin editar ni ejecutar). Solo `agent-executor` puede escribir y ejecutar. Ese es el punto de la metodología: lee la [guía de implementación](../docs/implementation.md).
- Los nombres de herramientas y carpetas de Cursor y Copilot cambian entre versiones. Si tu versión usa otros, ajusta el encabezado (el cuerpo del prompt no cambia).

---

📦 *Ready-to-copy adapters.* Copy your tool's folder to your project root. Generated from `prompts-agnostic/` with `bash scripts/build-adapters.sh`; don't edit by hand. Ask and Plan are read-only; only `agent-executor` can write and run commands.
