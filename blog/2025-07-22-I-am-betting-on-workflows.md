---
publishDate: 2025-07-22T00:00:00Z
author: Clelia Astra Bertelli
title: I am betting on workflows
excerpt: Opinions on why workflows are the future of production-grade AI applications.
category: Coding
tags:
  - python
  - coding
  - ai
metadata:
  canonical: https://clelia.dev/blog/2025-07-22-I-am-betting-on-workflows
---

# I am betting on workflows

## An Introduction

Recently I've shifted from building applications with AI agents to mostly employing workflows, especially [llama-index-workflows](https://github.com/run-llama/workflows-py).

It is important to draw a clear line between the two things: agents are meant to be autonomous, workflows for automation.

Autonomy vs Automation is _the_ difference between the two protocols - but there are many more: agents are completely AI-driven, can interact with the external environment (_lato sensu_) through tools, and can make decisions based on the response from the environment, adjusting its behaviour to it (optimally).

Workflows are pre-defined, can be AI-powered but they are not AI driven, and they behave according to well designed protocols and sets of rules.

Given this, the title of my blog post doesn't seem to make sense: how can I bet on rigidity instead of flexibility, how can a non-adaptable system be better than an adaptable one?

Well, bear with me, because I'll go through some features and design patterns that make workflows _the_ thing to be betting on, at least for the nearest future.

## The Predictability Key

The thing about workflows that make them better than agents right now is predictability: agents are known for being unpredictable - and that is part of their core design: autonomy requires a certain degree of freedom that can easily lead to unforeseen results.

And this is the most important barrier between agents and production-grade systems: it's not that you can't deploy agents to production, but you can't expect them to scale for millions of people without a certain degree of failure and unstable user experience.

Workflows, instead, might be more limited, but can be controlled: workflows are a low-level abstraction that you are able to design to follow specified patterns and solve specific problems. Workflows do not promise autonomy they can't maintain, they grant trustworthy automation.

Certainly a workflow is not as shiny as an agent that claims to be able to carry out tens of tasks - but is far more valuable: with a workflow you can tackle one problem (and the linked user base) very well, with an agent you might be able to resolve one problem well and many others with mediocre-to-good quality.

From what we can see on the market right now, with the boom of companies like [n8n](https://n8n.io), [make](https://make.com) or [Flowise](https://flowiseai.com/), as well as the investments of many companies into workflow-like structures (just think about [Google GenAI Processors](https://developers.googleblog.com/en/genai-processors/)), building workflows might just be the way of the foreseeable future to deliver true value in the world of AI.

## Designing Workflows 101

From my experience in building real-world workflows, I can tell you three design tips I learned to make my workflows able to respond to the users’ queries with reliable answers:

### 1. Use structure whenever you can

Structured input and output are at the base of reliability, especially if you are using LLMs or agents within the steps and you need to fetch data from their outputs.

Whenever you provide structure, you are not only cleaning chaos, but you are adding an extra layer of error-proofing to your workflow, by avoiding inconsistent and potentially disruptive responses.

So, every time you get a chance, use structured input (for example with XML tagging or JSON strings) and extract structured outputs (Pydantic models are the best for this!).

> _I wrote a post on why and how I use Pydantic, feel free to check it out [here](https://www.clelia.dev/2025-07-11-why-and-how-i-am-a-pydantic-user)._

### 2. Atomize tasks within the workflow

I define atomization as the division of tasks into simple units - each step of the workflow has to do one thing - in a RAG workflow, for example, one step would search the semantic cache, one do query transformation, one perform retrieval, another one rerank the results and one last would perform generation.

Atomization is the key to success in production: you don't need to write monolithic, _factotum_ code, you need to write clean, feature-focused code.

This is the exact reason why stepwise execution of workflows is so successful: you have control over what happens in your pipeline, you can debug faster and pinpoint errors at a precise step without having to use convoluted logging or blind print statements to understand what is going wrong.

Having a step-wise, atomized design is not only functional for error hunting, but also for preventing derailment of your entire pipeline: an agent might spend too much time into a hallucination-driven rabbit hole, while your workflows follows the practice of ‘fail fast’ - if there's a failure at a specific step, stop right there to prevent propagation (this is also one of the reasons structure is critical - having structure allows you to block errors early).

### 3. State-based and event-driven

We're often taught that state-based and event-based systems serve different purposes moving within different coordinates: state-based is synchronous and writes snapshots of a system into a form of persistent storage (a database, a JSON file; event-based is asynchronous and streams a set of pre-defined events that trigger one another.

While an event-driven architecture sounds more of a fit for workflows, it is not always the perfect solution - not on its own, at least.

Events are, indeed, a perfect solution for transient information exchange: the first step emits an event associating a payload to it, the second step is triggered by that event and captures the information through the payload - and that, in itself, is a perfect design for a two steps workflow.

But what happens when you add a third, a fourth, a n-nth step?

In that case, either you pass the information needed by the n-th step through n-1 events, or you opt for something smarter: create a state and associate it with the workflow.

It does not need to be a persistent state, as in systems that are purely state-based - it is enough to use a `dataclass` or a Pydantic BaseModel. The important things are:

- the state has clear, readable attributes with well defined functions (like `username` will store the username of the user, and `emailAddress` the email address)
- The the state attributes can be fetched and set at every time

Bonus points:

- The state is serializable (in that way you can write it to a file and read it later, allowing for some kind of persistency).
- Calls to fetch/set the state attributes are asynchronous, which is very important to maintain the general asynchronous design without risking time-outs in read/write operations.

This event-driven architecture with a dynamic global state is a perfect combination for ensuring reliability (through the set of pre-defined events) and availability (through the global state) while ensuring availability (for a better developer and user experience).

## A Real-World Example

I want to conclude this blog post with a real world example of how I applied those design principles, taking one of my latest projects: [gut](https://gut-ai.clelia.dev).

_gut_ is a CLI tool for automating `git` and `gh` commands, and follows this workflow:

1. The LLM is prompted to choose (structured output) between git and gh ([reference](https://github.com/AstraBert/gut/blob/814f034d7b5d210bd7cb0013b4cd687b7969a80f/src/gut/workflow/flow.py#L35-L62))
2. The LLM is asked to build the command, by producing a subcommand (like `commit`) and the options for the subcommand (like `-m 'first commit'`) - this is also done with structured output ([reference](https://github.com/AstraBert/gut/blob/814f034d7b5d210bd7cb0013b4cd687b7969a80f/src/gut/workflow/flow.py#L65-L112))
3. The LLM finally is asked to explain the command, putting it in the perspective of the user’s request (we use structured input and output also here; [reference](https://github.com/AstraBert/gut/blob/814f034d7b5d210bd7cb0013b4cd687b7969a80f/src/gut/workflow/flow.py#L115-L161))
4. Finally, the explanation is exposed to the user, which decides whether the command can be executed or not ([reference](https://github.com/AstraBert/gut/blob/814f034d7b5d210bd7cb0013b4cd687b7969a80f/src/gut/main.py#L39-L58))
5. If the feedback is positive, the command is executed, else the workflow re-starts adding the feedback to the starting user’s instructions (stored in the global state;: [reference](https://github.com/AstraBert/gut/blob/814f034d7b5d210bd7cb0013b4cd687b7969a80f/src/gut/workflow/flow.py#L164-L188))

The workflow respects all the design patterns

- It has a module ([models.py](https://github.com/AstraBert/gut/blob/main/src/gut/models.py)) where it keeps all the Pydantic models for structured data generation and extraction
- It atomizes the tasks, breaking the generation and execution of a command into several small steps (choice of the command, command string building, explanation, feedback and execution; see [workflow/flow.py](https://github.com/AstraBert/gut/blob/main/src/gut/workflow/flow.py))
- It has a [globally available state](https://github.com/AstraBert/gut/blob/814f034d7b5d210bd7cb0013b4cd687b7969a80f/src/gut/workflow/flow.py#L26-L31) that is fetched and set in different steps of the workflow (like [here](https://github.com/AstraBert/gut/blob/814f034d7b5d210bd7cb0013b4cd687b7969a80f/src/gut/workflow/flow.py#L52-L55) or [here](https://github.com/AstraBert/gut/blob/814f034d7b5d210bd7cb0013b4cd687b7969a80f/src/gut/workflow/flow.py#L122-L131)), while still highly relying on emitting events to trigger the steps in the workflow (all the events are described in [workflow/events.py](https://github.com/AstraBert/gut/blob/main/src/gut/workflow/events.py))

Other bonus points come from the framework I used to build the workflow: [llama-index-workflows](https://github.com/run-llama/workflows-py). This framework not only offers all the above mentioned functionalities out-of-the-box (stepwise execution, event-driven design and dynamic global state), but it also comes with built-in observability (examples [here](https://github.com/run-llama/workflows-py/blob/main/examples/observability/workflows_observability_pt1.ipynb) and [here](https://github.com/run-llama/workflows-py/blob/main/examples/observability/workflows_observability_pt2.ipynb)) and the possibility of locking the global state to prevent unruled access.

I hope this code example is clear enough and, in general, I really hope that this blog post was useful to you to understand why to bet on workflows to build reliable and scalable applications delivering real value in the world of GenAI.
