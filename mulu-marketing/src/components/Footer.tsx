import { site } from "../config/site";

/**
 * Footer — letterpress colophon.
 * 4-column grid: brand & colophon / address / section links / beyond.
 * Hairline rule + tiny copyright at the bottom.
 */
export function Footer() {
  return (
    <footer className="rule-t bg-cream">
      <div className="max-w-7xl mx-auto px-6 md:px-10 py-16 grid md:grid-cols-12 gap-10">
        <div className="md:col-span-5 flex flex-col gap-4">
          <h3 className="display-l text-3xl md:text-4xl">{site.brand}</h3>
          <p className="text-ink/70 max-w-md leading-relaxed text-sm">
            {site.footer.colophon}
          </p>
        </div>

        <div className="md:col-span-3 flex flex-col gap-3">
          <span className="eyebrow text-ink/50">Field Office</span>
          <address className="not-italic text-sm leading-relaxed">
            {site.footer.address.map((line) => (
              <div key={line} className="text-ink/80">{line}</div>
            ))}
          </address>
        </div>

        {site.footer.sections.map((sec) => (
          <nav key={sec.title} className="md:col-span-2 flex flex-col gap-3">
            <span className="eyebrow text-ink/50">{sec.title}</span>
            <ul className="flex flex-col gap-2">
              {sec.items.map((item) => (
                <li key={item.label}>
                  <a
                    href={item.href}
                    target={"external" in item && item.external ? "_blank" : undefined}
                    rel={"external" in item && item.external ? "noopener noreferrer" : undefined}
                    className="text-sm text-ink/80 hover:text-copper transition-colors"
                  >
                    {item.label}
                  </a>
                </li>
              ))}
            </ul>
          </nav>
        ))}
      </div>

      <div className="rule-t">
        <div className="max-w-7xl mx-auto px-6 md:px-10 py-6 flex flex-col md:flex-row items-start md:items-center justify-between gap-3">
          <span className="eyebrow text-ink/40">
            © {new Date().getFullYear()} {site.brand} · {site.domain}
          </span>
          <span className="eyebrow text-ink/40">
            Composed in Sarawak · Printed on the web
          </span>
        </div>
      </div>
    </footer>
  );
}