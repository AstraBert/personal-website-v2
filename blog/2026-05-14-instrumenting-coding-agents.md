---
publishDate: 2026-05-14T00:00:00Z
author: Clelia Astra Bertelli
title: Instrumenting Coding Agents
excerpt: Yapping about adding an observability layer to coding agents
category: Coding
tags:
  - ai
  - observability
  - agents
metadata:
  canonical: https://clelia.dev/blog/2026-05-14-instrumenting-coding-agents
---

> **N.B.:** _"Observability" in this post refers specifically to the collection of traces and metrics — not to logging._

Observability is a critical requirement for any sufficiently complex piece of software. Without it, tracking how services communicate, what data flows between them, which request paths run hottest, or where errors surface within a call chain becomes extremely difficult.

For deterministic applications, traces are already invaluable: they let us monitor for meaningful variations and intervene when something drifts. But software has recently gained a new category of components, non-deterministic engines like LLMs, and these change the picture considerably.

Traditional applications fail in well-understood ways: network errors, race conditions, cache staleness. LLM-based systems inherit all of those failure modes and layer new ones on top: hallucinations, incorrect information, wrong tool calls, context poisoning. Crucially, these failures resist the usual remedies. You can't retry your way out of a hallucination, and a debugger won't tell you why your model chose the wrong tool. A solid observability setup, one that captures what goes into an LLM, what comes out, and how quickly and accurately it does so, is therefore more important than ever.

This is especially true for coding agents, and particularly the closed-source ones. Most operate as black boxes, hiding their internal composition from the user. As a result, when something goes wrong, the instinct is to blame the model, when the real culprit might be the harness, the context, or the prompt construction.

In this post, I'll walk through two approaches for adding an instrumentation layer to coding agents: turning them from opaque black boxes into systems that, if not fully transparent, are at least meaningfully explainable.

### Approach 1: API Proxy with Langfuse tracing

[`fuseproxy`](https://github.com/AstraBert/fuseproxy) is a self-hostable API proxy that runs locally and intercepts the calls a coding agent makes to its LLM provider. Rather than requests going directly to Anthropic or OpenAI, they are routed through `fuseproxy`, which instruments them with the [Langfuse](https://langfuse.com/) SDK, capturing prompts, system instructions, tool definitions, token usage, and cost.

This approach is less concerned with tracking an agent session end-to-end, and more focused on _how_ the agent uses the model: what instructions are injected via prompt scaffolding or the system prompt, how much of the context window is consumed, how aggressively caching is used and how efficiently.

When an agent fails to complete a task, you can open the Langfuse dashboard and inspect the requests it sent: what content the agent retrieved and how it was surfaced to the model, which tool call failed and why, and how the context was structured at the time. Armed with those findings, you can update your `AGENTS.md`, add targeted hooks, or apply prompt engineering to steer the agent toward better outcomes.

That said, this approach has two limitations worth noting:

1. **Extra network hop** — requests travel through the local proxy on the way to the LLM API and back, adding latency.
2. **Stateless by design** — each LLM interaction is treated independently, with no notion of a containing agent session.

### Approach 2: Hooks-Based Observability

> **N.B.:** _Claude Code already exposes OTel-compatible observability traces natively: this is an experiment to explore what hooks-based observability looks like in practice, and what it can offer beyond that._

[`instrument-claude`](https://github.com/AstraBert/instrument-claude) uses Claude Code's hooks system to collect instrumentation data about agent sessions. The [Claude documentation](https://code.claude.com/docs/en/hooks#userpromptsubmit) defines hooks as user-defined shell commands, HTTP endpoints, or LLM prompts that execute automatically at specific points in Claude Code's lifecycle. By listening to the events the CLI emits as it boots, runs, and shuts down, you can reconstruct a complete picture of any past interaction.

`instrument-claude` exposes a simple HTTP server with a `/hooks` endpoint. Claude Code (configured via the `hooks` entry in `.claude/settings.local.json`) sends hook events to this endpoint automatically. As events arrive, the server parses them and maintains an in-memory state map tracking active sessions, turns, tool calls, and sub-agents. These are cross-referenced and structured into a trace through context propagation, following the hierarchy: session → turn → tool call, and session → turn → sub-agent → tool call.

Traces are exported to an OpenTelemetry Collector and forwarded to Jaeger. Like `fuseproxy`, `instrument-claude` is fully self-hostable. Inside Jaeger, you can explore traces through span attributes (the primary carrier of hook event data) and events, used for secondary hook signals.

The main strength of this approach is session-level fidelity: every event within a session is captured and linked. The tradeoff is that, without a direct LLM proxy, you lose the granularity that comes with intercepting API calls: detailed token usage, cost estimation, and raw prompt inspection. The two approaches are complementary, though: you can point Claude Code's base URL at `fuseproxy` _and_ configure hooks simultaneously, combining session-level structure with API-level detail.

### Conclusion

Coding agents are becoming a routine part of software development workflows, yet most of them still operate as black boxes: opaque about what they retrieve, what they send to the model, and why they fail when they do. The two approaches explored here take different cuts at the same problem.

`fuseproxy` gives you a window into the model layer: what goes in, what comes out, how much it costs, and how efficiently context and caching are used. `instrument-claude` gives you the session layer: the full arc of an interaction, structured as a navigable trace from first prompt to final tool call. Neither approach is complete on its own, but used together, they provide the kind of observability that makes debugging a real agent failure something other than guesswork.
