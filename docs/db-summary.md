# Database Overview

Quenti stores information about users, study sets and classroom
collaboration. The schema is defined with Prisma and mirrored in a
Drizzle ORM representation.

Key tables include:

- **User** – basic account information such as email, username and type
  (student or teacher). Users belong to organizations and classes.
- **Organization** – groups of users with domains, membership roles and
  invites. Classes can be associated with an organization.
- **Class** – used for grouping students and teachers. Classes contain
  sections, assignments and study sets.
- **StudySet** – collections of learning terms. A set contains `Term`
  records that hold the word, definition and related metadata.
- **Session** and **Account** – managed by NextAuth for authentication.

The schema also includes linking tables for many‑to‑many relations, such
as `StudySetsOnClasses` and `FoldersOnClasses`. For a full reference see
`packages/prisma/schema.prisma` or `packages/drizzle/schema.ts`.

Other notable models include **Folder** for grouping study sets, and
**StudySetCollaborator** which allows multiple users to contribute terms to a
set. Visibility can be restricted to classes or sections using the
`AllowedClassesOnStudySets` and `AllowedSectionsOnStudySets` tables.

User progress is tracked through the **Container** and **StudiableTerm**
models. A `Container` stores study preferences such as the selected mode
(flashcards, learn, match) and whether to shuffle cards. `StudiableTerm`
records how well a user knows each term so that learn mode can repeat
difficult words more often. Leaderboards and highscores are stored in the
**Leaderboard** and **Highscore** tables.

For a deeper look at how the Learn mode algorithm works see
[`docs/learn-mode-algorithm.md`](learn-mode-algorithm.md).
