<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<section id="stay" class="py-20 md:py-32 bg-light min-h-screen">
  <div class="container-max">
    <!-- Section Header -->
    <div class="mb-16 animate-fade-in-up opacity-0">
      <p class="eyebrow mb-2">Chapter Three</p>
      <h2 class="text-h2 text-primary mb-6">Where to <em class="italic font-serif font-light">lay</em> your head.</h2>
      <p class="text-lg text-muted max-w-3xl leading-relaxed">
        Four places, in order of closeness to the caves. Pick your pace — full resort, mid-range lodge, park-run hostel, or quiet homestay.
      </p>
    </div>

    <!-- Accommodations -->
    <div class="space-y-16 md:space-y-24">
      <c:forEach var="r" items="${accommodations}" varStatus="status">
        <div class="grid md:grid-cols-2 gap-8 md:gap-12 items-center animate-fade-in-up opacity-0 ${status.count % 2 == 0 ? 'md:grid-flow-dense' : ''}" style="animation-delay: ${status.count * 0.15}s">
          
          <!-- Image -->
          <div class="card overflow-hidden">
            <img src="${pageContext.request.contextPath}/${r.imagePath}" alt="${r.name}" class="w-full h-full object-cover aspect-[4/3]" />
          </div>

          <!-- Content -->
          <div class="${status.count % 2 == 0 ? 'md:col-start-1' : ''}">
            <div class="mb-4">
              <p class="text-sm font-bold text-accent uppercase tracking-wide">Option 0${status.count}</p>
            </div>
            <h3 class="text-3xl font-bold text-primary mb-4">${r.name}</h3>
            <p class="text-dark/80 leading-relaxed mb-6">${r.description}</p>
            <div class="flex items-center gap-4 pt-6 border-t border-gray-200">
              <a href="${pageContext.request.contextPath}/accommodation-detail?id=${r.id}" class="btn btn-primary">
                View Details
              </a>
              <a href="${pageContext.request.contextPath}/inquiry" class="btn btn-outline border-primary text-primary hover:bg-primary hover:text-white">
                Inquire
              </a>
            </div>
          </div>

        </div>
      </c:forEach>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>