---
publishDate: 2026-09-12T00:00:00Z
author: Clelia Astra Bertelli
title: Change and Movement
excerpt: On everything that happened in the past month or so
category: Life
tags:
  - life
  - tech-journey
  - learning
metadata:
  canonical: https://clelia.dev/blog/2026-09-12-change-and-movement
---

In the last month, many things have changed: I started a new position as a DevRel Engineer at [Qdrant](https://qdrant.tech), I've been working on some super interesting topics, I changed my relationship with coding agents, I've been building an agent for me to run locally and in the cloud, and I've been picking up OCaml, the language that enabled the new look on this website. But let's take one thing at a time, and let's start with my new job and what I've been up to there.

## DevRel at Qdrant

My primary role had always been software engineer, at least up to a month ago: although I leaned into DevRel and a bit of marketing at LlamaIndex, I was still contributing to core product and OSS tooling we had on a daily basis. And while I will never be grateful enough to the amazing team at LlamaIndex for all the growth and learning opportunities they gave me, I decided I wanted to try something a little bit difference.

At Qdrant, DevRel isn't traditional: we're closer to R&D and, while still interfacing with marketing and events, we often explore deeply technical topics so that our users and customers can understand them better.

And that's exactly what I've been doing: I've been focusing on performance and scalability for Qdrant, looking into [memory](https://qdrant.tech/articles/memory-tiers-in-qdrant-what-to-use-and-when/) and [optimizations](https://qdrant.tech/articles/tuning-qdrant-optimizer/), but also running experiments and learning about [TurboQuant](https://github.com/AstraBert/tquant-zig) and, more recently, trying to push my understanding of platform engineering by taking on some Kubernetes guides for [Qdrant Hybrid Cloud](https://qdrant.tech/documentation/hybrid-cloud/). I feel like this first month has given me the push I need to really go deep in highly technical topics and come out with an explanation or a tutorial that turns the hard theory into practice. And I'm doing this more and more leveraging coding agents, especially Claude Code, which brings me to the next section.

## My Relationship with Coding Agents

Despite being critical of vibe coding and feeling like agents where taking away the true craft of software engineering by spewing thousands of lines of code per day, I am viewing them a little differently nowadays.

I still try to avoid using them for side projects (where would the fun be, otherwise?), although I still resort to them to get a fresh perspectivw when I'm stuck on a problem, or to automate away code changes that would be tedious and repetitive to do by hand, but I'd say most of my side projects are still human written.

For what concerns work, coding agents are my daily driver, especially Claude (both the desktop app and Claude Code): I use them to source tutorial or article ideas by connecting different data sources such as Jira, Slack and Notion, as well as to improve my writing (being a non-native speaker, there is always a level of awkwardness in it), to polish my code or to write new modules, scripts or functionalities that I might not have the time to implement right away because I'm doing something else, but that would benefit from the kind of tight iteration coding agents can give them.

I work mostly asynchronously: spawn a task, do something else in the meantime, get back to Claude once I am done with it and review the output, while maybe spawning an other task: I still review most of the code Claude writes, unless they are trivial changes or I can get an understanding of the code without reading it in full (mostly if it's a refactor of what I already wrote). I also have the tendency to straight up run the code to analyze the bugs, if any, and fixing them manually/prompting the agent to iterate on them. 

I try to be on top of all the code and the artifacts my agents produce, and be sure to always know what they did: for instance, once they did some work and it's time to open a PR, I always force myself to write the description of the PR in a detailed way. If I lack the understanding needed to write a PR description, I don't understand the changes in that PR, so it's better to get back into the IDE and figure things out.

Agents are now a big part of my work, and that's fine: I'm slowly transitioning from feeling in control by physically typing out my thoughts from being in control by structuring my thoughts as a natural language plan and have them translated into code by an agent, so that I can review, iterate and modify on it faster.

That being said, I'm convinced that most of the times I don't need the maximum level of intelligence possible: for the sake of preserving my critical thinking and not spending hundreds of dollars in AI costs per day, I almost always use medium intelligence models combined with my own brain.

I've also started using non-Anthropic and non-OpenAI models: I'm a great fan of Kimi (which I've been intensely using, first with 2.6 and then with 3) and, once my Kimi credits will finish, I'll give GLM a shot, since they seem to be pushing hard on making highly capable models affordable.

For these models, that I mostly use for personal projects, I decided to write my own agent, that can run locally and inside a [celld](https://celld.dev) worker, which brings me to the next section.

## A Light Agent

I already tried to build my own agent framework and CLI/TUI before: [microagents](https://github.com/AstraBert/microagents), written in Rust and aimed at being a small and compostable agentic framework.

The framework was pretty cool and easy to use per se, but the agent CLI came with some overhead that I realised wasn't scalable: it had a built in `search` tool to perform hybrid search (semantic + keyword) over the codebase through an embedded vector search engine. It was also set to detect changes in files (using modification timestamp + size as fingerprint) and re-ingest them. As promising as it was, it could only be applied to small codebases: as soon as the number of files became substantial, the time it took to ingest them and the resources taken up by the embedded vector search engine took a toll on the agent UX, so I decided to abandon the approach and start from scratch.

I wanted something light, that would be super easy to get started with and highly autonomous: a shell tool, filesystem tools (read, write, edit), skills and a universal MCP client were the only things I needed and I wanted implemented in the agent. Very much aligned with the phylosophy behind [pi](https://pi.dev).

That's when I decided to build [`lightagent`](https://github.com/AstraBert/lightagent): this time in TypeScript and using [Deno](https://deno.com) as runtime. The choice of Typescript was mostly dictated by development velocity and by the idea of making this run natively in platforms like Cloudflare Workers or, better yet, their self-hosted version, celld.

I wanted this agent to be CLI first: not a library, just a binary (which is incredibly easy to do with Deno since it can compile to a standalone binary).

Of course, to run as a Durable Object inside celld and as a CLI agent on your machine I needed different implementations, but I wanted them to be as similar as possible. I wanted the filesystem tools to behave the same when interfacing with disk on a real machine or with [R2](https://developers.cloudflare.com/r2/) inside a worker. I wanted the event persistence logic to be the same both in a local SQLite database and in [D1](https://developers.cloudflare.com/d1/).

That's why I decided to define shared interfaces, contracts that both agent implementations should respect and adhere to, and use them to power the tools, so that I could swap agent backend and still use the same tool execution logic.

Of course, a Durable Object doesn't have a shell so I can't use the shell tool, but I worked around it adding some specialized UNIX tools (`grep`, `ls`, `date`, `diff`, `head`, `cat`) as extra tools leveraging the filesystem as primitive instead of the shell, but that's about it. I also added a few API endpoints to upload skills and files and to download a GitHub repository on the DO filesystem to allow the agent to get all the needed context: they are persistent so the same context can be shared across runs without re-uploading files.

As hinted before, the agent emits events that can be consumed in different ways (as a stream of characters on the terminal or as JSON lines in the streaming response from the worker), and they are persistent and replayable: they're stored in SQLite and are fetched on session resume.

Also, I was able to implement interruptions handling through [abort controllers](https://developer.mozilla.org/en-US/docs/Web/API/AbortController) and resuming gracefully, but I feel like at this point `lightagent` might need a blog post of its own.

I've been dogfooding it quite a bit (part of the lightagent codebase is written by lightagent itself, which is always so cool to me), and you can too, just by installing one of the pre-published binaries:

```bash
# Pick the target matching your platform:
#   aarch64-apple-darwin      (Apple Silicon)
#   x86_64-apple-darwin       (Intel Mac)
#   aarch64-unknown-linux-gnu (Linux ARM64)
#   x86_64-unknown-linux-gnu  (Linux x86_64)
curl -sL https://github.com/AstraBert/lightagent/releases/download/{version}/lightagent-cli-{target} -o lightagent-cli
chmod +x lightagent-cli
sudo mv lightagent-cli /usr/local/bin/
```

If you're on Windows, you can just download the dedicated EXE file from the latest release page and you should be good!

Let me know if you have any feedback and, with this being said, let's move on to the final section: OCaml, the new language I want to learn.

## OCaml in the Year of Rust

This year I set out to use Rust for most of my coding projects. I still intend to keep my promise, and I'm actually in the ideation phase for my next big Rust project, that's gonna take me the rest of 2026 and I think it's gonna be super cool if I get it right.

Despite Rust, though, I felt the push towards functional programming.

For some reasons I can't explain, FP has always been intriguing for me but, as I did for Rust before I started learning it, I thought it would be too difficult for me.

And, from my first OCaml projects, I can say it's true: the language is hard, mostly because it feels like a completely different mental model from what I am used to (I have only done imperative programming up to now, learnt to think in classes and abstractions rather than functions and effects). But that's exactly what I love most: deconstructing my pre-concepts, seeing how things I take for granted in my comfort zone may not be a given outside of it. I often compare the mental work I have to do when writing OCaml to the first times I tried to learn German as an Italian speaker: translating the same logic between two highly different structural representations.

Beyond the hardship of the first impressions, I'm quite happy about where I got with it after my first weekend of serious experimentation: you probably noticed the new look on my website, if it's not the first time you visited it. The codebase for my website used to be Astro: tens of files, lots of configurability, highly nested and structured. I realized that I didn't need all that complexity for a static website: I could just convert it to the HTML pages I needed, and host it directly on GH pages.

I used OCaml to script a small templating engine that takes the blog posts, parses their frontmatter, and generates HTML pages starting from a template: once done, it collects all the generated pages into one blog list and renders that to HTML as well. This allows me to go down from tens of Astro files to just `n_blog_posts + 2`, and deploy everything without any build process (besides the fast markdown -> HTML conversion) or complexity.

One question you might be asking yourself is: why OCaml? Well, I have four reasons:

- it is garbage collected: as much as I love the borrow checker model from Rust, it is nice not to have to think about ownership sometimes
- it has a fantastic type inference engine, to the point where you don’t have to manually annotate virtually any of your code
- It builds super fast and compiles both to bytecode and native code
- It was the language in which the first Rust compiler was written (before Rust became self-hosted), which might not be the best reason but still makes me think about the value that the language had for programmers much better than me

With this being said, we’ll see how far I can get with OCaml: stay tuned!

---

This was all: it was a long blog post, I know, and, if you got to the end, I am truly grateful for your support❤️. If you want to continue following me in my journey in tech, feel free to connect with me [on any of my social media](https://link.clelia.dev): see you next time!
