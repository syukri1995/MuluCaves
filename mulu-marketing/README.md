# Mulu Caves — Marketing One-Pager

A separate editorial site for **Gunung Mulu National Park**, built with the
`frontend-design-ultimate` stack. This is **independent** from the JSP/Servlet
CSC584 coursework in the parent folder — it's a portfolio piece, a polished
front page you can show off before the dashboard.

> **Honest placeholders:** every photo is a striped diagonal block with a
> caption. The design intent carries the placeholders; replace with real
> photography by dropping files in and swapping `<Photo>` for `<img>`.

## Design commitments

- **Tone:** Editorial / travel magazine
- **Display font:** Cormorant Garamond (dramatic serif)
- **Body font:** Plus Jakarta Sans
- **Accent font:** JetBrains Mono (eyebrow labels)
- **Palette:** Ink `#0f1a14` / Cream `#f5efe2` / Copper `#b87333`
- **Atmosphere:** subtle SVG grain overlay (fixed-position, multiply blend)
- **Memorable element:** huge copper section numerals (`§01`, `§02`, …) — magazine-style

## Sections

| # | Section | Notes |
|---|---|---|
| Hero | Full-bleed cover photo + overlaid headline | 21:9 ratio |
| §01 The Park | Asymmetric spread — pull quote + meta table | Editorial |
| §02 Featured Experiences | 2×2 grid with hairline rules, large numerals | |
| §03 Where to Stay | Table-of-contents style, alternating image position | Roman numerals |
| §04 Inquire | Full-bleed dark (ink) section, copper accent | Visual climax |
| Footer | Letterpress colophon, 4-column grid | |

## Stack

- **Vite 8** + **React 18** + **TypeScript**
- **Tailwind CSS 3**
- **Lucide icons** (available if needed)

## Run locally

```bash
npm install
npm run dev      # → http://127.0.0.1:5173
```

## Build for production

```bash
npm run build    # → dist/
```

Output is ~12 KB CSS, ~64 KB gzipped JS — fast.

## Customize

All content lives in **`src/config/site.ts`** — edit that file, not the
components. The structure is:

```typescript
site.hero.{issue, title, subtitle, byline, cta, chapters}
site.park.{numeral, eyebrow, title, pull, body[], meta[]}
site.experiences.{numeral, eyebrow, title, items[]}
site.stay.{numeral, eyebrow, title, intro, items[]}
site.inquire.{numeral, eyebrow, title, body, cta, note}
site.footer.{colophon, address[], sections[]}
```

## Replacing placeholders with real photos

In any component, change:

```tsx
<Photo label="..." sub="..." ratio="4 / 3" />
```

to:

```tsx
<img src="/images/your-photo.jpg" alt="..." className="w-full h-full object-cover" />
```

…and add the file to `public/images/`. The rest of the layout adapts because
every `<Photo>` is a `figure` with `aspectRatio` set inline.