# 🧭 Ask → Plan → Agent

🌐 **Español** | [English](./README.en.md)

> **La IA no escribe código espagueti. Lo escribe quien no le dio arquitectura.**

Un mismo motor (*harness*), tres roles distintos. Cambias las restricciones de contexto, no la herramienta, y el resultado cambia de "demo bonita que se rompe" a código que puedes mantener.

---

## 💡 El concepto: Mismo Harness, Tres Roles

Casi todos los editores y agentes de IA (Cursor, Claude Code, Copilot, Windsurf, etc.) son el mismo motor: un modelo + herramientas + contexto. Lo que cambia la calidad de la salida es **qué le permites hacer en cada momento**.

| Rol | Pregunta que responde | Puede escribir código | Puede tocar archivos | Salida |
|---|---|:---:|:---:|---|
| 🔎 **Ask** (Arquitecto/Consultor) | ¿Qué existe y qué puede salir mal? | ❌ | ❌ (solo lectura) | Mapa de contexto, dependencias, edge cases, preguntas abiertas |
| 📐 **Plan** (Tech Lead) | ¿Qué vamos a construir y en qué orden? | ❌ (solo contratos) | ❌ | Spec: pasos atómicos, tipos, árbol de archivos |
| ⚙️ **Agent** (Ejecutor) | Hazlo, exactamente así. | ✅ | ✅ | Código que cumple el plan aprobado |

El modo **Agent** es el que casi todos los harness traen por defecto. La diferencia de esta metodología es que **llega después** de Ask y Plan, y **acotado** al plan aprobado.

**La idea central:** el humano pone la arquitectura *antes* de que exista una sola línea de código. La IA ejecuta dentro de ese marco.

---

## 🪜 La metodología en 3 pasos

### 1️⃣ Ask: entender antes de tocar
Usas el rol de analista. Tiene **prohibido escribir código**. Su trabajo es mapear el contexto: qué módulos existen, quién depende de quién, qué supuestos hay, qué casos borde nos van a morder.
👉 Prompt: [`prompts-agnostic/01-ask-architect.md`](./prompts-agnostic/01-ask-architect.md)

### 2️⃣ Plan: diseñar y aprobar
Usas el rol de tech lead. Convierte el análisis en una especificación: pasos atómicos, contratos de tipos y el árbol de archivos final. **Se detiene y espera tu aprobación.** Aquí corriges la arquitectura, que es barato. Corregirla después en código es caro.
👉 Prompt: [`prompts-agnostic/02-plan-spec.md`](./prompts-agnostic/02-plan-spec.md)

### 3️⃣ Agent: ejecutar contra el contrato
Con el plan aprobado, el agente implementa **un paso a la vez**. Si algo no cuadra con el plan, **pregunta; no improvisa**.
👉 Prompt: [`prompts-agnostic/03-agent-executor.md`](./prompts-agnostic/03-agent-executor.md)

```
 Ask ──► Plan ──► (✋ aprobación humana) ──► Agent
 mapa     spec                               código
```

---

## 🚀 Cómo usarlo

1. Copia el contenido de `01-ask-architect.md` como *system prompt* (o instrucciones del proyecto) en tu herramienta favorita.
2. Describe tu tarea y deja que mapee el contexto. Responde sus preguntas abiertas.
3. Cambia al prompt `02-plan-spec.md`, pásale el resultado del paso anterior y revisa el plan.
4. Solo cuando apruebes el plan, cambia a `03-agent-executor.md` y ejecuta **un paso a la vez**.

Los prompts son **agnósticos**: no dependen de ningún proveedor ni IDE. Funcionan en cualquier chat o agente que acepte instrucciones de sistema.

👉 **¿Cómo instalarlo en tu herramienta?** Guía para Claude Code, Cursor, Copilot, Windsurf y API directa: [`docs/implementation.md`](./docs/implementation.md). Spoiler: el prompt aconseja, pero los **permisos de herramientas** son los que obligan.

📦 **¿Prefieres copiar y pegar?** En [`adapters/`](./adapters/) están los archivos ya armados para Claude Code, Cursor y Copilot.

```
.
├── README.md
├── README.en.md
├── docs/
│   ├── implementation.md
│   └── implementation.en.md
├── adapters/             # generados desde prompts-agnostic/
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

## 🧠 Por qué funciona

- **Separar pensar de teclear** evita que el modelo "resuelva" antes de entender.
- **Los contratos primero** (tipos, interfaces) acotan lo que la IA puede inventar.
- **Pasos atómicos** hacen que cada cambio sea revisable y reversible.
- **La aprobación humana** es el punto de control donde tu criterio de ingeniería importa más.

---

## 🎓 Aprende a trabajar así

Este repo nace de lo que vemos cada día enseñando ingeniería con IA. Si quieres llevar esta forma de trabajar más lejos, en [4Geeks Academy](https://4geeksacademy.com) tenemos programas pensados para ello:

- **AI Engineer**: para construir sistemas con IA de principio a fin.
- **AI Engineer for Devs**: para desarrolladores que ya programan y quieren integrar IA con criterio de arquitectura.

---

## 🤝 Contribuir

Los PRs son bienvenidos: mejoras a los prompts, ejemplos reales de uso o adaptaciones a otras herramientas. Abre un issue con tu caso antes de cambios grandes.

---

## 🌐 Conecta

**Autor**
- 💼 LinkedIn: [linkedin.com/in/ehiber](https://linkedin.com/in/ehiber)

**4Geeks Academy**
- 📸 Instagram: [@4geeksacademy](https://instagram.com/4geeksacademy)
- 🐦 X: [@4geeksacademy](https://x.com/4geeksacademy)
- 🐙 GitHub: [github.com/4GeeksAcademy](https://github.com/4GeeksAcademy)
- 🌍 Web: [4geeksacademy.com](https://4geeksacademy.com)

---

<sub>Licencia MIT. Úsalo, adáptalo, mejóralo.</sub>
