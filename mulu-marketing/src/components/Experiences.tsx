import { site } from "../config/site";
import { SectionHead } from "./SectionHead";
import { Photo } from "./Photo";

/**
 * Chapter 02 — Featured Experiences.
 * Four cards in a 2×2 grid with hairline rules between them. Large
 * numerals in the corners. No card chrome — just typography + photo.
 */
export function Experiences() {
  return (
    <section id="experiences" className="rule-t bg-bone">
      <div className="max-w-7xl mx-auto px-6 md:px-10 py-20 lg:py-28">
        <SectionHead
          numeral={site.experiences.numeral}
          eyebrow={site.experiences.eyebrow}
          title={site.experiences.title}
        />

        <div className="mt-16 grid md:grid-cols-2">
          {site.experiences.items.map((it, i) => (
            <article
              key={it.n}
              className={`
                flex flex-col gap-6 p-8 md:p-10
                rule-t rule-l
                ${i % 2 === 1 ? "md:border-l" : ""}
                ${i >= 2 ? "md:border-t" : ""}
              `}
            >
              <div className="flex items-start justify-between">
                <span className="font-display text-copper text-7xl leading-none">{it.n}</span>
                <span className="eyebrow text-ink/50 self-end">{it.meta}</span>
              </div>

              <Photo label={it.name} sub="Plate" ratio="4 / 3" />

              <h3 className="display-l text-2xl md:text-3xl">{it.name}</h3>
              <p className="text-ink/75 leading-relaxed">{it.body}</p>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}