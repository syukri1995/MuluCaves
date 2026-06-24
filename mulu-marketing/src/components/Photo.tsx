/**
 * Honest placeholder block — striped diagonal gradient with a small
 * caption. No fake photography. 100% w × aspect, with absolute-positioned
 * caption pinned to bottom-left. Replace with <img> when real photos land.
 */
export function Photo({
  label,
  sub,
  ratio = "4 / 3",
  className = "",
}: {
  label: string;
  sub?: string;
  ratio?: string;
  className?: string;
}) {
  return (
    <figure className={`relative overflow-hidden ${className}`} style={{ aspectRatio: ratio }}>
      <div className="absolute inset-0 placeholder" />
      <figcaption className="absolute bottom-0 left-0 right-0 p-4 flex items-end justify-between text-ink/70">
        <span className="eyebrow">{label}</span>
        {sub && <span className="eyebrow opacity-60">{sub}</span>}
      </figcaption>
    </figure>
  );
}