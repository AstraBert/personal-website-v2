---
publishDate: 2026-01-18T00:00:00Z
author: Clelia Astra Bertelli
title: Rust - First impressions
excerpt: My first impressions from my journey into Rust.
category: Coding
tags:
  - rust
  - coding
  - software-development
metadata:
  canonical: https://clelia.dev/blog/2026-01-18-rust-furst-impressions
---

# Rust: first impressions

At the end of 2025 I started experimenting with Rust: in this blog post I take a look back at my (very short) journey into the language and give my first impressions.

## “Rust is ~~not~~ too hard for me”

I made the resolution of learning it at the beginning of 2025, but the rumors on how hard it is to learn the language got to me before I could really dive deep into it, so I abandoned the idea.

For someone like me, with no CS background, self-taught developer, who knows mainly high-level languages (Python, JS/TS) and Go, hearing many tech content creators I follow saying: “Rust is hard, you should know some C/C++ before getting into it” was a total motivation killer.

Fast forward to the end of 2025, I stumbled across the [Rust Bootcamp by Francesco Ciulla](https://youtu.be/tgJ8d9yQtKY), a very condensed, one-hour video that gets you up to speed with the basics of Rust. I listened to it on a Sunday morning and, although I wasn't expecting to understand much, I was actually able to follow along pretty well.

At that point, I said to myself: what if the Rust I need is not the highly-optimized, kernel-level code that everyone is talking about, but just another tool I can put in my dev toolbox by learning how to build things I already do on a daily basis, like CLI apps or APIs? In the end, design and architectural patterns are the same, no matter the language. So, I did what I always do when I approach something new: experimenting.

## What I've been doing

Up to now, I've built some small projects with Rust to get familiar with the language:

- [**workspyce**](https://github.com/AstraBert/workspyce): a CLI tool to manage uv workspaces, with which I could practice file operations, the shell interface and regex patterns in Rust
- [**personal-wiki**](https://github.com/AstraBert/personal-wiki): a web app that can turn markdown into HTML wiki pages. Built on top of Axum (API layer) and Turso (database), I had the possibility of experimenting with async Rust, as well as getting familiar with the Axum ecosystem for things like CORS and rate limiting.
- [**postgres-dv**](https://github.com/AstraBert/postgres-dv): a CLI app to view data in a Postgres database through SQL queries, and rich-render the data to terminal. Helped with async Rust and learning about SQLx.
- [**arxiv-cli**](https://github.com/AstraBert/arxiv-cli): a CLI app to download papers from arXiv, mostly important to learn ser/des operations in Rust, as well as `reqwest` .
- [**codemd**](https://github.com/AstraBert/codemd): a CLI tool to extract code from markdown and run it with custom commands.

> Building for me is the best way of learning, that is why I am striving to build as much as I can, but it's my personal preference: if you are more comfortable learning from books or tutorials, please don't feel like you're missing out or falling behind! Everyone learns and builds at their own pace :)

## My impressions so far

### What I like

- Explicit error messages from the compiler/borrow checker, which most of the times point you to the solution (rust-analyzer is the extension I am using on VSCode and Zed)
- Clean `Result<T,E>` (error as values) and `Option<T>` (None/Some syntax is much appreciated) interfaces, combined with powerful match statements that have to be exhaustive so that you don't forget to tackle all the cases
- Function and method declarations are python-like, structs and traits are go-like (best of both world)
- Immutability by default (you have to specify the `mut` keyword in order to allow mutability): this is a great way to avoid unnecessary mutations that can introduce runtime bugs
- Extremely versatile (backend, frontend, CLI apps)
- Sheer runtime speed
- Cargo ecosystem is a joy to work with (you can build, run, test, format, lint…)

### What I don't like

- Extremely limited standard library, which often needs external crates to carry out basic operations (for serdes operations, e.g., you need generally 2 packages!). This results in small projects (like codemd) blowing up to tens of dependencies.
- Long compile time: for someone who's used to lighting-speed compilation with Go, compiling 100+ dependencies for one project in Rust feels like forever
- Async that needs a separate runtime: in python, async works out of the box and has `asyncio` (predominantly used module for managing async code) in its standard library, whereas in Rust (probably due to the fact that async support is more recent) you need to install an external runtime, like Tokio.
- Private functions/structs/traits by default: I've been surprised a couple of times that some functions or structs defined in my crates could not be imported, just to remember that I forgot the `pub` keyword. Coming from Python, Go and TS, this can be a little annoying at first, since I tend to often forget to specify that a function is public.
- Bonus: forced snake_case is a tad annoying, especially because Rust has such a camelCase vibe :)

## Rust and other languages

I think that developers naturally tend to compare languages in a “battle-like” way. I believe that's not the right thing to do: every language has its strengths and weaknesses, and pretending that a language is better than another is just a way to justify our own laziness in not wanting to experiment with yet another language.

### Rust and Go

Rust and Go have a different philosophy: Go is made to be simple and to be understood at-a-glance, whereas Rust sacrifices a little bit of that readability and simplicity in order to have compiler and runtime-safe code.

Programming in Go for me feels more natural: I like the fact that it's essential and clean, and I find its standard library to be extremely powerful, while not being as wide as python’s.

Unfortunately, Go isn't as performant and runtime-bugs-free as Rust is: that is exactly why knowing both can make you a better programmer. You can try to apply Go’s readability and simplicity principles to Rust, to create some cleaner and more understandable code, as well as try to think about lifetimes, ownership and borrowing when moving data around in Go.

Besides that, I feel like Rust and Go might be more similar than one might think: they are both statically typed, they both allow for general (traits and interfaces) and implementation types (structs), they have generics, powerful data structures, low-level control over memory without needing manual allocation, a clean centralized ecosystem (Rust around cargo, Golang around go), and probably many more things I am forgetting.

### Rust and Python

Despite being often painted as complete opposites due to the big performance gap and the fact that python is a dynamically typed language, I find Rust and Python being more similar than I thought, mostly because of the syntax: function definitions, the ways they deal with object-oriented data structures (classes in Python, traits and structs in Rust), the type hints…

Obviously, writing python is still incredibly easier than writing Rust, because it really feels like the closest to natural language, it has a vast standard library that you can do anything with, and, most of all, does not complain about lifetimes or borrowing.

Obviously, that is also the downside of python: even with severe type checking, it does not mean you're avoiding runtime bugs, and its simplicity is often a trap: errors sneak right where you don't expect them.

If I could _borrow_ (pun intended) anything from rust to port into python, I would take two things:

- The toolchain (`cargo` is amazing and does tons of stuff out of the box)
- Errors as values: Rust treats errors as values (most of the times, although you can always opt out of it with the infamous `unwrap` ), but in a less verbose way than Go does: this means you know when some code can produce an error, and you can act accordingly (premature return, graceful shutdown…), whereas with python `try...except` statements are never guaranteed to work, unless you catch all generic exceptions, at which point you can't really customize your software’s behavior based on the error type.

### Rust and Typescript

Despite being a high level programming language, Typescript has managed to successfully introduce static typing, exactly like Rust does. Besides that, both languages are extremely versatile: you can build backends and frontends with both of them, but you can also easily write CLI applications.

Beyond the similarities, tho, I surprisingly find Rust easier than Typescript: for me, TS can become unreadable quickly when a codebase (and thus its complexity) grows, plus I feel like I can't really write clean code with it (but maybe it's a skill issue).

Also, TS ecosystem is a jungle of tools (given that there are four major package managers alone out there), whereas Rust’s one is centered around cargo and a handful of well-crafted tools like Clippy and rustfmt.

## Conclusion

I think that, from everything you read so far, you can easily infer that I like Rust, and I am planning to continue building with it until I reach a good level of mastery of the language, exactly as I did with python, and as I am still doing with Go and TS.

Does that mean I am going to abandon other languages? Absolutely not: I am planning to build more and more with Go, and I will keep tinkering with Python and TS at work and, sometimes, also in my free time.

If you're curious about Rust, I feel like you should give it a try: yes, it's a little hyped and I know you might feel like falling into yet another hype trap, but from my perspective most of that hype is justified and Rust is definitely worth a go.
