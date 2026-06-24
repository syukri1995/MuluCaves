import { site } from "../config/site";
import { SectionHead } from "./SectionHead";
import { Photo } from "./Photo";

/**
 * Chapter 03 — Where to stay.
 * Editorial table-of-contents style: each stay is a row with a small
 * roman numeral, name, body, photo, and price. Alternating layout
 * (image left, text right; then swapped) for visual rhythm.
 */
export function Stay() {
  return (
    <section id="stay" className="rule-t">
      <div className="max-w-7xl mx-auto px-6 md:px-10 py-20 lg:py-28">
        <SectionHead
          numeral={site.stay.numeral}
          eyebrow={site.stay.eyebrow}
          title={site.stay.title}
        />

        <p className="mt-8 max-w-2xl text-ink/75 text-lg leading-relaxed">
          {site.stay.intro}
        </p>

        <ol className="mt-16 divide-y divide-ink/15 border-y divide-ink/15">
          {site.stay.items.map((s, i) => (
            <li key={s.n} className="grid md:grid-cols-12 gap-6 md:gap-10 py-10 items-start">
              <span className="md:col-span-1 font-display text-copper text-5xl leading-none self-start">
                {s.n}
              </span>

              <div className={`md:col-span-5 ${i % 2 === 1 ? "md:order-2" : ""}`}>
                <Photo label={s.name} sub="Suite" ratio="4 / 3" />
              </div>

              <div className={`md:col-span-6 flex flex-col gap-3 ${i % 2 === 1 ? "md:order-1" : ""}`}>
                <h3 className="display-l text-2xl md:text-3xl">{s.name}</h3>
                <p className="text-ink/75 leading-relaxed">{s.body}</p>
                <p className="eyebrow text-copper mt-2">From {s.from}</p>
              </div>
            </li>
          ))}
        </ol>
      </div>
    </section>
  );
}