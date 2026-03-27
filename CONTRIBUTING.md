# Contributing to nysOpenData

Thanks for your interest in contributing to **nysOpenData**! This package provides convenient R helpers for working with NYS Open Data (Socrata) datasets and returns results as tidy tibbles with optional filtering, sorting, and row limits.

This guide explains how to report issues, propose changes, and submit pull requests.

---

## Code of Conduct

Be respectful and constructive. Assume good intent. Harassment or discrimination of any kind is not tolerated. Please refer to `CODE_OF_CONDUCT.md` for full details.

---

## Ways to Contribute

You can help by:

- Reporting bugs or confusing behavior.
- Suggesting improvements to documentation or examples.
- Improving tests and edge-case handling (timeouts, API errors, schema changes).
- Improving performance or developer ergonomics.

---

## Filing Issues

Please open an issue with:

1. **What you expected to happen**
2. **What actually happened**
3. A **minimal reproducible example** (copy/paste-able using the `reprex` package).
4. `sessionInfo()` output.

If the issue is dataset-specific, include:

- The dataset name and/or NYS Open Data dataset ID (e.g., `28gk-bu58`).
- Any filters used in the function call.
- Whether the issue is intermittent (likely related to rate limits or timeouts).

---

## Development Setup

### 1) Fork and Clone
Fork the repository on GitHub and clone it to your local machine.

### 2) Install Dependencies
Ensure you have the following packages installed for development:

```r
install.packages(c("devtools", "roxygen2", "testthat", "pkgdown", "vcr", "webmockr", "covr"))
