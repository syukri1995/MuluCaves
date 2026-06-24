import { site } from "../config/site";

/**
 * Chapter 04 — Inquiry CTA.
 * Full-bleed copper background, inverted text. Asymmetric: huge serif
 * headline bleeding left, single ask + button right.
 */
export function Inquire() {
  return (
    <section id="inquire" className="bg-cream text-ink rule-t">
      <div className="max-w-7xl mx-auto px-6 md:px-10 py-24 lg:py-32 grid lg:grid-cols-12 gap-10 items-end">
        <div className="lg:col-span-8">
          <div className="flex items-baseline gap-6 mb-6">
            <span className="section-numeral select-none" style={{ color: "var(--copper)" }}>
              {site.inquire.numeral}
            </span>
            <span className="eyebrow text-ink/60">{site.inquire.eyebrow}</span>
          </div>
          <h2 className="display-xl text-5xl md:text-7xl lg:text-8xl">
            {site.inquire.title}
          </h2>
        </div>

        <aside className="lg:col-span-4 lg:pl-10 flex flex-col gap-6">
          <p className="text-ink/80 leading-relaxed text-lg">{site.inquire.body}</p>
          <div className="h-px w-12 bg-copper" />
          <a
            href={site.inquire.cta.href}
            className="self-start inline-flex items-center gap-3 text-cream bg-copper border border-copper/20 hover:bg-transparent hover:text-copper px-6 py-3.5 transition-all duration-300 eyebrow shadow-sm hover:shadow-[0_0_20px_rgba(198,241,58,0.35)]"
          >
            {site.inquire.cta.text}
          </a>
          <p className="eyebrow text-ink/50">{site.inquire.note}</p>
        </aside>
      </div>
    </section>
  );
}