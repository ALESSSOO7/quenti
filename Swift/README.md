# Quenti SwiftUI Prototype

This folder contains a basic SwiftUI example for a native version of Quenti.
It demonstrates how study sets might be represented using SwiftData and
SwiftUI views.

The code is intentionally lightweight to act as a starting point for a full
port of the web application. "Learn" mode now mimics Quizlet more closely:

- Flash cards can be swiped right or left to mark a term correct or wrong.
- After that the user is quizzed with four multiple choice options.
  - A final round requires typing the translation. Answers are checked using a
    simple Levenshtein distance allowing about 20% tolerance for typos.

For details about this tolerance algorithm and how to swap in an external
package, see [../docs/learn-mode-algorithm.md](../docs/learn-mode-algorithm.md).
