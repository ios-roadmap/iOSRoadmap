# iOS Roadmap   

## Project Notes

- We should avoid using external libraries as much as possible. However, in certain cases, we can **temporarily** integrate some libraries into the project.
- The goal should not be to make the library a dependency, but to add the useful parts of it to the project.   

This marks the initial phase of building a modular iOS SuperApp architecture using UIKit. The goal is to develop two distinct sample applications within the same project: one leveraging the JSONPlaceholder API, and the other built on the Rick and Morty public API. These apps will serve as real-world demonstrations to validate and establish a robust, clean UIKit-based foundation.

# Key Objectives:

* Apply modular architecture with a clear separation between apps, features, and packages.
* Create two standalone apps under a shared modular umbrella, backed by dozens of feature modules and over 20 internal packages.
* Adhere strictly to clean code principles, architectural best practices, and high testability.
* All modules will initially remain local/internal. As the project evolves or new external needs arise, selective modules may be exposed publicly.
* The entire codebase will be fully open-source, with an emphasis on maximum unit test coverage from day one.

This is not a playground—this is an opinionated, production-quality showcase of modular UIKit at scale.

## Module Design
![FigJam basics](https://github.com/user-attachments/assets/07986721-f39a-4954-8bcc-390284b9db6a)m

# NOTE
Modular project development using SwiftUI.
