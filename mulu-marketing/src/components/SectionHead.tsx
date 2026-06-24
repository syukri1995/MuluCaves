import type { ReactNode } from "react";

function formatTitle(text: string): ReactNode {
  if (!text.includes("*")) return text;
  const parts = text.split(/\*([^*]+)\*/g);
  return parts.map((part, index) => {
    if (index % 2 === 1) {
      return (
        <em key={index} className="italic text-copper font-serif font-normal">
          {part}
        </em>
      );
    }
    return part;
  });
}

export function SectionHead({
  numeral,
  eyebrow,
  title,
  align = "left",
}: {
  numeral: string;
  eyebrow: string;
  title: ReactNode;
  align?: "left" | "center";
}) {
  const renderedTitle = typeof title === "string" ? formatTitle(title) : title;

  return (
    <header
      className={`flex flex-col gap-6 ${align === "center" ? "items-center text-center" : ""}`}
    >
      <div className={`flex items-baseline gap-6 ${align === "center" ? "justify-center" : ""}`}>
        <span className="section-numeral select-none">{numeral}</span>
        <span className="eyebrow text-ink/60">{eyebrow}</span>
      </div>
      <h2 className="display-l max-w-4xl text-4xl md:text-5xl lg:text-6xl">
        {renderedTitle}
      </h2>
    </header>
  );
}