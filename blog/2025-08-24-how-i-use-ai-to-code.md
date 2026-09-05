---
publishDate: 2025-08-24T00:00:00Z
author: Clelia Astra Bertelli
title: How I use AI to code
excerpt: A brief overview of how I integrated AI in my dev flow, as well as of the tool I am using.
category: Coding
tags:
  - ai
  - coding
  - software-development
metadata:
  canonical: https://www.clelia.dev/blog/2025-08-24-how-i-use-ai-to-code
---

AI coding agents are the hype of the moment - and how could they not be? They promise to be smart, to build fast, to iterate even faster and to deliver working and elegant solutions to all your problems.

Vibe-coding has entered all our lives, in a way or the other, and everyone talks about it as the current big thing in tech and the ultimate bridge between technical and non-technical people when it comes to bringing ideas to life.

In this context, I asked myself: why don't I write about my general coding flow with AI and the tools that I've been using?

As a disclaimer: I am not an AI power user, I don't have highly optimized coding workflows or dozens of sub-agents burning hundreds of thousands of tokens every day for me. I'm just a girl who happens to have found a way to integrate AI in her flow, and wants to share advice coming from her practical experience: with this being said, let's dive in!

## My Dev Flow with AI

Let's start from the beginning, from the idea: when I have an idea for something, or when I have to write some code that I do not immediately know how to implement, I first of all stop and think. I think about what I am trying to achieve and what I need to achieve it, and then I start my research.

Generally I search the web, skim through GitHub repos from other people to see their implementation or to find useful resources for my project, and finally, if I can't find anything useful on that side, I ask AI to give me hints on where to look, what to use or how to design the project.

Once I'm out of this phase, the real building starts: building for me it's first of all sketching ideas, designing the project on a high level, creating the backbone of it.

I generally start from the backend and then move onto the frontend: this is simply because, being a backend-first engineer, it is easier for me to design the frontend around the needs of the backend.

Once the first sketch of the project is implemented, I test it and see if I like the results.

This test phase is generally the one where issues and ideas on how to improve the project emerge - and generally these things require more complex implementations.

Whenever there is a more complex implementation, I first of all think about it and spend some time designing it in my head, then I take a stab at it. It is at this point that generally AI comes in: once I am done with my implementation, I ask AI to evaluate it and tell me whether or not it works, if there is something I can do better and if there are any errors. I don't have any magical prompt - I just copy-paste the code, give a bit of context on what I am trying to achieve and ask some plain questions like: “Is this implementation correct?”.

> _The most important thing for me, when using AI, is that I do not offload the ideation/design phase to AI: I have a clear idea of what I am building, what it should look like and what outputs are supposed to come out._

Once I integrate AI’s code into my project, I test it: if there is an obvious flaw I can fix, I do it, otherwise I get back to the AI with the bug (generally an error traceback and/or a screenshot of my app) and iterate on the solution.

This is pretty much it: once I'm satisfied with the code, I push it to GitHub and, occasionally, deploy it to a live demo/prod application.

I mentioned “AI” several times and I kept it generic on purpose, because now I want to give you a quick overview of the AI tools I use to assist myself with coding.

## My Tools

### Claude

I use Claude (the LLM app, not Claude Code) daily: Claude is my go-to for any programming question, but I feel like it is especially valuable for languages like TypeScript and Go, and for complex python questions.

I generally give Claude my code and ask for clarification, error explanation, improvements or design tips (especially for frontend design): I generally iterate two or three times until I get to the code I want, unless it is a simple task (like centering a div) - in that case one-shot generation works more than fine.

### GitHub Copilot

I use GitHub Copilot inside of VS Code, mostly to refactor my code when the refactoring is just mechanical (like changing the arguments of a function in all the occurrences in my script) or when I need docstrings/annotations for my functions. I tend to use it mostly with Python, but sometimes I also use it for TypeScript.

My go-to model for GitHub Copilot is GPT-4.1 (I'm a fan girl, I can't do anything about it🤷‍♀️)

### v0

v0 is a blessing for my frontend and full stack development.

I can easily say it feels like the most powerful assistant I've ever worked with in terms of designing, debugging or correcting frontend apps: even better than Lovable (although their scopes are slightly different).

I use v0 especially for UI/UX design questions: I sketch the frontend with all the components I need to fit the backend, then I go to v0 and ask for help on styling. Also, it is an invaluable resource for developing with NextJS in a React environment using shadcn/ui: every time I have a doubt related to a component or how it works, v0 generally knows the answer.

### Gemini and ChatGPT

My use of Gemini and ChatGPT is near-zero for coding-related task, but still I get to use them sometimes, especially as a replacement of Claude when I run out of credits.

ChatGPT, in my experience, offers convoluted solutions and extremely verbose explanations that oftentimes I lack the time or the will to read, which in turns leads to an impoverished DevX because most of the times ChatGPT’s solutions _can_ work, you just have to carefully read the instructions. Still, I mostly use it for simple-to-mid-level problems, and especially for python.

Also Gemini has the flaw that it produces very long instructions along with the code that should help you: I have to say that a lot of times Gemini fails to understand my problem, or to solve it, but it is good for ideation or for sketching things from scratch, and I used to ask for its help a lot some time ago to get started with full-stack applications. Today I mainly use it as a replacement for Claude on TypeScript/Go questions.

---

These is basically how I use AI for coding: I know many things are easy to disagree with, and if you have other opinions please feel free to share them with me [on one of my social pages](https://link.clelia.dev)!
