---
name: optuna-qmd-chapter-writer
description: Convert raw chapter notes or AI-generated draft text into polished Quarto .qmd chapter files for this Optuna book, following the syllabus, the book style guide, and the existing chapter conventions. Use this skill when you need to turn raw text into a finished or near-finished Quarto chapter for this repository.
---

# Optuna QMD Chapter Writer

Use this skill when you need to turn raw text into a finished or near-finished Quarto chapter for this repository.

This skill is specific to the Optuna book in this workspace. It assumes:

- The book structure is defined in `syllabus.md` and `_quarto.yml`.
- Each module is a chapter.
- The audience is advanced practitioners who already know machine learning, Python, and classical hyperparameter search.
- The source material may come from rough AI-generated teaching notes and needs editorial cleanup before publication.

## What This Skill Produces

This skill produces a chapter file in `modules/*.qmd` that:

- Fits the module title and scope in `syllabus.md`.
- Uses clean Quarto markdown with valid front matter.
- Preserves the useful technical content from the raw text.
- Rewrites rough notes into publication-ready prose.
- Includes the minimum chapter elements required by the book style guide.

## When To Use It

Use this skill when the user asks for any of the following:

- Write a chapter from raw notes.
- Convert a markdown draft into a `.qmd` chapter.
- Polish AI-generated educational text for this Optuna book.
- Turn a module outline into a proper book chapter.
- Add a new chapter that matches the tone and structure of the existing book.

Do not use this skill for:

- General Python coding tasks unrelated to the book.
- Quarto build or environment troubleshooting.
- Writing prompts, agents, or instructions files.

## Required Context To Read First

Before drafting or editing a chapter, read and align with:

1. `.github/copilot-instructions.md`
2. `.github/instructions/book_style.instructions.md`
3. `syllabus.md`
4. `_quarto.yml`
5. The target chapter file in `modules/`
6. At least one existing polished chapter, especially `modules/01-foundations-modern-optimization.qmd` when available

## Workflow

### 1. Confirm chapter target

Map the raw text to the intended module and target file.

Check:

- Which module this content belongs to.
- Whether the target `.qmd` already exists.
- Whether the current file is blank, partially written, or already polished.

If the raw text drifts outside the module scope, tighten it to match the syllabus instead of expanding the chapter arbitrarily.

### 2. Extract the instructional promise

Identify the chapter's single clear promise.

State internally:

- What the reader should understand by the end.
- What practical capability the chapter should build.
- What should be deferred to later modules.

If the source text tries to cover too much, cut or defer secondary material.

### 3. Normalize raw source material

Convert rough teaching notes into clean prose.

Typical cleanup tasks:

- Replace note-like fragments with full explanatory sentences.
- Fix malformed math syntax and convert it to Quarto math blocks.
- Replace decorative separators with semantic headings.
- Remove repetitive phrasing and over-explaining.
- Preserve useful examples, definitions, and comparisons.
- Correct terminology so terms like study, trial, sampler, pruner, and objective remain consistent.

### 4. Apply the book chapter structure

Default chapter pattern:

1. Motivation or opening frame.
2. Why this matters.
3. Minimal working example or fast first win.
4. Step-by-step conceptual explanation.
5. Common mistake or failure mode.
6. Practical exercise.
7. Recap.
8. Decision guide or transition to next chapter.

The exact headings can vary, but the chapter should still scan clearly and feel structured.

### 5. Add Quarto-specific formatting

Ensure the chapter uses proper Quarto conventions:

- YAML front matter with `title`.
- Valid heading hierarchy.
- `$$ ... $$` for display math.
- Fenced executable code blocks such as ```{python}``` when code should run.
- Markdown tables that render cleanly.
- Callouts for warnings, tips, or takeaways when useful.
- Mermaid or plots when a lightweight visual improves comprehension.

Prefer small runnable examples that fit on one screen.

### 6. Enforce book-specific quality checks

Every completed chapter should include at least:

- One paragraph of motivation.
- One runnable example.
- One diagram or plot.
- One exercise.
- One common-mistake note.
- One recap with practical takeaways.

Also verify:

- The prose is aimed at advanced practitioners, not complete beginners.
- The examples are self-contained and copyable.
- The chapter builds naturally toward later Optuna topics.
- Cross-links point to the correct neighboring modules when relevant.

### 7. Keep scope disciplined

Prefer a clean, focused chapter over a comprehensive dump of every idea in the raw text.

If something belongs in another module, either:

- Mention it briefly and cross-link forward, or
- Remove it from the current chapter draft.

### 8. Validate the result

After editing:

- Check the target `.qmd` for syntax or editor errors.
- Render the chapter when practical.
- Confirm that math, callouts, code blocks, and links are valid.

If rendering fails because of environment issues, separate content problems from tooling problems.

## Decision Points

Use these decision rules while drafting:

### If the raw text is very rough

Preserve the technical meaning, but rewrite aggressively for clarity and flow.

### If the raw text is already well structured

Keep the structure, but adapt it to the repository's Quarto and book-style conventions.

### If the raw text lacks a fast first win

Add a small runnable example early in the chapter.

### If the raw text lacks a visual

Add a simple Mermaid diagram, plot, or compact table that supports interpretation.

### If the raw text overlaps strongly with another module

Reduce overlap and add a forward or backward link instead of duplicating content.

### If the file is currently blank

Create the full chapter scaffold and populate it from the raw notes.

### If the file already contains good content

Edit in place and preserve working sections, examples, and links.

## Quality Bar

The chapter is complete when all of the following are true:

- The chapter promise is clear in the opening.
- The content matches the intended module in `syllabus.md`.
- Quarto syntax is valid.
- The prose reads like a technical book chapter, not raw notes.
- The reader gets both intuition and mechanics.
- At least one runnable example is present.
- At least one exercise is present.
- At least one common mistake is present.
- The chapter ends with a recap or decision guide.

## Example Prompts

- Use the raw text in `current_chapter_raw_text.md` to write `modules/02-bayesian-optimization-fundamentals.qmd`.
- Turn these lecture notes into a polished Quarto chapter for Module 7.
- Rewrite this draft so it matches the style of `modules/01-foundations-modern-optimization.qmd`.
- Use this module outline and create a complete first draft of the chapter with runnable examples.

## Editing Notes For This Repository

- Keep the chapter titles aligned with `_quarto.yml`.
- Respect the module order in `syllabus.md`.
- Prefer links to neighboring chapters when concepts are intentionally deferred.
- Treat rough AI-generated text as source material, not final copy.
- Do not create a detached essay; write directly into the target chapter file under `modules/`.