# Minimal Mistakes 4.28.1 Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the complete site runtime to Minimal Mistakes 4.28.1 without loss of the approved site design.

**Architecture:** Import the release runtime from its verified Git tag. Keep personal content and focused local overrides outside the imported theme files.

**Tech Stack:** Jekyll 4.4.1, Minimal Mistakes 4.28.1, Sass, Liquid, JavaScript, Mermaid, MathJax, and GitHub Pages.

**Spec:** `docs/superpowers/specs/2026-08-25-site-modernization.md`

## Global Constraints

- Use `https://plewandow.ski` as the canonical address.
- Keep all posts and personal resources.
- Use Minimal Mistakes release 4.28.1 from Git tag `4.28.1`.
- Keep Inter, the 1440 pixel frame, Mermaid 11.17.2, MathJax 4.1.3, jQuery 3.7.1, and Font Awesome 7.3.1.
- Keep the build compatible with GitHub Pages.
- Do not add the upstream demonstration site or upstream project documentation.

---

### Task 1: Expand the release contract

**Files:**

- Modify: `test/site_contract_test.sh`

**Interfaces:**

- Consumes: The generated `_site` directory.
- Produces: Assertions for the release version and the copy button runtime.

- [x] **Step 1: Write the failing assertions**

Add these assertions after the current layout assertions:

```python
require("Minimal Mistakes 4.28.1 renders the site", "Minimal Mistakes Jekyll Theme 4.28.1" in home)
require("the current theme copy button runtime is present", "Copy to clipboard" in javascript)
require("the copy button is enabled", "window.enable_copy_code_button = true" in article)
```

- [x] **Step 2: Run the contract**

Run: `bash test/site_contract_test.sh`

Expected: The release version assertion fails.

- [x] **Step 3: Keep the failed output as migration evidence**

Do not change the expected version or remove the assertion.

---

### Task 2: Import the complete theme runtime

**Files:**

- Modify: `_data/ui-text.yml`
- Modify: `_includes/**`
- Modify: `_layouts/**`
- Modify: `_sass/minimal-mistakes/**`
- Modify: `assets/js/_main.js`
- Modify: `assets/js/lunr/**`
- Modify: `assets/js/plugins/**`
- Create: the new release files under these directories
- Keep: `_data/navigation.yml`
- Keep: `_includes/head/custom.html`
- Keep: `_sass/_custom.scss`
- Keep: all personal posts, images, and resources

**Interfaces:**

- Consumes: Git reference `refs/remotes/upstream/4.28.1`.
- Produces: The complete Minimal Mistakes 4.28.1 runtime tree.

- [x] **Step 1: Import the release files**

Run this mechanical import from the site worktree:

```bash
git archive refs/remotes/upstream/4.28.1 -- _data/ui-text.yml _includes _layouts _sass/minimal-mistakes assets/js/_main.js assets/js/lunr assets/js/plugins | tar -x --exclude='_includes/head/custom.html'
```

- [x] **Step 2: Add the new release files**

Confirm that these files exist:

```text
_includes/schema.html
_includes/page__related.html
_includes/copyright.html
_sass/minimal-mistakes/_copyright.scss
_sass/minimal-mistakes/skins/_catppuccin_latte.scss
_sass/minimal-mistakes/skins/_catppuccin_mocha.scss
```

- [x] **Step 3: Confirm the personal files remain unchanged**

Run:

```bash
git diff c3692744 -- _posts _resources assets/img _data/navigation.yml _includes/head/custom.html _sass/_custom.scss
```

Expected: No output.

---

### Task 3: Reapply the approved runtime overrides

**Files:**

- Modify: `_includes/head.html`
- Modify: `_includes/footer.html`
- Modify: `assets/css/main.scss`
- Modify: `assets/js/vendor/jquery/jquery-3.7.1.js`
- Delete: `assets/js/vendor/jquery/jquery-3.6.0.js`
- Modify: `package.json`
- Modify: `banner.js`
- Modify: `assets/js/main.min.js`

**Interfaces:**

- Consumes: The imported 4.28.1 templates and scripts.
- Produces: One current browser bundle and the approved visual overrides.

- [x] **Step 1: Pin Font Awesome**

Replace both `@latest` URLs in `_includes/head.html` with `@7.3.1`.

- [x] **Step 2: Restore Mermaid**

Append the approved Mermaid 11.17.2 loader to the new `_includes/footer.html`.

- [x] **Step 3: Restore the site stylesheet entry point**

Keep the current variables before the theme imports.

Keep `@import "custom";` after the theme import.

- [x] **Step 4: Update the browser build**

Set `package.json` to version `4.28.1`.

Keep only `uglify-js` version `^3.19.3` as a development dependency.

Keep the build command with `jquery-3.7.1.js` and every imported theme plug-in.

- [x] **Step 5: Update the generated banner**

Add the Minimal Mistakes 4.28.1 authors and the jQuery 3.7.1 note to `banner.js`.

- [x] **Step 6: Build the JavaScript bundle**

Run:

```bash
npm install
npm run build:js
npm audit
```

Expected: The build succeeds and the audit reports zero vulnerabilities.

---

### Task 4: Update the site configuration

**Files:**

- Modify: `_config.yml`
- Modify: `Gemfile`
- Modify: `Gemfile.lock`

**Interfaces:**

- Consumes: Minimal Mistakes 4.28.1 configuration options.
- Produces: A complete site configuration for the new templates.

- [x] **Step 1: Add the new theme options**

Add `direction`, `enable_copy_code_button`, `copyright`, `copyright_url`, `og_image_alt`, and current Giscus options.

Set `enable_copy_code_button` to `true`.

Set the copyright name and URL to Piotr Lewandowski and the canonical address.

Set `footer.since` to `2019`.

- [x] **Step 2: Add the current Sass options**

Add `quiet_deps: true` and `silence_deprecations: ['import']`.

- [x] **Step 3: Add the optional pagination configuration**

Copy the disabled `pagination` defaults from release 4.28.1.

- [x] **Step 4: Pin the theme gem**

Set the Gemfile entry to this exact value:

```ruby
gem "minimal-mistakes-jekyll", "4.28.1"
```

- [x] **Step 5: Update the Ruby dependencies**

Run:

```bash
bundle update minimal-mistakes-jekyll
bundle exec jekyll doctor
```

Expected: The gem resolves to 4.28.1 and Jekyll reports no configuration problem.

---

### Task 5: Verify and commit the migration

**Files:**

- Modify: `test/site_contract_test.sh`
- Modify: all files from Tasks 2 through 4

**Interfaces:**

- Consumes: The complete migrated site.
- Produces: A reviewed and deployable migration commit.

- [x] **Step 1: Run the site contract**

Run: `bash test/site_contract_test.sh`

Expected: All contract assertions pass.

- [x] **Step 2: Run repository checks**

Run:

```bash
git diff --check
bundle exec jekyll doctor
npm audit
```

Expected: Every command succeeds.

- [x] **Step 3: Test desktop and mobile pages**

Check the home page and a technical article at 1280 pixels and 375 pixels.

Confirm one email link, a working author menu, no horizontal page overflow, four Mermaid diagrams, and 82 MathJax expressions.

Confirm that the code copy button appears and works.

Confirm that the browser console has no error or warning.

- [ ] **Step 4: Commit the migration**

Run:

```bash
git add -A
git commit -m "Migrate the site to Minimal Mistakes 4.28.1"
```

- [ ] **Step 5: Request a final code review**

Use the review range from `409f4613` to the new feature branch head.
