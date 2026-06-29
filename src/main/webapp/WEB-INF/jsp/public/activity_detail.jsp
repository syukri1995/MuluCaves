<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<section class="py-20 md:py-32 bg-light min-h-screen">
  <div class="container-max">
    <c:choose>
        <c:when test="${not empty activity}">
            <!-- Header -->
            <div class="mb-12 animate-fade-in-up opacity-0">
              <a href="${pageContext.request.contextPath}/activities" class="text-sm font-semibold text-accent hover:text-primary transition-colors mb-4 inline-block">&larr; Back to Activities</a>
              <h1 class="text-display-lg text-primary mb-6">${activity.name}</h1>
              <p class="text-xl text-muted max-w-3xl leading-relaxed">${activity.description}</p>
            </div>
            
            <!-- Hero Image -->
            <div class="w-full h-96 md:h-[32rem] overflow-hidden rounded-2xl mb-16 animate-fade-in opacity-0 delay-1">
                <img src="${pageContext.request.contextPath}/${activity.imagePath}" alt="${activity.name}" class="w-full h-full object-cover shadow-lg" />
            </div>

            <!-- Content -->
            <div class="grid lg:grid-cols-3 gap-16">
                <div class="lg:col-span-2 animate-slide-in-left opacity-0 delay-2">
                    <h3 class="text-3xl font-serif text-dark mb-6">About the Experience</h3>
                    <div class="prose max-w-none text-dark/80 text-lg leading-relaxed mb-8">
                        <c:choose>
                            <c:when test="${not empty activity.longDescription}">
                                ${activity.longDescription}
                            </c:when>
                            <c:otherwise>
                                <p>Deep within the heart of the Gunung Mulu National Park lies an experience that defies all expectations. Our guided tours offer unparalleled access to pristine rainforests and colossal cave networks that have evolved over millions of years. Whether you are navigating winding trails beneath the dense canopy or standing in awe of giant limestone formations, every moment is designed to connect you intimately with nature.</p>
                                <p>Prepared exclusively for travelers seeking an authentic adventure, this journey requires a reasonable level of fitness and a spirit of discovery. Our local Penan and Berawan guides are deeply knowledgeable about the local flora, fauna, and geology, ensuring that you return not just with stunning photographs, but with a profound understanding of this UNESCO World Heritage Site.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h3 class="text-2xl font-serif text-dark mb-6 border-t border-gray-200 pt-8">Sample Itinerary</h3>
                    <ul class="space-y-4 mb-8">
                        <li class="flex gap-4"><span class="font-bold text-accent">08:00 AM</span> <span class="text-dark/80">Meet at Park Headquarters for safety briefing.</span></li>
                        <li class="flex gap-4"><span class="font-bold text-accent">09:00 AM</span> <span class="text-dark/80">Commence the guided journey via longboat or forest trail.</span></li>
                        <li class="flex gap-4"><span class="font-bold text-accent">12:30 PM</span> <span class="text-dark/80">Packed lunch in the wilderness.</span></li>
                        <li class="flex gap-4"><span class="font-bold text-accent">03:00 PM</span> <span class="text-dark/80">Return journey back to base.</span></li>
                    </ul>
                </div>

                <div class="animate-fade-in-up opacity-0 delay-3">
                    <div class="bg-white p-8 rounded-2xl shadow-sm border border-gray-100 sticky top-24">
                        <h4 class="font-bold text-xl mb-4">Quick Facts</h4>
                        <div class="space-y-4 mb-8">
                            <div><p class="eyebrow text-muted mb-1">Duration</p><p class="font-medium text-dark">Half-Day (Approx 4 hours)</p></div>
                            <div><p class="eyebrow text-muted mb-1">Fitness Level</p><p class="font-medium text-dark">Moderate</p></div>
                            <div><p class="eyebrow text-muted mb-1">Price</p><p class="font-medium text-dark">RM 85.00 per person</p></div>
                            <div>
                                <p class="eyebrow text-muted mb-1">What to Bring</p>
                                <ul class="list-disc list-inside text-sm text-dark/80 mt-1">
                                    <li>Sturdy hiking shoes</li>
                                    <li>Headlamp or torch</li>
                                    <li>Insect repellent</li>
                                    <li>Water bottle (1.5L)</li>
                                </ul>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/inquiry" class="btn btn-primary w-full py-3">Book this Activity</a>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-32">
                <h1 class="text-3xl font-bold text-dark mb-4">Activity Not Found</h1>
                <p class="text-muted mb-8">The activity you are looking for does not exist or has been removed.</p>
                <a href="${pageContext.request.contextPath}/activities" class="btn btn-outline">Browse Activities</a>
            </div>
        </c:otherwise>
    </c:choose>
  </div>
</section>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>
