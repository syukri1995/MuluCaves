import { site } from "../config/site";
import { Photo } from "./Photo";

/**
 * Hero — full-bleed.
 *   - Top bar: issue + tagline
 *   - Dominant full-bleed photograph (60vh) with overlaid headline
 *   - Right-of-headline: copper rule + subtitle + byline + CTA
 *   - Bottom strip: 4 chapter thumbnails as a navigation rail
 *
 * Orchestrated first-paint stagger via .rise / .rise-N classes.
 */
export function Hero() {
  return (
    <header className="relative">
      {/* Top bar */}
      <div className="rule-b">
        <div className="mx-auto max-w-7xl px-6 md:px-10 py-4 flex items-center justify-between">
          <span className="eyebrow text-ink/70">{site.tagline}</span>
          <span className="eyebrow text-ink/50">{site.hero.issue}</span>
        </div>
      </div>

      {/* Dominant photo + overlaid headline */}
      <div className="relative">
        <Photo label="Hero · The Pinnacles at dawn" sub="Cover plate" ratio="21 / 9" className="w-full" />
        <div className="absolute inset-0 bg-gradient-to-t from-cream via-cream/40 to-transparent" />

        <div className="absolute inset-0 flex items-end">
          <div className="max-w-7xl mx-auto w-full px-6 md:px-10 pb-10 md:pb-16 grid lg:grid-cols-12 gap-8 items-end">
            <h1 className="lg:col-span-9 hero-headline display-xl rise rise-1">
              <span className="block">Where the rainforest</span>
              <span className="block">
                meets the world&apos;s <em className="italic text-copper not-italic font-light">largest</em> caves.
              </span>
            </h1>

            <aside className="lg:col-span-3 lg:pl-6 flex flex-col gap-5 rise rise-2 hidden md:flex">
              <div className="h-px w-12 bg-copper" />
              <p className="text-ink/85 text-base leading-relaxed">
                {site.hero.subtitle}
              </p>
              <p className="eyebrow text-ink/50">{site.hero.byline}</p>
              <a
                href={site.hero.cta.href}
                className="self-start inline-flex items-center gap-2 text-ink border-b border-ink/40 hover:border-copper hover:text-copper transition-colors pb-1"
              >
                <span className="eyebrow">{site.hero.cta.text}</span>
                <span aria-hidden>↓</span>
              </a>
            </aside>
          </div>
        </div>
      </div>

      {/* Mobile-only sidebar */}
      <div className="md:hidden rule-t">
        <div className="max-w-7xl mx-auto px-6 py-6 flex flex-col gap-4">
          <p className="text-ink/80 text-sm leading-relaxed">{site.hero.subtitle}</p>
          <a
            href={site.hero.cta.href}
            className="self-start inline-flex items-center gap-2 text-ink border-b border-ink/40 pb-1"
          >
            <span className="eyebrow">{site.hero.cta.text}</span>
            <span aria-hidden>↓</span>
          </a>
        </div>
      </div>

      {/* Photo strip — chapter rail */}
      <div className="rule-t">
        <div className="max-w-7xl mx-auto px-6 md:px-10 py-6 grid grid-cols-2 md:grid-cols-4 gap-4">
          {site.hero.chapters.map((c) => (
            <a
              key={c.num}
              href={`#${c.label.toLowerCase().replace(/\s+/g, "")}`}
              className="group block"
            >
              <Photo label={`${c.num} · ${c.label}`} sub="Chapter" ratio="4 / 3" />
            </a>
          ))}
        </div>
      </div>
    </header>
  );
}