---
publishDate: 2025-08-19T00:00:00Z
author: Clelia Astra Bertelli
title: Porting to Go
excerpt: Why am I moving more and more to Golang for my coding projects?
category: Coding
tags:
  - go
  - coding
  - programming languages
metadata:
  canonical: https://www.clelia.dev/blog/2025-08-19-porting-to-go
---

## 0. Introduction

Three or four months ago I started learning Go on [Exercism](https://exercism.org).
I found it a fascinating language, mainly for four reason:

- **Essential design**: Go has only 25 keywords, as opposed to other backend programming languages like Python 3 (38 keywords), JavaScript (45) Rust (53) or C++ (74).
- **Statical typing**: unlike Python or JS, in Go types stay static, but you don't need to declare them explicitly (you can use the walrus, `:=` , operator). This is extremely handy: if you variable changes types or doesn't behaved as expected, it gets flagged immediately at build time.
- **Compiled**: Go is a compiled language, which means that, unlike Python (where building and running are combined when you launch the script), build time and runtime are separated. The build process produces portable executables that people can just launch on their machines. Also, Go was designed so that its compile time would be drastically lower than the one of C, and it is also lower than more modern languages like Rust
- **Ecosystem**: Go has an all-in-one tooling ecosystem, that uses one command (`go`) to do everything, from building to installing packages to testing. Coming from python (where we're still deciding between pip, poetry and uv), this is a blessing.

For these and other reasons which we'll touch upon throughout this blog post, I decided I will slowly but steadily move towards backend development in Go, porting both existing and new projects to it.

## 1. The pros of Go

Other than the ones I outlined at the beginning, Go offers several benefits (at least benefits for me coming from python) that convinced me to get into it:

1. Go is fast - and I don't mean it only on the build/runtime side. Yes, Go has an enhanced performance in respect to Python, JavaScript or TypeScript, but at the same time there are many more languages designed to be even faster and better at runtime, like C++ and Rust. What I mean by “fast” is in terms of developer velocity: how much does it take for you to start building complex code and projects in Go? If you're a fast learner and you dedicate a lot of time to it, some days, in the worst case some weeks. I had to learn C for a university course in my first year, and it took me months to be, in the end, able to create file-reading programs and knowing how to implement bubble sort. Developer velocity matters: obviously, Go is not as easy as Python or TypeScript, but it offers the right mix of DevX and performance.
2. Concurrent programming with Go is easy-ish. Async programming in python, the closest to concurrency, is very convoluted, error-prone and often very difficult to debug, between thread locks, killed tasks and pending coroutines. Imagine my reaction when I discovered that dispatching routines in Go just took `go` and a couple of extra helpers like the worker group. Disclaimer: I know that concurrent programming can still be highly complicated with Go in some advanced applications, but with python it would be even more hellish in those cases.
3. “A low-level language with a garbage collector?!” One of the biggest challenges for me when learning C was memory management: it slowed me down, it felt useless for what I was doing and it just introduced layers of unnecessary complexity and errors. Manual memory management is pretty much a given in all low-level languages like the C family or Rust - but not for Golang, which is an extremely useful pro for the language.

## 2. The cons of Go

It is really interesting: Go can easily be a double edged sword. Its garbage collector can be a performance bottleneck, its simplicity and lack of complex abstractions can lead to spaghetti code, and often misses mechanisms that are more straightforward to implement in other languages (inheritance, classes, more flexible typing, decorators…).

It's true that Go is a fast language, both in terms of performance and of developer velocity, but still it's not the easiest language to learn (those might be python, JS or TS) or the best performing one (those might be C++, Rust or Zig).

The last two cons deal mostly with the popularity of the language: Go ranked 13th in the [Substack Survey 2024](https://survey.stackoverflow.co/2024/technology#most-popular-technologies), with an adoption around 13.5%, so it is not the most widespread language, which deprives a developer of the benefits of a big and well-established community such as the JS/TS or the python one. The second con in this sense is the AI space: despite the most important LLM providers having their own SDK and the ever-growing interest in the language for building [AI-powered applications](https://youtu.be/E4V1c2SoO-A), the AI landscape is widely underdeveloped compared to Python or TypeScript.

This last reason is also why I decided to create [workflows-go](https://workflows-go.org), a package to build event-driven workflows in Go, especially for AI applications.

## 3. Why not Rust?

One of the most asked questions when I announced the coming of this blog post was: “Why not Rust?”. And I totally get where the question is coming from: at the end of the day, Rust offers similar benefits to those that Go has, while being memory safe and far more performant.

Well, the point for me for not choosing Rust was simple: I do not need extremely well performing applications, I simply need to speed up mine and make them more scalable and easier to deploy, and Go does that well without needing me to manually manage memory, write tons of type annotations and learn complex low-level language logic.

Lastly, Go is way easier to learn and better aligned with my way of thinking as a python and, in general, as a backend developer.

## 4. Conclusion

To conclude, my overall take on porting some of my recent and future projects to Go is that it will allow me for more velocity and scalability, as well as ease my development flow in terms of CI/CD (Go has a great tooling ecosystem in that sense).

---

I hope you liked this blog post, and if you want to share your take, please feel free to reach out on [one of my platforms](https://link.clelia.dev)!
