<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<section id="park" class="py-20 md:py-32 bg-light min-h-screen">
  <div class="container-max">
    <!-- Header -->
    <div class="mb-16 animate-fade-in-up opacity-0">
      <p class="eyebrow mb-2">Chapter One</p>
      <h2 class="text-h2 text-primary mb-6">A cathedral <em class="italic font-serif font-light">older</em> than memory.</h2>
      <p class="text-lg text-muted max-w-3xl leading-relaxed">“A walk into Deer Cave is a walk into a scale of nature we have forgotten how to read.”</p>
    </div>
    
    <!-- Content Grid -->
    <div class="grid lg:grid-cols-2 gap-12 md:gap-16 mb-16">
      <div class="animate-slide-in-left opacity-0 delay-2">
        <p class="text-dark/80 text-base leading-relaxed mb-6">Gunung Mulu rises in the north-eastern corner of Sarawak, draped in primary rainforest that has never felt a road. The park holds some of the largest cave passages on Earth — Deer Cave alone is taller than the Statue of Liberty and wide enough to fly a small aircraft through.</p>
        <p class="text-dark/80 text-base leading-relaxed mb-6">It is also home to the Pinnacles: a forest of razor limestone spires that climb forty-five metres above the canopy. They are not climbed without a guide, and they are not forgotten once seen.</p>
        
        <div class="mt-12 pt-8 border-t border-gray-200">
          <div class="grid grid-cols-2 gap-8">
            <div><p class="eyebrow mb-2">Established</p><p class="text-lg font-medium text-dark">1985</p></div>
            <div><p class="eyebrow mb-2">Heritage</p><p class="text-lg font-medium text-dark">UNESCO, 2000</p></div>
            <div><p class="eyebrow mb-2">Area</p><p class="text-lg font-medium text-dark">528 km²</p></div>
            <div><p class="eyebrow mb-2">Coordinates</p><p class="text-lg font-medium text-dark">4.05° N · 114.92° E</p></div>
          </div>
        </div>
      </div>
      
      <div class="animate-fade-in opacity-0 delay-3">
        <div class="card overflow-hidden">
          <img src="${pageContext.request.contextPath}/images/hero/explore-hero.jpg" alt="Deer Cave passage" class="w-full object-cover" style="aspect-ratio: 4/5;" />
        </div>
      </div>
    </div>
    
    <!-- Original Lightbox Gallery -->
    <div class="mt-16 animate-fade-in-up opacity-0 delay-4">
      <h3 class="text-xl font-bold text-dark mb-6">Park Gallery</h3>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <c:forEach var="i" begin="1" end="8">
          <a href="${pageContext.request.contextPath}/images/gallery/gallery-${i}.jpg" data-lightbox="mulu-gallery" class="block card overflow-hidden group">
            <img src="${pageContext.request.contextPath}/images/gallery/gallery-${i}.jpg" alt="Gallery ${i}" class="w-full aspect-square object-cover transition-transform duration-500 group-hover:scale-110" />
          </a>
        </c:forEach>
      </div>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>