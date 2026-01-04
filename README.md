# Netfilx_IMDb_movie_ratings
Obtain IMDb ratings from movies that are in Netflix.  The code uses wget to parse the html Netflix code to list the movies and then OMDb to obtain the rating.

This is the github repository for the website: [https://fgonzcat.github.io/Netfilx_IMDb_movie_ratings/intro.html](https://fgonzcat.github.io/Netfilx_IMDb_movie_ratings/intro.html)

Built by [Felipe Gonzalez](https://www.gnm.cl/fgonzalez/)


---

# Build and Publish Jupyter Book Website

This is a quick guide to creating, building, and publishing a Jupyter Book website on GitHub Pages.

---

## 1. Create a new Jupyter Book (once)

```bash
jupyter-book create website_jupyter_book
```

This generates a folder with the template (_config.yml, _toc.yml, intro.md, etc.).

## 2. Add your content
- Add Markdown files for your pages (e.g., horror.md, comedy.md) inside website_jupyter_book/.
- Update _toc.yml to include these pages in the left-hand menu.
- Update _config.yml if you want to link your GitHub repository.

## 3. Build the website locally
```
jupyter-book build website_jupyter_book
```

- This creates _build/html/ with the full HTML site.
- Preview locally:

```
open website_jupyter_book/_build/html/index.html
``

## 4. Publish to GitHub Pages
```
ghp-import -n -p -f website_jupyter_book/_build/html
```

- -n disables Jekyll (important for GitHub Pages)
- -p pushes to gh-pages branch automatically
- -f forces overwrite of the previous build

# 5. Update content in the future
1. Modify or add .md files or scripts.
2. Re-run jupyter-book build website_jupyter_book
3. Re-run ghp-import to update the live site.

## Optional tips
- Keep your scripts and data in the repository; link to raw files from Markdown.
- Use a _generated/ folder for Markdown tables automatically produced by scripts.
- Always preview locally before publishing.
