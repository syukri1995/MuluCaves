import { site } from "../config/site";
import { SectionHead } from "./SectionHead";
import { Photo } from "./Photo";

/**
 * Chapter 01 — The Park.
 * Asymmetric two-column: large pull-quote on the left (span 7),
 * paragraph + metadata table on the right (span 4), with the
 * numeral spanning the top.
 */
export function Park() {
  return (
    <section id="park" className="rule-t">
      <div className="max-w-7xl mx-auto px-6 md:px-10 py-20 lg:py-28">
        <SectionHead
          numeral={site.park.numeral}
          eyebrow={site.park.eyebrow}
          title={site.park.title}
        />

        <div className="mt-16 grid lg:grid-cols-12 gap-10">
          <blockquote className="lg:col-span-7 display-l text-3xl md:text-4xl lg:text-5xl leading-tight">
            {site.park.pull}
          </blockquote>

          <div className="lg:col-span-4 lg:col-start-9 flex flex-col gap-8">
            {site.park.body.map((p, i) => (
              <p key={i} className="text-ink/80 leading-relaxed">
                {p}
              </p>
            ))}

            <dl className="rule-t pt-6 grid grid-cols-2 gap-y-4 gap-x-6">
              {site.park.meta.map((m) => (
                <div key={m.k} className="flex flex-col">
                  <dt className="eyebrow text-ink/50">{m.k}</dt>
                  <dd className="font-mono text-sm mt-1">{m.v}</dd>
                </div>
              ))}
            </dl>
          </div>
        </div>

        {/* Editorial photo spread */}
        <div className="mt-16 grid md:grid-cols-12 gap-4">
          <Photo label="Plate I"   sub="Deer Cave passage"   className="md:col-span-8" ratio="16 / 9" />
          <Photo label="Plate II"  sub="Limestone spires"    className="md:col-span-4" ratio="4 / 5" />
        </div>
      </div>
    </section>
  );
}