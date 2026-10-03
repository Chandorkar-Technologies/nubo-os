---
title: Contributing to these docs
description: Add or edit a page on docs.nubosuite.tech, preview it locally, run the link check and understand how it is published.
sidebar:
  order: 110
---

This documentation site lives in the `docs-site/` folder of the Nubo OS repository. It is built with Astro and its Starlight theme. Pages are Markdown files; there is no database or admin screen. A change reaches the public site when it is merged to `master`.

## Before you begin

- A clone of the repository: <https://github.com/Chandorkar-Technologies/nubo-os>.
- Node.js and npm. CI builds with the `node:24-slim` image, so use Node 24 to avoid differences.
- Read `docs-site/WRITING.md` first. It holds the rules every page follows, and `docs-site/FACTS.md`, a checked list of facts to start from. The code in the repository is the authority when they disagree.

## Where things are

| Path | What it is |
|---|---|
| `docs-site/src/content/docs/` | The pages. Each folder is a section of the sidebar. |
| `docs-site/src/assets/` | Images and real screenshots (`screens/`). |
| `docs-site/public/` | Files served as they are, such as the favicon. |
| `docs-site/astro.config.mjs` | Site title, sidebar sections (generated from folders), the link checker and the "edit this page" link. |
| `docs-site/worker.js` | The Cloudflare Worker that serves the built site from the bucket `nubo-docs`. |
| `docs-site/WRITING.md`, `FACTS.md` | Style rules and facts. |

The sidebar is built automatically from these folders: `start`, `desktop`, `server`, `updates`, `reference` and `developers`. Order inside a folder comes from `sidebar.order` in each page.

## Steps: add a page

1. Choose the folder and decide the page type: tutorial, how-to, explanation or reference. `WRITING.md` describes the four and the sections each needs. Every how-to has "Before you begin", numbered steps, "Verify" and "Troubleshooting".
2. Create a Markdown file with a short, lower-case, hyphenated name, for example `docs-site/src/content/docs/developers/my-topic.md`.
3. Start it with frontmatter:

   ```text
   ---
   title: Short, specific title in sentence case
   description: One sentence that says what the page helps you do.
   sidebar:
     order: 10
   ---
   ```

   Lower numbers come first. Use 10, 20, 30 so you can insert pages later.
4. Write the page. Use `##` and `###` headings only; the title is the top heading. Put commands in fenced blocks marked `bash`. Write keys as `<kbd>Super</kbd>+<kbd>Space</kbd>`.
5. Link the section's `index.md` to the new page with a one-line description. Every folder's index lists every page in it.
6. Link to other pages with root-relative paths and a trailing slash, such as `/developers/roadmap/`.

## Rules that matter most

- Describe only what exists. Check the code before you write a command, path, option or label.
- Mark unbuilt features with a note: `:::caution[Planned]` ... `:::`. Say "not yet tested on hardware" for things that are built but untested.
- Do not invent screen labels. If you cannot confirm a label in the repository, describe the action ("open Settings") and add `<!-- verify label -->` to the Markdown.
- No speed, battery or security-superlative claims, and no numbers that were not measured.
- Do not copy text from Ubuntu or other documentation; paraphrase and link. Ubuntu's own documentation covers behaviour that is identical on Ubuntu 26.04: <https://ubuntu.com/server/docs> and <https://ubuntu.com/desktop/docs>.
- Write "based on Ubuntu 26.04 LTS" and use the name Ubuntu only for the base system or Ubuntu's own things.
- Plain words, short sentences, "you", active voice, American spelling. No "simply" and no "just".
- Screenshots must be real. Put them in `src/assets/screens/` and embed with a relative path and alt text, counting the `../` from the page to `src/`.

## Preview locally

From `docs-site/`:

```bash
npm install
npm run dev
```

The development server listens on `http://localhost:4321` and reloads when you save a file. To check the production build:

```bash
npm run build
npm run preview
```

## The link check

The build runs the `starlight-links-validator` plugin (configured in `astro.config.mjs`). A broken internal link fails `npm run build`, and the Drone `docs` pipeline fails with it. That is why links must be root-relative with a trailing slash and must point at a page that exists. If you rename or remove a page, search for links to it:

```bash
grep -rn "/developers/old-name/" src/content/docs
```

## Publishing

1. Open a pull request, or push to `master` if you have the right.
2. When a push to `master` changes `docs-site/**` or `ci/deploy-docs.sh`, the Drone `docs` pipeline runs `ci/deploy-docs.sh`: `npm ci`, `npm run build`, then `rclone sync dist r2:nubo-docs`.
3. The Worker `nubo-docs` serves the bucket at `https://docs.nubosuite.tech`. It serves HTML with `max-age=300` and other files with a one-year `immutable` header, so a changed page can take up to five minutes to show for people who loaded it recently. Every page also carries "last updated" and "edit this page" links.

`rclone sync` deletes remote files that are no longer in the build. A page you delete disappears from the site on the next deploy.

## Verify

1. `npm run build` ends without errors and without link-validator messages.
2. Open the page in the preview and check that it appears in the right place in the sidebar, in the right order.
3. After the deploy, open the page at `https://docs.nubosuite.tech/` and check it.

## Troubleshooting

- **The build fails with an "invalid link" message.** The link target does not exist or lacks the trailing slash. Fix the path or add the page.
- **My page is not in the sidebar.** Check that the file is in a section folder, ends in `.md` or `.mdx`, and has `title` in its frontmatter.
- **The page is in the wrong order.** Check `sidebar.order`; equal values fall back to alphabetical order.
- **An image does not load.** Count the `../` again from the page to `src/assets/`. A page at `src/content/docs/developers/x.md` uses `../../../assets/screens/name.jpg`.
- **`npm run dev` shows old content.** Stop the server and start it again.
- **The change is merged but the site is the same.** Wait five minutes for the HTML cache, and check that the `docs` pipeline ran in Drone and that your change touched `docs-site/`.

## See also

- [CI with Drone](/developers/ci-with-drone/)
- [Developers](/developers/)
