---
name: compose-chapter
description: "Convert raw text into a polished Quarto .qmd chapter for the Optuna book, following syllabus, style guide, and git workflow with user approval gates"
argument-hint: "raw_file.md modules/target-chapter.qmd"
agent: "agent"
---

You are composing a new Quarto chapter for the Optuna book using the `optuna-qmd-chapter-writer` skill.

**Arguments expected:** 
1. Path to raw text file (e.g., `current_chapter_raw_text.md`)  
2. Target .qmd chapter file (e.g., `modules/05-basic-optuna-usage.qmd`)

If arguments are missing, ask the user to specify them before proceeding.

**Error handling:**
- If raw text file doesn't exist, ask user to confirm the path or provide the content directly
- If target .qmd already contains polished content, warn user and ask for confirmation before overwriting
- If target module doesn't match the syllabus, alert user and suggest closest match

**Workflow:**
1. Validate both file paths exist/are appropriate
2. Invoke the `optuna-qmd-chapter-writer` skill with the raw text content and target chapter path
3. Let the skill handle the complete git workflow (branching, commits, approval gates)
4. Do not consider complete until user approves and branch merges to main

**Important**: The skill manages all git operations, style compliance, and requires explicit user approval before merging. Follow its workflow completely.

Example usage:
```
/compose-chapter current_chapter_raw_text.md modules/07-samplers.qmd
```