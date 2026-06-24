import { Hero } from "./components/Hero";
import { Park } from "./components/Park";
import { Experiences } from "./components/Experiences";
import { Stay } from "./components/Stay";
import { Inquire } from "./components/Inquire";
import { Footer } from "./components/Footer";

import { useEffect, useState, useRef } from "react";

export default function App() {
  const [scrollProgress, setScrollProgress] = useState(0);
  const [isDark, setIsDark] = useState(false);
  const inquireRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleScroll = () => {
      const totalHeight = document.documentElement.scrollHeight - window.innerHeight;
      if (totalHeight > 0) {
        const progress = (window.scrollY / totalHeight) * 100;
        setScrollProgress(progress);
      }
      
      // Toggle dark cavern theme slightly before Inquire section enters the screen
      if (inquireRef.current) {
        const rect = inquireRef.current.getBoundingClientRect();
        if (rect.top < window.innerHeight * 0.65) {
          setIsDark(true);
        } else {
          setIsDark(false);
        }
      }
    };

    window.addEventListener("scroll", handleScroll, { passive: true });
    handleScroll(); // Initial call
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <div className={`grain min-h-screen ${isDark ? "cavern-dark bg-cream text-ink" : "bg-cream text-ink"}`}>
      {/* Subterranean light-beam indicator */}
      <div 
        className="fixed left-6 top-0 bottom-0 w-[1px] bg-ink/10 z-50 pointer-events-none hidden lg:block"
        aria-hidden="true"
      >
        <div 
          className="w-full bg-copper transition-all duration-75 relative"
          style={{ 
            height: `${scrollProgress}%`,
            boxShadow: isDark ? "0 0 10px var(--bio-glow)" : "none"
          }}
        >
          {/* Miner's light bulb tip */}
          <div 
            className="absolute bottom-0 left-1/2 -translate-x-1/2 w-2 h-2 rounded-full transition-colors duration-500"
            style={{ 
              backgroundColor: "var(--copper)",
              boxShadow: isDark 
                ? "0 0 12px var(--bio-glow), 0 0 4px var(--bio-glow)" 
                : "0 0 6px var(--copper)"
            }}
          />
        </div>
      </div>

      <Hero />
      <Park />
      <Experiences />
      <Stay />
      <div ref={inquireRef}>
        <Inquire />
      </div>
      <Footer />
    </div>
  );
}