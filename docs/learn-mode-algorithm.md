# Learn Mode Algorithm

Quenti's SwiftUI prototype mirrors the learn flow from Quizlet. A study
session begins with swipeable flash cards, proceeds to multiple-choice
questions and ends with a short written quiz. Answers in the typing round
use a tolerance check so minor typos do not count as wrong.

The tolerance is based on the **Levenshtein distance** between the
user's answer and the correct definition. The implementation allows a
distance of about 20% of the target word's length (at least one
character). For example, for a five-letter answer, one mismatch is still
accepted.

A simple dynamic programming solution is included in
`Swift/LearnModeView.swift`. In a production app you may prefer an
optimized package such as
[`SwiftLevenshtein`](https://github.com/SwiftDocOrg/SwiftLevenshtein)
which can be added with Swift Package Manager:

```swift
.package(url: "https://github.com/SwiftDocOrg/SwiftLevenshtein.git", from: "0.1.0")
```

Import the package in `LearnModeView.swift` and replace the custom
function with the library's `distance` calculation.
