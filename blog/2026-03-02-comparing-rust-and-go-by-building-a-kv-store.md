---
publishDate: 2026-03-02T00:00:00Z
author: Clelia Astra Bertelli
title: Comparing Rust and Go by building a KV store
excerpt: A practical comparison of Rust and Go, with an overview of DevX and performance
category: Coding
tags:
  - rust
  - go
  - coding
metadata:
  canonical: https://clelia.dev/blog/2026-03-02-comparing-rust-and-go-by-building-a-kv-store
---

I recently had the idea to build an in-memory key-value store, and I was debating whether to use Go or Rust, so I decided to build it with both languages to compare the development experience and performance.

> All the code for this blog post can be found [in this GitHub repository](https://github.com/AstraBert/quache)

This blog post will compare Rust and Go on a more practical level: if you are interested in a high-level comparison, check out [this article I published some time ago](https://clelia.dev/2026-01-18-rust-first-impressions)!

## Design

For my KV store, I adopted the same design across Go and Rust:

- The atomic unit is an `Entry`, holding a value, a timestamp and, optionally, a time to live (TTL)
- Each entry is associated to a key within a hashmap
- Each hashmap is stored within a `Shard`, and locked behind a read-write mutex (allows many parallel reads but only one write at a time)
- One or more shards are contained within an array in the `KVStore` , following the static vertical sharing pattern (the number of shards cannot change)
- The `KVStore` keeps track of the shards dimensions, cleans them up from expired entries and regularly flushes the in-memory data to disk (data are stored per-shard and accompanied by an MD5-computed “integrity hash”)
- Cleanup and flushing are tasks executed at regular intervals by background processes
- The `KVStore` can be loaded from disk when restarted, and, while loading, the integrity hash is checked for each shard, to make sure data haven't been corrupted while flushing to disk (or later)

The KVStore is served behind a RESTful API, allowing to create/update new KV entries (`POST /kv` ), fetching the value associated with a key (`GET /kv/{key}`) and deleting an entry (`DELETE /kv/{key}`).

## Developer Experience

### Development Time

I wrote both implementation from scratch, and they both took approximately 4h30mins-5h, including writing tests, testing, debugging and iterating on errors.

While the duration wasn't too different, my reliance on AI help was: for Go it was minimal, whereas for Rust I needed quite some help in critical patterns, e.g. how to safely share data among threads through shallow copies of the KVStore struct for flushing and cleanup. It is then safe to say that, without AI assistance, Rust would've probably taken some more time.

### Ecosystem

For what concerns Go, the ecosystem to build a KV store basically all resides within the standard library: mutexes, algorithms to compute the CRC32 and MD5 checksum of data (the first for shard assignment, the second to generate an integrity hash), serdes operations, HTTP client and server… are all available without extra dependencies. The only dependencies I need to install were `testing` and Cobra, the most popular CLI framework for Go, which is a non-negotiable for me when it comes to command line apps (although I could've probably implemented the features with native stdlib code).

Rust has a much more minimal standard library (which I'm not the biggest fan of), and thus needs several external dependencies: Axum and Tokio for the HTTP server, Serde for serialization and deserialization, `anyhow` for smooth error management, libraries for checksum computing and some more development dependencies for testing (like `serial_test` and `tower`).

I personally prefer a bigger standard library, and I think Go has the perfect balance between the minimal Rust stdlib and the extremely vast selection of python built-in modules, but, to be fair, it doesn't affect the overall development experience that much: cargo is an awesome ecosystem management tool, which easily makes up for the less populated standard library.

### Testing

Testing is where Rust shines: for me, Go code is much easier to write in terms of pure business logic, but hard to translate into tests.

The `testing` library makes it a tad easier, introducing some nice testing primitives like asserts and mocks, but it doesn't still cover all the bases (although I am definitely not using it at its full potential, so probably it could make a bigger difference).

Rust, on the other hand, has built-in macros like `assert` and `assert_eq`, which make testing smoother and feel more native. This is a great advantage in terms of developer experience, which makes test writing faster and more pytest/vitest-like (that offer the best testing experience in my opinion).

## Performance

### Compilation time and binary size

Compilation time is blazingly fast in Go (0.69s), whereas for Rust it takes up to 7.2s.

Nevertheless, Rust optimizations result in a much smaller binary size (approx. 2.3MB) than Go (approx. 8.5MB).

### Stress Testing

The performance benchmark was focused on _setting_ keys, stress-testing the `POST` endpoint of the KV server with an increasing number of total requests (from 1.000 to 1.000.000, incrementing by a factor of ten each time): the requests where produced by [this Go script](https://github.com/AstraBert/quache/blob/main/requests/main.go) and spawned as concurrent goroutines, capping the maximum number of concurrent requests to 1000 to avoid overloading my CPU and memory. Each of the goroutines sends a POST request to the KV store server, using a `key-rand(1,100)` as key and `rand(1,100)` as value, and a TTL between 1 and 2 seconds.

It is important to notice about the design of the benchmark that, as the number of requests increases, the number of potential key substitutions increases: it is more likely that two random keys might be the same within 1.000.000 requests than within 1.000, and thus key substitution is more likely to happen instead of key insertion.

Here are the results of the benchmark for the **Go** server:

```
1.000 requests

Successful requests: 1000
Failed requests: 0
Success rate: 100.00%
Average response time: 28.29 ms
Total test duration: 43.260208ms
Requests per second: 23115.93

10.000 requests

Successful requests: 10000
Failed requests: 0
Success rate: 100.00%
Average response time: 14.68 ms
Total test duration: 161.525709ms
Requests per second: 61909.65

100.000 requests

Successful requests: 100000
Failed requests: 0
Success rate: 100.00%
Average response time: 8.95 ms
Total test duration: 960.156541ms
Requests per second: 104149.68

1.000.000 requests

Successful requests: 1000000
Failed requests: 0
Success rate: 100.00%
Average response time: 8.31 ms
Total test duration: 8.886698708s
Requests per second: 112527.73
```

And here are the ones for the **Rust** server:

```
1.000 requests

Successful requests: 930
Failed requests: 70
Success rate: 93.00%
Average response time: 26.84 ms
Total test duration: 10.008902167s
Requests per second: 99.91

10.000 requests

Successful requests: 9871
Failed requests: 129
Success rate: 98.71%
Average response time: 12.72 ms
Total test duration: 10.124296625s
Requests per second: 987.72

100.000 requests

Successful requests: 99871
Failed requests: 129
Success rate: 99.87%
Average response time: 7.56 ms
Total test duration: 10.0406955s
Requests per second: 9959.47

1.000.000 requests

Successful requests: 999863
Failed requests: 137
Success rate: 99.99%
Average response time: 6.85 ms
Total test duration: 18.033700917s
Requests per second: 55451.73
```

> It is important to notice that, in the case of Rust, the server produced the following error multiple times: `An error occurred while flushing to disk: Too many open files (os error 24)`, which presumably hints at a faulty implementation on my side that worsened the performance.

All in all, Go’s performance was considerably better.

As noted before, this is probably my fault for having a slightly buggy Rust implementation, but carries an important truth: you can implement performant services in Go (in this case, scaling to 100.000+ requests per second under load), and using Rust is not a guaranteed “out of jail card” when it comes to performance: you can still write suboptimal code, especially at the beginning (as in my case, I’ve been using Rust since the end of December 2025).

## Conclusion

There is no clear winner in this project: while Go offers faster development velocity, less reliance on dependencies and higher performance, it is more difficult to deal with tests and is less optimized during compilation, leading to a bigger binary size.

On the other hand, Rust development velocity is slightly slower (but can be enhanced with AI assistance) and we need far more dependencies (which means longer compile time), but strict borrow checking and ownership control not only make the program safer but also highly optimized (with a smaller binary size).

The difference in performance, though, reminds us that performance is never guaranteed with a specific language: you can always fall in the trap of writing suboptimal code, especially at the start, and being careful and self-critical over the written code is the best way to improve.

I'm more determined than ever to keep learning Rust and improving my skills with the language, as well as continuing to build with Go and upskill as a gopher: stay tuned because I have big projects in mind, for both Rust and Go!
