# Itertools for VLang

A robust library for advanced iteration tools, bringing the power of functional programming to VLang.

_Note:_ This project is still in development and may not be ready for production use.

## 🚀 Features

- Core Iterators: Essential tools like map, filter, reduce, and more.
- Lazy Iterators: Efficiently process data without loading it all at once.
- Infinite Iterators: Handle infinite sequences with ease.
- Combinators: Advanced tools for combining and manipulating iterables.
- Utilities: Practical tools for everyday iteration needs.

## 📖 Documentation

Detailed documentation for each module is available:

- Core Module
- Lazy Iterators
- Combinators
- Infinite Iterators
- Utilities

You can also visit the [Project Homepage](https://diaakasem.github.io/viter) for a guided experience.

## 📦 Installation

To include `viter` in your VLang project:

use `vpm` to install the package:

```bash
v install diaakasem.viter
```

## 🛠️ Usage

Here’s a quick example using the Core Module:

```v
import viter.core

fn main() {
    numbers := [1, 2, 3, 4, 5]

    // Map example
    squares := core.map(numbers, fn (n int) int {
        return n * n
    })
    println('Squares: $squares')

    // Filter example
    even_numbers := core.filter(numbers, fn (n int) bool {
        return n % 2 == 0
    })
    println('Even Numbers: $even_numbers')
}
```

## 🤝 Contributing

Contributions are welcome! Here’s how you can get started:
1.	Fork the repository.
2.	Create a new branch for your feature or bugfix:

```bash
git checkout -b feature-name
```

3.	Commit your changes:

```bash
git add .
git commit -m "Add a new feature"
```

4.	Push to your branch:

```bash
git push origin feature-name
```

5.	Open a Pull Request.

## 📜 License

This project is licensed under the MIT License.

## 💡 About

Itertools for VLang is inspired by popular iteration libraries in other languages, like Python’s itertools and Rust’s Iterator. It aims to bring similar functionality to VLang with an emphasis on simplicity and performance.
