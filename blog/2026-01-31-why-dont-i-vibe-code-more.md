---
publishDate: 2026-01-31T00:00:00Z
author: Clelia Astra Bertelli
title: Why don't I vibe code more?
excerpt: Yapping about my experience with vibe-coding
category: Coding
tags:
  - ai
  - coding
  - vibe-coding
metadata:
  canonical: https://clelia.dev/blog/2026-01-31-why-dont-i-vibe-code-more
---

A few months ago, I wrote about [how I use AI to code](https://clelia.dev/2025-08-24-how-i-use-ai-to-code) in my day-to-day work.

To summarize it, it looked like this:

- Claude (Desktop app) for questions, explanations and clarifications: no prompt engineering, just plain and simple copy-pasting code/error messages and asking specific questions about what I need
- GitHub Copilot for documentation drafts and code refactors that I know how to do, but that would be tedious to do manually and cannot be done by simple search-and-replace.
- ChatGPT for reviews of content - mainly for social posts or to avoid the non-native speaker awkward phrasing effect in my writing.

And, I have to say, despite the raise in popularity of Claude Code and Codex (and many more terminal or IDE-based coding agents), my workflow hasn't changed much: I still handwrite things for the most part (I'd say 70-80% of my code), and resort to AI for the purposes I detailed above.

I've been told and read on socials, many times, that coding agents will make me a nX engineer (with n ranging from 2 to 100), but I can't really wrap my head around coding agents, so I asked myself a simple question: **why don't I vibe-code more?**

I came to one main conclusion, which boils down to: I am not a good enough engineer to trust my reviewing skills on AI-generated code.

I decided to break down the above conclusion into two parts: backend programming and frontend programming, in which I approach AI-assisted coding differently.

## Backend

For what concerns backend, I mostly code in python at work, and use Go and Rust for side projects.

I can say I'm good with Python and fairly good with Go (and still learning Rust) but there is a big catch: I don't have CS foundations, and I am trying to learn as much as I can about systems design but I'm still not at a senior level.

AI, though, requires me to make senior-level decisions: while I understand the code it writes, and can catch duplications, bugs, verbose or over-bloated patterns, I cannot tell with 100% certainty whether or not the design that AI is going for is the right one for the application, if security criteria are met, if the application will be fault tolerant enough and handle exceptions and validations correctly.

The only way for me to grow and learn all of these things is to do them myself: I am the kind of dev that learns by doing, and offloading the writing process to AI deprives me of the biggest of opportunities, which is thinking about my code out loud while I type it, move it around, debug, ship, break, dive into logs, iterate… In general, what helps me the most is knowing exactly what I added, what failed and what went well.

One great advantage for me is that I have the opportunity to work with amazing engineers: every time they review my PRs, I learn something and have the chance to go back to my code and apply those learnings.

That's the entire point for why I don't vibe code with backend programming: it would take away the learning process that I put into code and, without that learning process, I cannot truly get to a stage where I feel confident enough to just yolo my PRs with Claude Code and review them myself.

## Frontend

Things for frontend are different: while I do know how to write typescript, and I am familiar with a couple of React frameworks (NextJS, Vite, TanStack…), I am a terrible designer and UX engineer, mostly because I see things through the eyes of a developer and not of a user. That's why, in most cases, I lay out the core logic (state management, effects, callbacks…), and then just ask Claude to generate a nice frontend.

Contrarily to what happens with the backend, the frontend is there for me to see it: I can easily see when things are not correct (generally elements are misplaced or wrongly styled), and I can iterate very fast reporting to Claude exactly what I want the piece of frontend to do and exactly where it has to apply the fix.

Nevertheless, I never go for big changes: most of the time I ask Claude to help me with the styling of a component or of a part of it, or maybe to generate some static HTML and CSS that I can easily validate in the browser.

In general, I feel like I can trust myself more with AI-assisted coding in the frontend because core business logic is not in there (most of the times): you can't break database schemas or be DDOSed because you messed up the rate limiting or the WAF layer, so I'm much less anxious that I'm going to screw things up (although obviously there are risks involved that I'm aware of).

## Conclusion

In conclusion, my main problem with pure vibe-coding is that I don't trust my abilities enough to make judgements over AI skills: am I being overly anxious and gatekeeping myself to avoid giving the control away? Yes and no - most of the times my reason is different: I _need_ to learn fundamental skills like systems design, scalability strategies, performance tips and tricks, and many more things, to be able to effectively manage my own agents, but if I vibe code everything, I will never learn these skills, and thus will never be able to become an agents manager.

It might be naive, but it takes to be a mid-level engineer for a while and get some experience before reaching senior positions and being able to manage other people: and if we're requesting it for human coders, why wouldn't we want it also for AI ones?

I'll for sure try to vibe code more in the future, but for now I'm focused on strengthening my fundamentals to enter the AI era the right way.
