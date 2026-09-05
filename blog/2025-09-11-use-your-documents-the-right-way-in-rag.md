---
publishDate: 2025-09-11T00:00:00Z
author: Clelia Astra Bertelli
title: Use your documents the right way in RAG
excerpt: My tips on how to best leverage documents in your RAG pipelines.
category: Coding
tags:
  - ai
  - rag
  - data
metadata:
  canonical: https://www.clelia.dev/blog/2025-09-11-use-your-documents-the-right-way-in-rag
---

Over the past two and a half years, I’ve spent a significant amount of my life programming and, more specifically, building AI-powered software.

One of my first loves in this domain was RAG: the concept of being able to have an AI answering questions based on _my_ documents was fascinating. I saw it as a revolutionary perspective, especially in terms of personalized learning: I could build _my own_ knowledge base and ask AI any questions about it.

From my first ever projects, using [NucliaDB](https://nuclia.com/vector-database/) and [Pinecone](https://www.pinecone.io), to my more mature ones with [Qdrant](https://qdrant.tech), the main idea was always the same: building reliable knowledge systems.

The **data** have always been the _central theme_ of all of these projects: how to collect them, how to process them and how to efficiently provide them to the language model powering the knowledge system.

In this blog post, I want to focus on one specific thing: how to process the data, and, more specifically, how to process raw, unstructured documents the right way.

## Better Text Quality, Better Outputs

If you've ever tried AI frameworks, they often come with out-of-the-box support for extracting text from documents of various types.

In the beginning, I thought those tools were more than enough for creating a decent RAG pipeline: in the end, LLMs cannot distinguish between headers, code blocks, bold or italic text, right? Not quite.

If you compare an LLM processing raw text versus Markdown or another markup language (such as XML or HTML), you will see that there may be a difference in the quality of the response, and you may get better quality using markup languages as an input.

This is because markdown text, like other markup languages, uses a tag-based syntax to define its structure (with things like `##` to indicate a second level header or `**` for bold text): because markup languages are plain text, it is highly probable that language models had lots of examples of them to learn from during their training (which is based on plain text), and thus the models not only learned how to produce markdown themselves, but also to understand it.

So, if you turn your PDFs or, in general, unstructured documents into markdown, and then chunk them and store them as such, the retrieved context will be easier for the LLM to understand when it is injected into the query to augment the generation, and the quality will improve.

That's why you can't just extract text from PDFs with tools like PyPDF or PdfPlumber if you wish to get high-quality responses, but you often need to use a mix of Optical Character Recognition (OCR), agentic/LLM-based and metadata-based parsing techniques: this not only ensures you get more accurate and correct results (less errors, more complete text, compatibility with legacy scanned or handwritten documents), but it also means that you are often able to recognize and translate the structure of PDF text into markdown-like syntax.

So parsing your unstructured documents is key, and you need to do it right: at LlamaIndex, among our [LlamaCloud](https://cloud.llamaindex.ai) services, we offer [LlamaParse](https://docs.cloud.llamaindex.ai/llamaparse/getting_started), a state-of-the-art document parser with a wide and flexible range of customizable options that can help you get the best out of your documents, not only in terms of text, but also in terms of images and tables.

## You don't always need the full text

Most of the time we are convinced that the more data points we can store in our vector database (which translates to: the more text we can extract and process) the more accurate the retrieval will be.

This is not always true, and let's think about it through an example. You're building a support chatbot that can help customers of the restaurant you work for: you want to use menus, but they often come with some unnecessary or repetitive text (like the name of the restaurant, the location or other things): you just want to extract the name of the dishes and their ingredients, so you need some kind of named entity recognition (NER) algorithm to help you with that.

This is a crucial part: extracting text and linking it to a specific entity can not only enrich the metadata of the data points stored in a vector database (and thus give you more power with metadata filtering), but can also provide better contextual information overall, since you eliminate noisy and potentially misleading information.

At LlamaIndex we have a powerful solution to help you tackle this problem too: [LlamaExtract](https://docs.cloud.llamaindex.ai/llamaextract/getting_started), a text extraction agent that combines LLM guidance and OCR and can translate any unstructured document into a wide variety of well ordered and clean JSON schemas (from invoice details to scientific papers summaries).

## Images and tables can make the difference

In many enterprise documents, such as presentation decks and financial reports, text is accompanied by images or tables: ignoring them or, worse, messily extracting them with basic tools is a big error, since often they encapsulate crucial information to understand the context of the document and, without them, your LLM can't really grasp what is going on.

For this use case, multimodal parsing and extraction is key: you are able to get images and store them in your vector database, and query them as such, or you can take entire screenshots and use vision retrieval models to retrieve relevant contextual information starting from both text and image inputs (take a look at [how Qdrant did it with ColPali](https://qdrant.tech/blog/qdrant-colpali/)). Once again, multimodal parsing and extraction are available with LlamaParse and LlamaExtract, and, to cap it all off, LlamaCloud also gives you [Index](https://docs.cloud.llamaindex.ai/llamacloud/getting_started), a data indexing and retrieval that not only stores PDF or other text-based files, but can also parse and extract text and metadata from screenshots or, in general, images, enabling search across multi-modal sources.

## Your results are only as good as your data

I would summarize this blog post in three take-home messages, one for each section:

- You need good quality data if you want good quality outputs
- Bigger is not always better - sometimes selecting only the relevant parts of your documents is less noisy and less confusing than including them in full.
- Multimodal is the key to enterprise-level applications, where images and tables are often an overlooked goldmine of data.

---

These were my thoughts on using files the right way for your RAG applications: if you have takes to share about this, please feel free to do so on one of [my social platforms](https://link.clelia.dev)!
