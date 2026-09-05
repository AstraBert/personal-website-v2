---
publishDate: 2025-07-11T00:00:00Z
author: Clelia Astra Bertelli
title: Why (and how) I am a Pydantic user
excerpt: An excerpt of the reasons why I use pydantic, encompassing validation and readability.
category: Coding
tags:
  - python
  - coding
  - open source
metadata:
  canonical: https://clelia.dev/blog/2025-07-11-Why-and-how-I-am-a-pydantic-user
---

I recently read a [blog post](https://leehanchung.github.io/blogs/2025/07/03/pydantic-is-all-you-need-for-performance-spaghetti/) from [Han-chung Lee](https://www.linkedin.com/in/hanchunglee/) whose main take-home message was to use Pydantic mostly for validation, while for everything else it should be enough to use good ol’ `dataclasses` or plain classes.

Also recently, I had the opportunity to take out of my backlog of unread posts [Remi Louf](https://www.linkedin.com/in/remilouf/)’s blog [post for .txt](https://blog.dottxt.co/do-one-thing-well.html), where he talked about the necessity for reliability in modern agentic systems, reliability that he suggested could be achieved with structured generation: he used Pydantic as an example of a simple and self-explanatory way of producing models for structured output.

And I felt, for a second, that my being an unapologetic user of Pydantic could be summarized exactly by these two points: **validation and readability.**

This blog post has exactly the aim of explaining how these two features helped me as a python developer to make my code more elegant, dynamic and understandable.

## Typing and Validation, Typing vs Validation

Python, unlike Rust, Go or C, is not a statically typed language and, while it might feel easier and less debug-intense at first, dynamic typing has pitfalls when it comes to writing complex code: when you don’t have strict rules, it is easier and easier for unpredictable inputs (such as user inputs or AI outputs) to break you pipeline unexpectedly - and trust me, I’ve been there.

If you only introduce typing (using hints, for example), and maybe a strict type-checker in your integration pipeline, your code might look good and run fine, but still the outside world will not know what is going on in the black box behind that API server, that web page or that application - an they could still easily break it unexpectedly, unless you force _them_ to produce only very specific and limited inputs.

When you introduce typing validation, Python actually starts to look like a statically typed language, and that is a real blessing for when you need everything - even the exceptions! - to run smoothly and as expected.

Validation does not only stop at typing: you can also check patterns in strings (to confirm, for example, that the email address provided is valid), or values in numbers (the age of a person to confirm that they’re above or under a certain threshold), or the number of elements in a list (to enforce, for example, that the list is not empty of does not exceed a certain length).

That is exactly where Pydantic becomes very useful - not only for the simplicity and intuitiveness of its (typing and) validation mechanism, but also for the elegance and the readabiliy of it.

Just imagine we are throwing a party for all the people in the city whose name starts with S, that are older than 21, with a valid email address and with at least one dog (and a maximum of three):

- Without Pydantic:

```python
from typing import List
import re

PATTERN = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

def party_registration(name: str, age: int, email: str, dog_names: List[str]) -> bool:
	if not isinstance(name, str) or not name.lower().startswith("s"):
		return False
	elif not isinstance(age, int) or age < 21:
		return False
	elif not isinstance(email, str) or not re.match(PATTERN, email):
		return False
	elif not isinstance(dog_names, list) or not (0 < len(dog_names) < 4):
		return False
	return True
```

- With Pydantic:

```python
from pydantic import BaseModel, Field, EmailStr, ValidationError
from typing import List

class PartyRegistrationRules(BaseModel):
	name: str = Field(pattern="^S.*")
	age: int = Field(ge=21)
	email: EmailStr
	dog_names: List[str] = Field(min_length=1, max_length=3)

def party_registration(name: str, age: int, email: str, dog_names: List[str]) -> bool:
	try:
		PartyRegistrationRules(name=name, age=age, email=email, dog_names=dog_names)
		return True
	except ValidationError:
		return False
```

You can see that not only with avoid chaining several conditional statements - making the function simpler, but we also create a class with an intuitive name and whose fields have clear types and easy-to-understand limitations. And if you are not happy with the built-in validation method, you can always write your own model or field validators!

This is a simple use case, but just imagine how well this could perform on more complex systems, like validating web forms or API input/outputs, especially with LLM unpredictability these days.

## Readability matters

Many people, especially those who code solo or those who maintain closed-source products, might say that the only thing that matters in coding is that the code works.

And I was like that too: I genuinely believed that, if my code worked as expected, I had done my job - until a couple of years ago. At that time, I had my first reality check working on a shared, open-source project, that in turn needed to be built with other pieces of OSS software.

At that time I understood that I could not write huge, thousands-of-lines-long, monolithic scripts: nobody would have been able to read through them and understand them, let alone maintain them if I was not there. In that moment I understood that code readability is indeed a key principle not only of shared code, but of good code.

Readability is the other reason, and it is already hinted at in the paragraph above, why (and how) I chose to use Pydantic. And I’ll give you a very practical example of that - my own (beloved) python package to perform file conversion of (almost) any format to PDF: [PdfItDown](https://github.com/AstraBert/PdfItDown).

The project is open source and lives on GitHub, meaning that you can easily climb back to past versions and see the clear difference from before (v.0.0.6 and below) and after (v1.0.0 and further) the refactoring of the codebase with Pydantic.

If you indeed go to [v0.0.6](https://github.com/AstraBert/PdfItDown/tree/v0.0.6) and then compare it to [v1.0.0](https://github.com/AstraBert/PdfItDown/tree/v1.0.0), you will notice a dramatic difference in code length, verbosity and performance: despite being able also to convert images and being completely refactored from a functional to an object-oriented logic, the [`pdfconversion`](https://github.com/AstraBert/PdfItDown/blob/v1.0.0/src/pdfitdown/pdfconversion.py) module is only three lines longer than its [Pydantic-free counterpart](https://github.com/AstraBert/PdfItDown/blob/v0.0.6/src/pdfitdown/pdfconversion.py). And this is true also for the CLI script, which is indeed slimmer in the Pydanticized version. The point is not only that the code is shorter, but it’s that it is clearer: no comment is needed to explain what the `OutputPath` class does, or what the `file` value (typed as a string) represents inside it. **Pydantic is elegant and self-explanatory**.

This is not only crucial for the humans who read, maintain and contribute to the code (especially in open source) but it is also fundamental to help LLM or AI agents understand the output format that they need to provide us with, ensuring even more reliability that what validation on its own can give.

In summary, what I want to say with this article is that Pydantic may have its pitfalls and might not be highly optimized for your project if you are not looking to introduce validation - but still, it is a great tool to ensure clarity and solidity through your codebase.
