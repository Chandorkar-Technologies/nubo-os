# Writing guide for the Nubo OS documentation

Read this before writing a page. The pages live in `src/content/docs/` (Astro Starlight, Markdown).

## What these docs are
Documentation for Nubo OS 1 "Flow": the desktop and the server, built on Ubuntu 26.04 LTS. Readers are ordinary people (desktop) and system administrators (server). Write the way a knowledgeable friend explains things: plain, short sentences, second person ("you"), active voice. No marketing words. No "simply" or "just".

## Truth rules (most important)
1. Describe only what exists. Check the repo (`/Users/ninad/Desktop/projects/nubo-os`) before you state a feature, a package name, a path, a command, a key or a label. `docs-site/FACTS.md` is a starting point, the code is the authority.
2. If something is not built yet, say so in a note: `:::caution[Planned]` ... `:::`. If it is built but untested, say "not yet tested on hardware".
3. No speed, battery or security-superlative claims. No numbers we have not measured.
4. Never invent a screen label, menu item or button name. If you cannot confirm a label from the repo, describe the action generically ("open Settings") and add `<!-- verify label -->` in the Markdown.
5. For generic Linux topics that behave exactly as on Ubuntu 26.04, give the short Nubo-specific part and link to Ubuntu's documentation (https://ubuntu.com/server/docs for Server, https://ubuntu.com/desktop/docs for Desktop) instead of re-explaining.
6. Do not copy text from Ubuntu or other documentation. Paraphrase and cite as a link.
7. Trademarks: "Ubuntu" is Canonical's. Say "based on Ubuntu 26.04 LTS" and use the name only when naming the base system or Ubuntu's own things.

## Page types (Diataxis)
- **Tutorial**: one learning path, start to a working result, every step shown. Ends with "What you built" and "Next steps".
- **How-to**: one task. Sections: "Before you begin" (requirements), numbered steps, "Verify", "Troubleshooting" (symptom -> cause -> fix), "See also". Every how-to has Verify and Troubleshooting.
- **Explanation**: why and how it works, no steps. Diagram in a code block or mermaid if useful.
- **Reference**: tables, exact values, no narrative. Alphabetical or grouped. Include defaults.

## Frontmatter
```
---
title: Short, specific title in sentence case
description: One sentence that says what the page helps you do.
sidebar:
  order: 10        # lower comes first inside its folder; use 10, 20, 30...
---
```
Each folder needs an `index.md` that introduces the section and lists its pages with one-line descriptions (links).

## Formatting
- Headings: `##` and `###` only inside a page (the title is the H1).
- Commands in fenced blocks with `bash` and a `title` when it names a file: ```` ```bash title="/etc/nubo/example.conf" ````. Show a `$` only when you also show output.
- Keyboard keys: `<kbd>Super</kbd>+<kbd>Space</kbd>`.
- Notes: `:::note`, `:::tip`, `:::caution`, `:::danger` blocks, sparingly.
- Where a page applies only to some editions, start with: `**Applies to:** Desktop` or `**Applies to:** Server, Virtualization` (editions: Desktop, Server, Virtualization, Containers, Edge).
- Screenshots: real ones only. Available in `src/assets/screens/` (desktop, grid1, grid2, notif, quick, about, login; JPG). Embed with a relative path and alt text, for example `![The Nubo desktop](../../../assets/screens/desktop.jpg)` (count the `../` from the page location up to `src/`). Do not make up screenshots.
- Links to other pages: root-relative with trailing slash, for example `/desktop/use/nubo-search/`. Link only to pages you wrote or to a section index (`/desktop/`, `/server/`, `/updates/`, `/reference/`, `/developers/`, `/start/`). A link checker runs at build time; broken links fail the build.
- Length: tutorials and how-tos 400-1000 words, explanation 500-1200, reference as long as the table needs.
- Spelling: British or American, but be consistent: American.

## Names to use
- Product: Nubo OS (desktop), Nubo OS Server. Release: Nubo OS 1 "Flow".
- Editions of the server: Server, Virtualization (Incus), Containers (Podman), Edge.
- Services: archive.nubosuite.tech (package archive), Nubo Cumulus (the cache for Ubuntu's archive and images), docs.nubosuite.tech, os.nubosuite.tech, mail.nubo.email, support@nubo.email.
