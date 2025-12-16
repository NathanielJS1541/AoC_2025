# Contribution Guidelines

This document outlines the contribution guidelines for this repository. Please
ensure you fully read and understand this before contributing. It is especially
important that you follow the [AoC license](#aoc-licensing-terms) and
[repository rules](#repository-rules)!

Finally, see the [getting started](#getting-started) section to structure your
contributor directory.

If you're new to [`git`](https://git-scm.com/) and
[GitHub](https://github.com/), check the
[getting started with git](#getting-started-with-git) section for some
resources.

<!-- omit from toc -->
## Contents

- [AoC Licensing Terms](#aoc-licensing-terms)
- [Getting Started With Git](#getting-started-with-git)
- [Repository Rules](#repository-rules)
- [Getting Started](#getting-started)


## AoC Licensing Terms

The [Advent of Code](https://adventofcode.com/about) explicitly disallows
re-distribution of the puzzle text and inputs. Please **do not** commit them!

## Getting Started With Git

If you're unfamiliar with [`git`](https://git-scm.com/) and
[GitHub](https://github.com/), I'd recommend checking out
[GitHub's getting started documentation](https://docs.github.com/en/get-started/learning-to-code/getting-started-with-git)
to learn how to use both `git` and GitHub.

I'd also recommend [GitHub Desktop](https://desktop.github.com/download/) or
[GitKraken](https://www.gitkraken.com/) as more beginner-friendly `git` clients.

You can also create your own repos on GitHub to practice using git.

## Repository Rules

I know this is boring, but these are here for a reason!

- Always work in your own branch, and create a
  [Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)
  to merge your work into `main` periodically. You can complete this PR
  yourself, but it makes it much easier for multiple users to contribute to the
  same repository.
- Do push directly to `main`! See the rule above!
- Do not rebase `main`! This has the potential to create confusing scenarios for
  others, or overwrite others' work if they have based work on a commit that you
  rebase.
- Do not `git push --force`! People can and will lose work this way. Use
  `git push --force-with-lease` instead if you must, and only on **your**
  branches. If you get an error, it means someone else has pushed commits to
  your branch that you haven't `fetch`ed and you **shouldn't** continue!
- Make your commit messages well-structured and clear:
  - The commit **subject** is the first line of a commit message, and should be
    a short summary of the change (ideally 50 characters or less!). Some
    examples include: `chore: add root .gitignore for common IDEs` or
    `feat: add solution for day 1 part 1`.
  - The commit **body** is separated from the **subject** by blank line, and can
    be multiple lines long (ideally each line should be 72 characters or less!).
    This can contain a more detailed description of your change. So a full
    commit message might look something like this:
    ```
    chore: add root .gitignore for common IDEs

    I've added a "best guess" root `.gitignore` file for the IDEs that
    I think are most commonly used.
    ```

## Getting Started

- Create your own named directory inside this repo to reflect your name, for
  example [`nat`](./nat/). From there you can structure it however you like, but
  make sure to create your own `README.md` and link it to the
  [contributors section of the main README.md](./README.md#contributors).
- Use a `.gitignore` file locally within your own directory for
  language-specific ignore rules. `.gitignore` files are applied to the
  directory they are in, and any subdirectories below that. Because there will
  be lots of additions to the `.gitignore` file with each language people use,
  having them within your own directory means they can be customised to the
  languages you are using without creating merge conflicts for other people.
  GitHub maintains a
  [repo of .gitignore templates](https://github.com/github/gitignore) if you
  need some inspiration.
- There is a `.gitignore` in the root of the repo, which contains the
  `.gitignore` templates for various common IDE's (Visual Studio, VSCode,
  JetBrains etc.). If your IDE needs some files ignored in the `.gitignore`, it
  should be added here to ensure any dotfiles your IDE generates when you open
  the repo are ignored, as these are usually placed in the root directory.
