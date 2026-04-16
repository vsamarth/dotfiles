# Declarative Dotfiles Design Specification

## Goal
Transform the existing dotfiles repository into a single, human-readable `instructions.md` file that any AI agent (or human) can execute step-by-step to achieve a fully configured macOS system. This replaces imperative shell scripts and complex `justfile` logic with a linear, declarative Markdown document.

## Architecture
The system will consist of a single entry point (`instructions.md`) containing ordered sections. Each section describes a specific subsystem (packages, configs, system settings) using clear, imperative Markdown instructions.

The execution model is:
1.  Parse `instructions.md` (manually or via a simple script).
2.  Execute steps in order.
3.  Use standard shell commands (`brew install`, `ln -s`, `defaults write`) referenced in the markdown.

## Tech Stack
- **Markdown**: Documentation format.
- **Shell**: Execution engine (zsh/bash/fish).
- **Homebrew**: Package management.
- **dockutil**: Dock configuration.

## Components

### 1. `instructions.md`
The master document. Structure:
- Header with title and prerequisites.
- Ordered sections (H2 headers) for each major task.
- Code blocks for commands.
- Lists for items (packages, files).

### 2. Sections to Include
1.  **Prerequisites**: Ensure Homebrew is installed.
2.  **Install Homebrew Packages**: List formulas and casks from `Brewfile`.
3.  **Link Configuration Files**: Map source files to destination paths.
4.  **Configure macOS System**: Translate `.macos` script into `defaults write` commands.
5.  **Setup Dock**: List apps in order using `dockutil`.
6.  **Setup Shell (Fish)**: Installation and config file linking.
7.  **Setup Editors (Neovim, VS Code)**: Config file linking.
8.  **Setup Terminal (Ghostty, Zellij)**: Config file linking.
9.  **Setup Browsers (Firefox)**: Profile configuration.
10. **Setup Development Environments**: Rust, Python, Go, Node.

## Success Criteria
- `instructions.md` exists and is comprehensive.
- All current functionality from `justfile` and scripts is represented.
- An AI agent can execute the file sequentially without prior knowledge of the repo structure.
- The file is readable by humans.

## Constraints
- Keep it linear (no jumping around).
- Use absolute paths where possible or clear relative paths from the repo root.
- Avoid complex logic (loops, conditionals) inside the markdown; if needed, encapsulate in a small helper script referenced by the markdown.

## Implementation Notes
- The `justfile` will be deprecated (or kept as a legacy wrapper).
- The `Brewfile` content will be inlined into the markdown.
- Shell scripts (like `dock.sh`) will be expanded into direct commands in the markdown.

## Files to Create/Modify
- Create: `instructions.md`
- Modify: `README.md` (update to point to new instructions)
- Delete/Deprecate: `justfile`, `bootstrap.sh` (if replaced by instructions)

---
