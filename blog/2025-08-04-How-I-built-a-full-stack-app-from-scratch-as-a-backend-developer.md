---
publishDate: 2025-08-04T00:00:00Z
author: Clelia Astra Bertelli
title: How I built a full-stack app (from scratch) as a backend developer
excerpt: My tips and tricks to other fellow backend developers to get started on building effective full stack applications.
category: Coding
tags:
  - typescript
  - coding
  - fullstack
metadata:
  canonical: https://www.clelia.dev/blog/2025-08-04-how-i-built-a-full-stack-app-from-scratch-as-a-backend-developer
---

Almost a year ago, in those naive days when _vibe coding_ wasn’t even an expression, I was building frontends in TypeScript almost exclusively using LLMs: as everybody else, I first attempted coding with ChatGPT, then, out of frustration, I moved to Gemini and Claude, but maybe the times were too immature and the results were often disappointing and far from the liquid, dynamic and beautiful interfaces that populate the modern web.

Today, when _vibe coding_ is indeed a thing, and everybody is talking about how they’ve built their own shiny app in [Lovable](https://lovable.dev) (which, by the way, I highly appreciate as a tool), I decided I needed to learn frontend and full stack development.

In this sense, this weeekend I decided to dedicate part of my time to developing a full stack application completely from scratch - the objective was simple, a **cat feeding tracker web application**, but the implementation was indeed trickier than I expected:

- Being a web app, I needed to mask it from other people (that do not feed my cat), so I had to implement **authentication** and restrict it only to a certain number of people
- Also, since we need to keep track of all the feeding times, we needed persistency: in this sense, I had to hook up the application to a **database**.
- Also, operations with the database cannot be done by anybody: only authenticated users should be able to write to the table where we store the feedings, so I had to implement **security policies** for the read/write access to the database itself.

After building the app, whose code you can find on [GitHub](https://github.com/AstraBert/cat-feeding-app), I said to myself: why don’t I share my experience with other people who are trying to approach the full stack world as I am? So here are my top three suggestions for other fellow backend developers who want to dive also into the fun of frontend.

## 1. Use similar projects, template or scaffolds

The first thing I do when I want to build a full stack application is looking for similar projects or templates: if I cannot find anything, I fall back to scaffolds. But what do I mean by that?

When I talk about similar project, I’m mostly talking about other GitHub repositories that serve the same purpose of the thing you want to build, or a similar one: for examples, I highly recommend you to hunt for inspiration for your personal portfolio in GitHub, which is a real gold mine in terms of that. You can open [GitHub Topics](https://github.com/topics) (or even just the search bar in your home page) and then search for whatever you would like to create: most of the times I already know the language I want to create the application with, so I also filter for that. After I found a bunch of repositories, I go through them and I select them according to three main criteria: **complexity** (the app has to align with the complexity I have in mind), **customizability** (the app should be easy to change and customize) and **presence of a demo** (the fact that there is a demo means that the app deploys and works) - a bonus criterion is often the README/documentation: most of the times READMEs/docs are minimal and do not give you any useful instructions, so when they are there it means you already have a good point to start.

If you can’t find actual products that are similar to the one you want to build, you can try with templates: oftentimes companies or OSS organizations release their own templates for applications (e.g. [chat-ui](https://ui.llamaindex.ai) as chatbot template by LlamaIndex) that are easily pluggable and vastly customizable: using a template often requires more work than just forking a working project, but the result gains points on the side of personalization.

If you really can’t find anything that suits you, not even a template, than you can fall back on scaffolds: I really like NextJS, so I often initialize my applications (included the cat feeding tracker) with `create-next-app`, but there are scaffolds for a lot of other frameworks that might better fit your needs!

## 2. Use tutorial code

When you start building the application and you look at the cursor blinking at the beginning of an empty script, it is very easy to feel lost: this is why, whenever I start actually coding (after finding a project, a template or a scaffold), the first thing I do is to look for tutorials.

Given how my brain works, tutorials are much more of a fit for me than the actual documentation: most of the times documentation has many explanations and few code, whereas tutorials have less explanation and are much richer in code.

In this sense, I often find myself copying and pasting tutorial code and then modifying it to adapt it to my needs: for example, to build my cat feeding tracker app I use Supabase as a database, and they have an awesome tutorial section well embedded within the documentation, so it was very easy to [set up authentication](https://supabase.com/docs/guides/auth/server-side/nextjs) and to [hook the database table](https://supabase.com/docs/guides/getting-started/quickstarts/nextjs) to the backend of my app. Also for the frontend I exploited a treasure of well-curated and open-to-everyone resources: [shadcn/ui](https://ui.shadcn.com) components guide, which is extremely rich in examples and in customizable code.

## 3. Use AI wisely

AI is a great resource for programmers, but when you want to learn it can be easily a blocker: my biggest error a year ago was basically referring to AI at the minimal difficulty, and then just copying and pasting the code without actually learning anything. With a little bit of self-analysis, I can now see why I did that: I did not trust myself enough to try things out and I feared to make errors, and I feel like many other young developers find themselves in the same situation, underestimating themselves and thus trying to use the AI shortcut.

When I decided to build the application this weekend, I told myself that I would have used AI in only two cases:

- **Repetitive refactoring of the code**, meaning when there is a refactoring task that I know how to do, but that would take too long to type out, so I just give AI detailed instructions of what I want and wait for the result - most of the times I do not need to touch the refactored code again
- **Advancend implementations**: since I am relatively new to the frontend world, I often do not know how to do advanced things. Sometimes searching on Google is the best way to solve problems, but most of the times those advanced implementation are very specific, and web search might not return the exact result you want: this is when I ask AI to help me, and try to understand what is behind that help.

AI assisted coding speeds up my productivity now, but it wasn’t always like that: when I used ChatGPT or Gemini oftentimes I found myself in a debugging hole with more problems than my code had before, so I really encourage to choose your LLM wisely. For frontend tasks, for example, I mainly use Claude, although recently I started also chatting with [v0](https://v0.dev), especially for more complicated problems or implementations.

---

I hope you found these suggestions useful and, if you try them and have feedback or if you have some more tips and tricks, please feel free to share them!
