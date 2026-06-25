<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<header class="relative w-full overflow-hidden bg-dark">
  <div class="relative w-full h-screen md:h-[600px] overflow-hidden">
    <img src="${pageContext.request.contextPath}/images/hero/home-hero.jpg"
         alt="Deer Cave entrance, Gunung Mulu National Park"
         class="w-full h-full object-cover" />

    <!-- Layered readability scrim -->
    <div class="pointer-events-none absolute inset-0 z-[2] bg-gradient-to-t from-black/80 via-black/40 to-transparent"></div>
    <div class="pointer-events-none absolute inset-0 z-[2] bg-[radial-gradient(ellipse_at_center,rgba(0,0,0,0.35),transparent_70%)]"></div>
    <div class="pointer-events-none absolute inset-x-0 top-0 h-1/3 z-[2] bg-gradient-to-b from-black/60 to-transparent"></div>
  </div>

  <div class="absolute inset-0 z-10 flex flex-col justify-end">
    <div class="container-max pb-12 md:pb-20">
      <div class="animate-fade-in-up opacity-0 max-w-3xl [text-shadow:0_2px_8px_rgba(0,0,0,0.55)]">
        <p class="eyebrow mb-4 !text-white/90">Gunung Mulu National Park · Sarawak</p>
        <h1 class="text-display-xl text-white mb-6 leading-tight">Issue No. 1 · Sarawak, Borneo</h1>
        <p class="text-white/95 text-lg max-w-2xl mb-8 leading-relaxed">
          A field journal of place — four signature experiences in a UNESCO World Heritage Site, recorded for the slow traveller.
        </p>
        <div class="flex flex-wrap gap-4">
          <a href="${pageContext.request.contextPath}/explore" class="btn btn-accent text-decoration-none">
            Begin the journey
            <span aria-hidden="true">→</span>
          </a>
          <a href="${pageContext.request.contextPath}/activities" class="btn btn-outline border-white !text-white hover:bg-white hover:!text-dark text-decoration-none">
            Learn More
          </a>
        </div>
      </div>
    </div>
  </div>
  
  <div class="absolute bottom-6 left-1/2 -translate-x-1/2 z-20 animate-bounce">
    <svg class="w-6 h-6 text-white/80" fill="none" stroke="currentColor" viewBox="0 0 24 24" style="filter: drop-shadow(0 1px 2px rgba(0,0,0,0.6))">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3" />
    </svg>
  </div>
</header>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>