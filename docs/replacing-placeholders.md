# Replacing the placeholder images

All photos in `src/main/webapp/images/` are honest placeholder SVGs
(gradient panels with text labels). To use real photography, you have two
options.

## Option A — keep filenames, change extensions

The JSPs reference `*.svg`. Either:

1. **Drop SVGs in** with the same names (e.g. `images/gallery/gallery-1.svg`).
2. **Use PNG/JPG** and update the file references in the JSPs.

Files to replace:

```
src/main/webapp/images/hero/hero-1.svg
src/main/webapp/images/gallery/gallery-1.svg .. gallery-8.svg
src/main/webapp/images/activities/activity-1.svg .. activity-4.svg
src/main/webapp/images/accommodation/room-1.svg .. room-4.svg
src/main/webapp/images/team/developer.svg
```

## Option B — bulk regenerate with different content

`scripts/generate-placeholders.ps1` builds them all. Edit the `$items`
list and re-run:

```powershell
.\scripts\generate-placeholders.ps1
```

## Tips

- Recommended sizes:
  - `hero/*`      — 1920×1080 minimum
  - `gallery/*`   — 800×500  (4:3 or 16:10, displayed in a 3-col grid)
  - `activities/*` — 600×400 (4:3)
  - `accommodation/*` — 800×500
  - `team/developer.svg` — square, 400×400 minimum
- Format: JPEG for photos, PNG for screenshots, WebP if you want to be
  modern (but older browsers may not support it).
- Use `object-fit: cover` is already set in `assets/css/site.css` — your
  image will be cropped to fit, not stretched.