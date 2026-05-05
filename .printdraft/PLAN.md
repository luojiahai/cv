# Plan: printdraft — Document Generator CLI & Library

## Context

`printdraft` is an npm CLI tool and library for creating professional documents: **resumes and cover letters**. Users pick from built-in styles, customize them, and export to PDF.

**Scope (deliberately limited):**
- Document types: resume + cover letter (built-in, not extensible by community)
- Styles: 3 built-in resume themes + 1 cover letter theme; user can adjust style variables
- PDF export: Puppeteer/headless Chrome
- Web editor: Vue 3 + Vite, split layout (YAML editor + live preview + style panel)
- Language: English + Chinese

---

## New Repo: `luojiahai/printdraft`

```
printdraft/
├── packages/
│   ├── printdraft/                       # Main CLI + web app (npm: printdraft)
│   │   ├── bin/
│   │   │   └── printdraft.js            # CLI entry point
│   │   ├── src/
│   │   │   ├── cli/
│   │   │   │   ├── init.ts            # `printdraft init` — scaffold document
│   │   │   │   ├── dev.ts             # `printdraft dev` — start web editor
│   │   │   │   └── export.ts          # `printdraft export` — Puppeteer → PDF
│   │   │   ├── app/                   # Vue 3 web app
│   │   │   │   ├── index.html
│   │   │   │   ├── main.ts
│   │   │   │   ├── App.vue
│   │   │   │   └── components/
│   │   │   │       ├── Editor.vue         # Left: CodeMirror YAML editor
│   │   │   │       ├── Preview.vue        # Right: live document preview
│   │   │   │       └── StylePanel.vue     # Drawer: style switcher + variables
│   │   │   ├── renderer/
│   │   │   │   └── parser.ts          # Parse + validate YAML frontmatter
│   │   │   ├── themes/                # Built-in themes (each is a Vue component + CSS + schema)
│   │   │   │   ├── resume-classic/    # LaTeX-inspired, matches resume.cls
│   │   │   │   │   ├── index.ts       # Theme entry: exports metadata + schema + component
│   │   │   │   │   ├── Template.vue   # Vue render component
│   │   │   │   │   └── style.css      # CSS with custom properties
│   │   │   │   ├── resume-modern/     # Clean minimal with color accent
│   │   │   │   │   └── ...
│   │   │   │   ├── resume-compact/    # Dense single-column ATS-friendly
│   │   │   │   │   └── ...
│   │   │   │   └── cover-letter/      # Formal letter layout
│   │   │   │       └── ...
│   │   │   └── server/
│   │   │       └── index.ts           # Express API + chokidar + WebSocket
│   │   ├── templates/
│   │   │   ├── resume-empty.md        # Empty resume YAML template
│   │   │   └── cover-letter-empty.md  # Empty cover letter YAML template
│   │   ├── vite.config.ts
│   │   ├── tsconfig.json
│   │   └── package.json
│   └── create-printdraft/               # npm init printdraft shim
│       ├── index.js
│       └── package.json
├── .github/
│   └── workflows/
│       └── publish.yml
└── README.md
```

---

## Document Source Format

All documents use `document.md` with YAML frontmatter only.

### Resume (`theme: resume-classic` / `resume-modern` / `resume-compact`)
```yaml
---
theme: resume-classic
lang: en
style:
  primaryColor: "#000000"
  fontFamily: "Times New Roman"
  fontSize: "10pt"
name: "Last, First"
contact:
  phone: "+1 (555) 000-0000"
  email: "email@example.com"
  linkedin: "username"
sections:
  - title: "Education"
    entries:
      - type: heading1+subheading1
        institution: "University Name"
        location: "City, State"
        degree: "B.S. Computer Science"
        date: "May 2024"
        bullets:
          - "GPA: 3.9"
  - title: "Experience"
    entries:
      - type: heading1+subheading1
        organization: "Company Name"
        location: "City, State"
        title: "Software Engineer"
        date: "Jun 2023 – Present"
        bullets:
          - "Action + Task → Outcome"
  - title: "Skills & Interests"
    entries:
      - type: skills
        categories:
          - name: "Programming"
            content: "Python, Go, TypeScript"
---
```

### Cover Letter (`theme: cover-letter`)
```yaml
---
theme: cover-letter
lang: en
style:
  fontFamily: "Georgia"
  fontSize: "11pt"
sender:
  name: "John Smith"
  address: "123 Main St, City, State"
  email: "john@example.com"
  date: "May 5, 2026"
recipient:
  name: "Hiring Manager"
  company: "Company Name"
  address: "456 Corp Ave, City, State"
subject: "Application for Software Engineer Position"
body:
  - "Opening paragraph."
  - "Body paragraph."
  - "Closing paragraph."
closing: "Sincerely"
---
```

**Resume entry types:**

| type | Usage |
|---|---|
| `heading1+subheading1` | Education, Experience (institution + role + bullets) |
| `heading1+subheading2` | Activities (institution + role, no bullets) |
| `heading2` | Awards with description |
| `heading3` | Simple awards |
| `skills` | Skills categories |

---

## Built-in Themes

| Theme key | Style description | Style variables |
|---|---|---|
| `resume-classic` | Traditional, LaTeX-inspired (mirrors `resume.cls`) | font, fontSize, color |
| `resume-modern` | Clean minimal with color accent bar | font, fontSize, accentColor |
| `resume-compact` | Dense single-column, ATS-friendly | font, fontSize, lineHeight |
| `cover-letter` | Formal block-letter layout | font, fontSize, color |

Each theme is a directory under `src/themes/` containing:
- `index.ts` — exports theme metadata, zod schema, style variable declarations
- `Template.vue` — Vue SFC that renders the document
- `style.css` — CSS using custom properties (`--printdraft-fontFamily`, `--printdraft-fontSize`, etc.)

---

## CLI Commands

### `printdraft init` (or `npm init printdraft`)
1. Ask: document type — Resume or Cover Letter
2. Ask: which theme (show list for chosen type)
3. Ask: language (en / cn)
4. Collect basic info from user (name, contact)
5. Write `document.md` with frontmatter + placeholder content
6. Write `.gitignore`
7. Offer `git init` + initial commit
8. Print: "Run `printdraft dev` to start editing"

### `printdraft dev`
1. Read `document.md` → determine active theme
2. Start Express server (file API + WebSocket)
3. Start Vite dev server (Vue 3 app) on `localhost:3000`
4. Open browser

**Web app — 2-panel layout + style drawer:**
- **Left panel**: CodeMirror 6 YAML editor, auto-saves (debounced 300ms)
- **Right panel**: Live preview via active theme's `Template.vue`
- **Style drawer** (toggled via button):
  - Theme switcher: shows all 4 themes with label and document type tag
  - Style variable controls per theme (color pickers, font selectors, size dropdowns)
  - Changes write to `style:` block in `document.md` in real time

### `printdraft export [--output <path>]`
1. Read `document.md`, apply theme + style variables
2. Build static preview (or use headless server)
3. Puppeteer: `page.pdf({ format: 'Letter', printBackground: true, margin: '0.4in' })`
4. Save `document.pdf`

---

## Key Implementation Details

### Theme Interface (`src/themes/index.ts` — exported as library)
```typescript
export interface Theme {
  key: string;
  displayName: string;
  documentType: 'resume' | 'cover-letter';
  schema: ZodSchema;
  styleVariables: StyleVariable[];
  component: Component;  // Vue 3 component
}

export interface StyleVariable {
  key: string;
  label: string;
  type: 'color' | 'font' | 'select';
  default: string;
  options?: string[];  // for 'select' and 'font' types
}
```

### `app/components/StylePanel.vue`
- Lists available themes grouped by document type
- On theme switch: updates `theme:` field in YAML
- For each `styleVariable` in the active theme: renders the appropriate control
- Color → `<input type="color">`
- Font → `<select>` with options
- Select (size etc.) → `<select>`
- On change: debounced write to `style:` YAML block + injects CSS vars into preview frame

### `app/components/Preview.vue`
- Dynamically imports the active theme's `Template.vue`
- Receives parsed document data + resolved style variables as props
- Injects `--printdraft-*` CSS custom properties into a scoped container

### `packages/create-printdraft/index.js`
```js
#!/usr/bin/env node
try {
  require('child_process').execSync('printdraft init', { stdio: 'inherit' });
} catch {
  require('child_process').execSync('npx printdraft@latest init', { stdio: 'inherit' });
}
```

---

## Implementation Sequence

1. **Create GitHub repo** `luojiahai/printdraft` via MCP tool
2. **Initialize monorepo** at `/home/user/printdraft/` with pnpm workspaces
3. **`packages/printdraft` setup:** `package.json`, `tsconfig.json`, `vite.config.ts`
   - deps: `vue`, `vite`, `@vitejs/plugin-vue`, `codemirror`, `@codemirror/lang-yaml`, `js-yaml`, `zod`, `express`, `chokidar`, `chalk`, `commander`, `puppeteer`
4. **Theme types** (`src/themes/index.ts`) — `Theme` and `StyleVariable` interfaces
5. **`renderer/parser.ts`** — YAML parse + theme schema validation
6. **`resume-classic` theme** — mirrors `resume.cls` style (reference `/home/user/resume-template/resume.cls`)
7. **`cover-letter` theme** — second theme, validates cover letter schema
8. **`resume-modern` theme** — third theme
9. **`resume-compact` theme** — fourth theme
10. **`app/components/Preview.vue`** — dynamic theme renderer
11. **`app/components/StylePanel.vue`** — theme switcher + style controls
12. **`app/components/Editor.vue`** — CodeMirror YAML editor
13. **`app/App.vue`** — two-panel + drawer layout
14. **`server/index.ts`** — Express API + WebSocket
15. **`cli/dev.ts`**, **`cli/init.ts`**, **`cli/export.ts`**
16. **`bin/printdraft.js`** — commander CLI entry
17. **Empty templates** (`templates/resume-empty.md`, `templates/cover-letter-empty.md`)
18. **`packages/create-printdraft`** shim
19. **`README.md`**, **`.github/workflows/publish.yml`**
20. **Push** to `luojiahai/printdraft`

---

## Critical Files

| File | Purpose |
|---|---|
| `packages/printdraft/src/themes/resume-classic/Template.vue` | First theme renderer (CSS mirrors `resume.cls`) |
| `packages/printdraft/src/themes/resume-classic/style.css` | CSS custom properties for classic theme |
| `packages/printdraft/src/app/components/StylePanel.vue` | Theme switcher + style variable controls |
| `packages/printdraft/src/app/components/Preview.vue` | Dynamic theme renderer |
| `packages/printdraft/src/app/components/Editor.vue` | CodeMirror YAML editor |
| `packages/printdraft/src/cli/export.ts` | Puppeteer PDF generation |
| `packages/printdraft/src/cli/init.ts` | Interactive scaffold (type → theme → info) |

`resume.cls` at `/home/user/resume-template/resume.cls` is visual reference for `resume-classic` CSS — not bundled.

---

## Verification

```bash
npm init printdraft              # choose Resume → resume-classic → fill info
printdraft dev                   # localhost:3000, switch to resume-modern in style panel
printdraft export                # document.pdf via Puppeteer
```

### Edge cases
- Unknown theme in `document.md`: error with available theme list
- Theme switch: style variables reset to new theme's defaults
- Chinese (`lang: cn`): CJK font stack active; Puppeteer renders correctly
- Long document: Puppeteer paginates via `@media print`
- Port conflict on 3000: auto-selects next available port
