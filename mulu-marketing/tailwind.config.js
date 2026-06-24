/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        ink:    "var(--ink)",
        cream:  "var(--cream)",
        copper: "var(--copper)",
        "copper-dim": "var(--copper-dim)",
        moss:   "var(--moss)",
        bone:   "var(--bone)",
        "bio-glow": "var(--bio-glow)",
      },
      fontFamily: {
        display: ['"Cormorant Garamond"', "Georgia", "serif"],
        sans:    ['"Plus Jakarta Sans"', "system-ui", "sans-serif"],
        mono:    ['"JetBrains Mono"', "ui-monospace", "monospace"],
      },
      letterSpacing: {
        tightest: "-0.04em",
      },
    },
  },
  plugins: [],
};