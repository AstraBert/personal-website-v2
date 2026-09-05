---
publishDate: 2025-08-11T00:00:00Z
author: Clelia Astra Bertelli
title: Do tests hinder or ease development?
excerpt: My opinion about tests, trying to explore whether they are an obstacle or an essential component for a development flow.
category: Coding
tags:
  - tests
  - coding
  - open source
metadata:
  canonical: https://www.clelia.dev/blog/2025-08-11-do-tests-hinder-or-ease-development
---

I was recently trying to add some changes to the TypeScript repository for LlamaIndex, and part of these changes involved migrating from legacy `zod` to `zod/v4`.

I tried to change any part of the codebase that I thought was affected by the migration, and then the CI tests from GitHub Actions told me I missed some - so I proceeded to update also those. I was pretty much convinced I updated all affected code, but I was proven wrong: tests were still failing. Actually, a single test was failing.

I took upon the test and tried to tweak the code in several different ways until I simply gave up: the code responsible for the tests failing depended on the legacy `zod` because it was used by a third-party package, and the dependency conflict was unsolvable.

If it hadn't been for that test, I would've happily merged the PR and caused a pretty difficult-to-spot bug.

Fast-forward a couple of hours from that, I saw a [post on LinkedIn](https://www.linkedin.com/posts/itskevinjin_unit-tests-are-a-huge-waste-of-time-you-activity-7358514464104620032-NLDE?utm_source=share&utm_medium=member_android&rcm=ACoAAEfb-jMBM3xMNEfT4G8yoAF0-YBI7UQSliQ) stating that test-heavy teams have their development flow hindered by tests for features that often end up being dismissed a few weeks after being added: and, honestly, it made me question myself.

When I was building things for myself, and my work was pretty much used by only me, I didn't feel the need for tests: my idea was to experiment, add new features, break things, fix them fast, move onto another feature.

When I started coding professionally, and my projects and my profile got some more visibility, I could see why tests could be useful: it was a way to make sure, before even seeing it while running and debugging your code, that functions and classes were behaving as expected. That actually changed my coding flow: now I always add tests to my code - sometimes while I write the various modules, sometimes at the end of my coding session, when I have the bigger picture.

But what if those tests were really a blocking factor for my productivity? What if the time I spent writing tests I could've spent actually crafting new features for my products?

On the other side, I still ask myself: what if those features I could've added (instead of tests) broke my code, and that led to even more debugging and work to figure out what was wrong, while unit or integration tests could've told me from the very start?

I can see the point of those who say that tests significantly slow down their flow, because they are simply too many or they take too long: it's obviously a blocker to have hundreds of unit tests when you need to ship fast - but I can also see that, in a fast-paced environment, it is rarely the case that you have hundreds of unit tests.

After some thinking, I managed to get to a practical solution that I liked:

1. when you have a small, modular and clean codebase, it is easy to add unit, integration and end-to-end tests that cover pretty much everything
2. If the project is small but growing quickly, not intended for production but for customer feedback and iteration, having a set of light integration tests and some e2e tests might be the best choice: in this sense, you could see how well a new functionality integrates with the project without having to update tenths of other tests
3. If you're building within a community or a team on a large and shared codebase, then being test-heavy is the only path to production: you cannot ship something that is broken, not even that small detail that you think nobody would care about.

Oftentimes point (1) and (2) bring to point (3) in the end: everyone starts small, iterates and then gets to bigger, production-grade projects.

One last reason why, in my experience, tests are very important for larger projects is maintainability: we can talk about open source all we want, but if our code is just a melting pot of malfunctioning and untested parts, it won't go anywhere. Tests give you the vision for the code, they tell you why a certain piece was written and how it should behave: they're the navigation tool for bigger and shared codebases.

---

I hope my take on tests wasn't too controversial and, if you have any opinion you would like to share on the matter, please reach out to me on [one of my social media pages :)](https://link.clelia.dev)
