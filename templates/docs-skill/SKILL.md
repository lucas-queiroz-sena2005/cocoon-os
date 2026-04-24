---
name: engineering-docs
description: High-density engineering documentation and research workflow. Use when Gemini CLI needs to initialize a project with standardized research logs (docs/planning), mathematical formalization (Arithmatex/MathJax), and architectural mandates (GEMINI.md).
---

# Engineering Documentation & Research Skill

This skill provides the workflow and assets needed to maintain production-ready, highly-observable documentation for any project.

## Core Principles
- **First-Principle Research**: Use `docs/planning/RESEARCH.md` for active discovery and scalar surprise tracking.
- **Physics-Driven Architecture**: Ground all systems in state models and behavioral constraints.
- **Mathematical Integrity**: Use LaTeX (via Arithmatex/MathJax) for all formal logic.
- **Structural Mandates**:
    - `docs/core/`: Mission & Roadmap
    - `docs/architecture/`: Technical Specs & Math
    - `docs/planning/`: Active Sprints
    - `docs/rejects/`: The Graveyard (with REASON.md)

## Workflow
1.  **Initialize**: Copy `GEMINI.md` to the project root and create the `docs/` directory structure using the provided `template/`.
2.  **Configure**: Use `assets/mkdocs.yml` and `assets/mathjax.js` to enable high-quality rendering.
3.  **Research**: Start all new features in `docs/planning/RESEARCH.md`.
4.  **Architect**: Translate research into formal specs in `docs/architecture/`.

## Bundled Resources
- **References**: `GEMINI.md` (Engineering Directives)
- **Assets**: `mkdocs.yml` (Configuration), `mathjax.js` (Mathematical Rendering), `template/` (Directory boilerplate)
