---
publishDate: 2026-04-07T00:00:00Z
author: Clelia Astra Bertelli
title: Writing a CSV Data Loader for TypeScript in Rust
excerpt: Commentary of my ongoing journey into building a Rust native addon for Node
category: Coding
tags:
  - rust
  - typescript
  - coding
metadata:
  canonical: https://clelia.dev/blog/2026-04-07-writing-a-csv-data-loader-for-typescript-in-rust
---

Not much time ago, I was talking to someone about TypeScript and they mentioned the fact that TS does not really have many CSV parsing packages that can convert data in a tabular format (like Pandas or Polars for python).

I know TypeScript is not supposed to be a language for data science and machine learning, but, since working with [LiteParse](https://github.com/run-llama/liteparse) (a document parsing library), my perspective on the potential of TypeScript for data processing has definitely changed, that’s why I challenged myself to create a performant CSV data loader for TS.

The direction I took, though, might sound odd to someone: I decided to write the core code in Rust and cross-compile it with [napi-rs](https://napi.rs), instead of writing the CSV parser in pure TypeScript/JavaScript.

There were two main reasons behind my choice:

- Rust is a much more data-oriented language, which can make I/O and data transformation operations faster than JS runtimes. Plus, I am determined to upskill as much as I can with Rust, so that made it even more compelling
- The `napi-rs` ecosystem is mature, offers extensive and advanced cross-compilation support, and its templates are extremely rich (fully bootstrapped with linting, formatting, testing and benchmarking scripts).

Both these reasons made writing the CSV parser in Rust simply more convenient, especially since I wanted to make it as performant as possible.

Now that you understand the reasons behind choosing Rust, let’s dive right into the iterations that brought sunbears to its final form, how I measured its performance and compared it with existing tools.

## First - inefficient - iteration

In my first iteration, the main purpose was to maintain flexible typing for the CSV columns, so I created this fat enum to hold each CSV record:

```rust
#[napi]
pub enum CsvValue {
	String(String),
	Float(f64),
	Integer(i64),
	Boolean(bool),
}
```

Which then converted into the following `DataFrame` structure:

```rust
#[napi(object)]
pub struct DataFrame {
	columns: HashMap<String, Vec<CsvValue>>,
	len: u32
}
```

The main problem with this approach was in the numerous allocations the CSV parsing code made. First, it read CSV records through the [csv crate](https://docs.rs/csv/latest/csv/index.html), then it parsed each record (allocating it as a `String`) into a `CsvValue` (with some more string allocations in the conversion logic). To top it all off, type inference and casting was performed for each record of each row, multiplying allocations and data conversion workloads.

The other main problem with the implementation was the use of hashmaps, since I was using one to hold the CSV records, one to hold the index → column name relationship and one to hold the column → data type relationship to compare the inferred type of a record with the current type of a column. I was accessing the map holding CSV records for each row, using the `get_mut` method on the vector associated with the column and pushing new records to the mutable vector reference. I was also getting the datatype hashmap for every record to compare and adjust typing (e.g., from integer to float or from integer to string). This meant a lot of back-and-forth from memory, as well as using hashing in the hot path, instead of the direct, index-based access that a Vec could offer. Here is the “hot path” implementation:

```rust
for (i, s) in res.iter().enumerate() {
 let col = &col_idx[&i];
 let mut value = CsvValue::new_from(s.to_string());
 if let Some(d) = dtypes.get(col) {
     if d == &DataType::Integer && value.dtype() == DataType::Float {
          dtypes.insert(col.to_owned(), DataType::Float);
     } else if d != &DataType::String && value.dtype() == DataType::String {
          dtypes.insert(col.to_owned(), DataType::String);
     } else if d == &DataType::String && value.dtype() != DataType::String {
          value = CsvValue::String(s.to_string());
     } else if d != &value.dtype() && d != &DataType::String && value.dtype() != DataType::String
     {
          return Err(anyhow!(
            "Line {:?} has type {}, expected {} for {}",
            i,
            value.dtype(),
            d,
            col,
          ));
      }
 } else {
    dtypes.insert(col.to_owned(), value.dtype());
 }
 let vec = columns.get_mut(col).unwrap();
 vec.push(value);
}
```

I benchmarked the cross-compiled TS code with tinybench, and it took up to 2 seconds to read a 1.000.000 rows CSV: it might seem fast at first (especially if you are accustomed to Pandas), but I can assure you that, for Rust, this is extremely slow (Polars can do the same in 0.2s).

### Second iteration

> All the optimizations you will see from now on were the product of my discussion and pair-programming with Claude, although I always forced myself to understand the code and the optimization choices before including them in the codebase

For the second iteration, I went for a paradigm shift in the data structure. Instead of using a vector of fat enums representing each CSV record, I decided to go with the closest data structure to a typed array I could get to:

```rust
#[napi]
pub enum ColumnData {
    Float(Vec<f64>),
    Integer(Vec<i64>),
    Boolean(Vec<bool>),
    String(Vec<String>)
}

#[napi(object)]
pub struct DataFrame {
    columns: HashMap<String, ColumnData>,
    len: u32,
}
```

This meant doing a double-pass of the data: the first one to collect them into a `HashMap<String, Vec<String>>`, as well as determine the data type of each column (inferred from the first record, as Polars does in strict mode), the second one to validate and produce the typed `ColumnData` based on the inferred column data type in the first pass.

This brought down the total benchmark time from 2s to 1s on 1.000.000 rows, definitely a good start, but more things could be optimized.

### Third iteration

With the third iteration, Claude made me realize that I didn't really need to hold everything in memory as a hashmap: since the columns always come in the same order, I could easily use a vector and access the column name by index, eliminating hashing overhead for the column data, and reducing it by swapping the column name with its numeric index for the column → datatype hashmap.

I also tried my best to use `&str` anywhere instead of owned `String`s, to avoid string allocations, but had to opt for wrapping the string data into a `Box<str>` smart pointer, to prevent a lifetime-related bug (`&str` were obtained while iterating on CSV records, but were later used - when the records they pointed to were already dropped - to build the DataFrame).

The time taken to read a 1.000.000 rows CSV dropped to 0.7s, which already achieved my goal of sub-second speed… More improvements were still to come, though.

### Serendipitous optimizations

When trying to use the methods defined in the `DataFrame` struct implementation, I realized that those methods hadn't been cross compiled to TS as I was using the `napi(object)` macro, which turns the struct into a plain interface.

After a short trip to the napi-rs docs, I opted for making DataFrame a TS class, adding a constructor, getters and methods.

Despite this change was intended for DevX, it ended up improving performance: as the napi-rs docs themselves note, using the `napi(object)` macro rule comes with some FFI overhead in the translation to JS, as the object is cloned (not copied) from the Rust struct. Switching from Object to Class brought the total time taken for reading a 1.000.000 rows CSV to 0.4s.

Serendipitous optimizations weren't done yet, as I discovered that I had some extra dependencies (serde and serde_json) and an extra feature flag for napi-rs (serde_json) that I was planning to use at the beginning but ended up not using, forgetting to clean them up from my cargo dependencies. Removing them not only made the compiled add-on slightly lighter, but also improved performance, bringing the time needed to read 1.000.000 rows to 0.3s.

### Evaluation and Comparisons

Since `sunbears` was to be used with TS, I decided to perform all the benchmarks in that language.

To evaluate the performance of my library, I used tinybench, reading CSV files with increasing length (100, 1.000, 100.000 and 1.000.000 rows).

The data, based on 6 columns (two string columns, two float columns, one integer column and one boolean), were randomly generated before each benchmark.

In order to understand how the tool compares with state of the art CSV data loaders, I set up two other evaluation scripts:

- One for Pandas and Polars, the most popular tools for python data analysis, which used the built-in `timeit` module to calculate the average execution time of functions
- One for the `csv` package, among the most used libraries for CSV reading and generation in JS/TS environments, using the same tinybench setup already defined for `sunbears`

All these scripts were set to read the same randomly generated data.

As I reported before, `sunbears` takes 0.3s to load a CSV with 1.000.000 rows, which is:

- ~4x faster than `csv-parse` (1.2s)
- ~1.5x slower than `polars` (0.2s)
- ~10x faster than `pandas` (3s)

On one hand, the comparison results with `csv-parse` (a JavaScript-native package) and Pandas (written in python) are expected: Rust I/O and data ops are generally faster than the ones in Node or in the Python VM, and the FFI overhead for Rust → TS is minimized by napi-rs and by the optimizations we saw before.

On the other hand, the performance gap with respect to Polars can be explained with the fact that Polars is both written in Rust and a much more mature tool than `sunbears`, with more space for optimizations and edge case handling.

### Conclusion

Building `sunbears` (which is still work in progress) has been a true rollercoaster experience: the first iteration seemed very solid, and got slashed by the benchmarks, so I had to refactor the code to improve performance with the second and third iteration, and each gave me increasing satisfaction with the performance gains.

Beyond the rollercoaster, though, the experience was highly educational, as I had the chance to see low-level optimization in action, as well as got to tinker more seriously with napi-rs, forcing me to find solutions that were JS-compatibile without sacrificing too much of the Rust features and performance.

If you have some experience with Rust, I highly recommend trying this out: the only things you will need will be an idea and a benchmark suite (possibly also with comparisons to existing tools) that allows you to validate the execution of that idea!
