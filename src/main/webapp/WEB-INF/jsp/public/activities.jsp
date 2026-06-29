<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<section id="experiences" class="py-20 md:py-32 bg-gray-50 min-h-screen">
  <div class="container-max">
    <!-- Section Header -->
    <div class="mb-12 animate-fade-in-up opacity-0">
      <p class="eyebrow mb-2">Chapter Two</p>
      <h2 class="text-h2 text-primary mb-6">
        Four ways to spend a <em class="italic font-serif font-light">slow</em> week.
      </h2>
    </div>

    <!-- Search Input (Preserved Logic) -->
    <div class="mb-12 animate-fade-in opacity-0 delay-1">
        <div class="max-w-md">
            <input type="text" id="searchInput" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-primary shadow-sm" placeholder="Search activities... (e.g., cave, canopy)">
        </div>
    </div>

    <!-- Cards Grid -->
    <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6" id="activitiesContainer">
      <c:forEach var="a" items="${activities}" varStatus="status">
        <a href="${pageContext.request.contextPath}/activity?id=${a.id}" class="card overflow-hidden animate-fade-in-up opacity-0 text-decoration-none group" style="animation-delay: ${status.count * 0.1}s">
          <div class="relative h-48 overflow-hidden bg-gray-200">
            <img src="${pageContext.request.contextPath}/${a.imagePath}" alt="${a.name}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" />
          </div>
          <div class="p-6">
            <div class="flex items-start justify-between mb-3">
              <p class="text-3xl font-bold text-accent">0${status.count}</p>
              <p class="eyebrow text-right ml-2">Experience</p>
            </div>
            <h3 class="text-lg font-bold text-dark mb-3 group-hover:text-primary transition-colors">${a.name}</h3>
            <p class="text-sm text-muted leading-relaxed">${a.description}</p>
            <p class="text-sm font-semibold text-accent mt-4">Read more &rarr;</p>
          </div>
        </a>
      </c:forEach>
    </div>
  </div>
</section>

<script>
document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.getElementById('searchInput');
    const container = document.getElementById('activitiesContainer');
    const contextPath = '${pageContext.request.contextPath}';
    
    let debounceTimer;
    let currentAbortController = null;

    searchInput.addEventListener('input', (e) => {
        const query = e.target.value;
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => { fetchActivities(query); }, 300);
    });

    async function fetchActivities(query) {
        if (currentAbortController) currentAbortController.abort();
        currentAbortController = new AbortController();
        try {
            const url = contextPath + '/api/activities?q=' + encodeURIComponent(query);
            const response = await fetch(url, { signal: currentAbortController.signal });
            if (!response.ok) throw new Error('Network response was not ok');
            const data = await response.json();
            renderActivities(data);
        } catch (error) {
            if (error.name !== 'AbortError') console.error('Fetch error:', error);
        }
    }

    function renderActivities(activities) {
        container.innerHTML = '';
        if (activities.length === 0) {
            container.innerHTML = '<div class="col-span-full text-center text-muted"><p>No activities found.</p></div>';
            return;
        }

        activities.forEach((a, index) => {
            const aTag = document.createElement('a');
            aTag.href = contextPath + '/activity?id=' + a.id;
            aTag.className = 'card overflow-hidden animate-fade-in-up opacity-0 delay-1 text-decoration-none group';
            aTag.innerHTML = `
              <div class="relative h-48 overflow-hidden bg-gray-200">
                <img src="\${contextPath}/\${a.imagePath}" alt="\${a.name}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" />
              </div>
              <div class="p-6">
                <div class="flex items-start justify-between mb-3">
                  <p class="text-3xl font-bold text-accent">0\${index + 1}</p>
                  <p class="eyebrow text-right ml-2">Experience</p>
                </div>
                <h3 class="text-lg font-bold text-dark mb-3 group-hover:text-primary transition-colors">\${a.name}</h3>
                <p class="text-sm text-muted leading-relaxed">\${a.description}</p>
                <p class="text-sm font-semibold text-accent mt-4">Read more &rarr;</p>
              </div>
            `;
            container.appendChild(aTag);
        });
    }
});
</script>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>