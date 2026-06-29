---
title: "How I Write My Dissertation in Obsidian (Without Losing My Mind)"
date: 2026-06-29
description: "A full end-to-end workflow for writing your dissertation in Obsidian: importing sources into Zotero and building literature notes, inserting inline citations while writing, and exporting a clean PDF with Pandoc."
tags:
  - obsidian
  - academic-writing
  - zotero
  - pandoc
  - research
---

Word plus Zotero is where most students start, and it works, until it doesn't. The moment your bibliography hits 150 sources, your argument spans five chapters, and you need to cross-reference figures three sections back, the cracks show: citations feel bolted on (because they are), there's no connection between your reading notes and your writing, and every export is a negotiation with an uncooperative `.docx` or losing your mind trying to use raw LaTeX. The alternative is treating Obsidian as the actual writing environment, not just a note-taking app parked next to Word, but the place where literature notes, drafts, citations, and final output all live together.

Here's the full pipeline.

---

## The pipeline

1. Search for sources (Google Scholar, SciHub)
2. Import to Zotero via browser extension
3. Annotate PDFs in Zotero
4. Export highlights to literature notes in Obsidian
5. Write manuscript with inline citations
6. Export via Pandoc to PDF, Word, or LaTeX

Reading feeds notes. Notes feed writing. Writing exports. Nothing needs to move between apps.

---

## Setting up Zotero

Install the **Zotero browser extension** first. It pulls paper metadata from any journal page directly into your library with one click, no manual entry.

Then install two Zotero plugins:

- **Zotfile** handles PDF management and annotation extraction. Read papers on a tablet and the annotations sync back into Zotero automatically.
- **BetterBibtex** generates persistent, human-readable cite keys (e.g. `smith2021agency`) and keeps your `.bib` file current.

Export your library as a `.bib` file: go to **File → Export Library**, choose BibLaTeX format, enable **Keep Updated** and **Export Notes**, and set the automatic export trigger to **On Change**. Every paper you import from this point on shows up in the file without any manual steps.

> **Gotcha:** File paths with spaces will break pandoc arguments later. Put your `.bib` file somewhere with no spaces in the path, like `~/Documents/library.bib`, not `~/My Documents/PhD Library/library.bib`.

---

## Obsidian Citations plugin

Install the **Citations** community plugin and point it at your `.bib` file. Two settings matter here:

- **Citation database format:** BibLaTeX
- **Literature note folder:** wherever you keep reading notes

Then set up a literature note template. This is what every paper's note looks like when you import it:

```
---
year: {{year}}
author: {{authorLastName}}
citekey: {{citeKey}}
url: {{url}}
doi: {{doi}}
tags:
---

## Abstract
{{abstract}}

## Notes
```

The YAML frontmatter gives you filterable metadata across all your literature notes, useful when you're hunting for everything you read by a particular author or from a particular year. The `citekey` field is the bridge between your notes and your citations.

To import a paper's annotations: annotate the PDF in Zotero, right-click and choose **Add Note from Annotations**, then in Obsidian hit **Ctrl+P → Refresh citation database** and open the paper's literature note. Your highlights and comments appear in the Notes section.

---

## Writing the manuscript

To insert a citation, open the command palette and run **Insert citation**, search by author or title, and it drops `[@citekey]` into your document. That's the Pandoc citation syntax; it renders as a properly formatted reference on export.

Install the **Pandoc Reference List** plugin. It opens a sidebar that renders your bibliography live as you write, formatted in whatever citation style you configure. You can copy it directly into Word if you need to share a chapter draft.

For cross-references, figures, sections, equations, use `pandoc-crossref` syntax:

```markdown
# Introduction {#sec:intro}

![Caption here](figures/diagram.png){#fig:diagram}

As shown in @fig:diagram, and further discussed in @sec:intro...
```

Numbers update automatically on export. You never manually renumber a figure again.

> **Gotcha:** Before exporting, run the **Obsidian Link Converter** plugin to convert all `[[wikilinks]]` to standard Markdown links. Pandoc doesn't understand wikilinks natively, and you'll get broken references if you skip this.

---

## Exporting

The simpler approach is to embed your bibliography and citation style directly in the document's YAML frontmatter, so the export command stays short:

```yaml
---
title: "Thesis Title"
author: Your Name
date: 2026
bibliography: /path/to/library.bib
csl: /path/to/citation-style.csl
fontsize: 12pt
abstract: "Your abstract here."
---
```

With that in place, the export is just:

```bash
pandoc input.md --filter pandoc-crossref --citeproc -o output.pdf
```

For the full thesis with explicit flags:

```bash
pandoc input.md \
  --resource-path /path/to/vault \
  --bibliography /path/to/library.bib \
  --pdf-engine pdflatex \
  --filter pandoc-crossref \
  --citeproc \
  --csl /path/to/citation-style.csl \
  -o output.pdf
```

The order of `--filter pandoc-crossref` and `--citeproc` is not optional: crossref must run before citeproc. Reverse them and your cross-reference labels get mangled.

CSL files for any citation style (APA, Chicago, Vancouver, journal-specific) are available from the Zotero citation styles repository. Download the `.csl` file and drop it somewhere stable on your machine.

For polished PDF output, use the **eisvogel** LaTeX template: download `eisvogel.tex`, place it in `~/.local/share/pandoc/templates/`, and add to your export command:

```bash
--template eisvogel \
--metadata title="Thesis Title" \
--metadata author="Your Name"
```

It handles margins, fonts, and chapter headings without any configuration.

If you're submitting to a journal or working via Overleaf, export to LaTeX instead:

```bash
pandoc input.md \
  --natbib \
  --extract-media ./figures \
  -o thesis.tex
```

`--natbib` produces proper `\cite{}` commands; `--extract-media` copies images out of your vault into a separate folder.

> **Gotcha:** Test the full export pipeline on a small sample file before you run it on your 80,000-word thesis. One broken image path or malformed cite key will abort the whole thing. A three-paragraph test document that exercises citations, a figure, and a cross-reference takes two minutes and saves hours.

---

## Why this holds together

No individual tool here is magic. What makes the setup work is that reading, thinking, and writing happen in the same environment. Your literature note for a paper is two clicks from the paragraph where you cite it. When you change your argument, you update the note and the citation together. When you're done writing, the export is a single command.

Word is fine for a 3,000-word essay. For a thesis, you need something that scales with the argument.
