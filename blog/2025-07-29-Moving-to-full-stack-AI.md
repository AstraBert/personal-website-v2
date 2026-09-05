---
publishDate: 2025-07-29T00:00:00Z
author: Clelia Astra Bertelli
title: Moving to full-stack AI
excerpt: Reasons why I believe the future of AI is full-stack.
category: Coding
tags:
  - python
  - coding
  - ai
metadata:
  canonical: https://clelia.dev/blog/2025-07-29-Moving-to-full-stack-AI
---

## Twilight of the Python Idol

For the longest time, python has been **the** language of AI: you needed to master PyTorch, TensorFlow, NumPy, scikit-learn and many more libraries in order to succeed in the field.

Don't get me wrong - python is still the most largely used language to build AI applications, but it has been moving towards something different nowadays: we're slowly abandoning the idea of building neural networks from scratch or end-to-end ML pipelines, and we're exploiting more and more API clients, frameworks and protocols that allow us to connect, use and expand AI models served by tech giants such as OpenAI, Google, Microsoft or Meta.

It is at this point that AI development is turning into development with AI: most of people do not build AI, but use it to power their applications.

We no longer run AI models in the backend of industrial-grade systems, we serve them as a core part of many modern and user-facing applications: and we need AI to seamlessly integrate with any fronted, we need plug-and-play alternatives that you can easily fit with dynamic and captivating web apps.

Python is essentially a backend language - and that's why it is losing its role of king of AI languages.

Yes, there is the possibility of building and shipping AI powered applications in python backend-to-frontend, but (despite the rise in popularity of frameworks like [gradio](https://gradio.app) or [streamlit](https://streamlit.io)), these apps are not as well-designed, fluid and modern as the ones you can build with Next, Express, React, Vue or Vite.

## The Dawn of Vibe Coding

This is the main reason why players like [Lovable](https://lovable.dev), [warp](https://warp.dev), [Bolt](https://bolt.new) or [GitHub Spark](https://github.com/features/spark) are exploding in popularity and on the verge of today's hype (with Lovable having just surpassed [1 billion dollars in valuation,](https://www.linkedin.com/posts/antonosika_today-lovable-raised-200m-at-a-18b-valuation-activity-7351665204838985728-LJs6?utm_source=share&utm_medium=member_android&rcm=ACoAAEfb-jMBM3xMNEfT4G8yoAF0-YBI7UQSliQ) becoming the first vibe-coding unicorn): people don't just want proof of concepts, they want fully functional applications with user management and authentication, a visually appealing UI and a seamless UX.

The problem with this new approach proposed by vibe coding solutions is that they are often too centered on the fronted and they completely obliterate the backend, with some scandals that emerged related to their fragility and their security issues (like you can see [here](https://x.com/mattppal/status/1902819250395549811?t=FghLJFJY37DH0msDV4IcVg&s=19) and [here](https://x.com/jasonlk/status/1946069562723897802?t=qwpV4FbZeMNJBzZjJemVNg&s=19)).

So, what should we do?

Simple: focus on **full stack AI stacks.**

## The Advent of Full Stack AI

### TypeScript

Companies like [Vercel](https://vercel.com) or [LlamaIndex](https://llamaindex.ai) have been offering for some time TypeScript alternatives to interact with AI (respectively [ai-sdk](https://v5.ai-sdk.dev/) and [LlamaIndexTS](https://ts.llamaindex.ai)): those are designed exactly to allow you to build full-stack applications in one language, without having to switch between a python backend and a JavaScript frontend.

The future lies actually here: full stack frameworks such as Next or Express can easily encapsule APIs, beautiful pages and dynamic interactions, as well as user management and authentication.

But this is not the only point: TypeScript is a great coding language because of its built-in type checking and validation functionalities - but also for being object-oriented and easily pluggable into many different frameworks.

Also, TypeScript will become faster, since it has been announced that it will be migrating its compiler to [Go](https://github.com/microsoft/typescript-go).

### Ruby on Rails

If you're not a fan of TypeScript, and especially if you come from python, there is another very under-explored alternative that can be very promising for full stack development: Ruby on Rails.

Many unicorn startups like Shopify and AirBnB - as well as big companies like GitHub - are built on RoR, which proved to be the perfect language for fast and scalable applications.

With Ruby on Rails you can generally build CRUD-based apps, meaning app that are built on performing operations such as creation, update and deletion of instances within a database: and if you think about all the products from the companies we mentioned before, they can be boiled down to these three main operations.

You won't the traditional AI chatbot, then, but maybe you can create something even more powerful: imagine a smart to-do app with AI-enhanced tasks or a prioritization algorithm that is based on decisions from language models, or a content management system that can be optimized through AI use, or an educational platform that can be enhanced through AI-powered personalization.

Ruby is already integrated with some AI clients, such as [OpenAI](https://github.com/openai/openai-ruby) or [Anthropic](https://github.com/anthropics/anthropic-sdk-ruby), but it is obviously far from being as complete as python or TypeScript/JavaScript - so yeah, it is promising but it still has a very long way to go before actually becoming competitive.

## Conclusion

Python was my first programming language and python is still the language I am most comfortable and I write most of my code with.

Yet I have to admit that, unless exceptional things will happen on the side of python-powered frontend development, in the future development with AI will focus more and more on languages that are 100% full-stack, like TS or Ruby… So better starting learning and trying them out now!
