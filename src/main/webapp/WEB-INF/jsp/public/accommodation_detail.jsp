<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<section class="py-20 md:py-32 bg-gray-50 min-h-screen">
  <div class="container-max">
    <c:choose>
        <c:when test="${not empty accommodation}">
            <!-- Header -->
            <div class="mb-12 animate-fade-in-up opacity-0">
              <a href="${pageContext.request.contextPath}/accommodation" class="text-sm font-semibold text-accent hover:text-primary transition-colors mb-4 inline-block">&larr; Back to Accommodation</a>
              <h1 class="text-display-lg text-primary mb-6">${accommodation.name}</h1>
              <p class="text-xl text-muted max-w-3xl leading-relaxed">${accommodation.description}</p>
            </div>
            
            <!-- Hero Image -->
            <div class="w-full h-96 md:h-[32rem] overflow-hidden rounded-2xl mb-16 animate-fade-in opacity-0 delay-1">
                <img src="${pageContext.request.contextPath}/${accommodation.imagePath}" alt="${accommodation.name}" class="w-full h-full object-cover shadow-lg" />
            </div>

            <!-- Content -->
            <div class="grid lg:grid-cols-3 gap-16">
                <div class="lg:col-span-2 animate-slide-in-left opacity-0 delay-2">
                    <h3 class="text-3xl font-serif text-dark mb-6">About the Stay</h3>
                    <div class="prose max-w-none text-dark/80 text-lg leading-relaxed mb-8">
                        <c:choose>
                            <c:when test="${not empty accommodation.longDescription}">
                                ${accommodation.longDescription}
                            </c:when>
                            <c:otherwise>
                                <p>Immerse yourself in the tranquility of the rainforest without giving up comfort. Designed with local timber and sustainable practices, our accommodation seamlessly blends into the stunning natural backdrop of Gunung Mulu National Park. Wake up to the calls of hornbills and gibbons, and fall asleep to the symphony of the jungle.</p>
                                <p>All our rooms are carefully appointed with modern amenities while respecting the ecological sensitivity of the area. We ensure your stay is as peaceful and memorable as the majestic caves you will be exploring during the day.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h3 class="text-2xl font-serif text-dark mb-6 border-t border-gray-200 pt-8">Room Features</h3>
                    <ul class="grid md:grid-cols-2 gap-4 mb-8">
                        <li class="flex items-center gap-3"><i class="fas fa-check text-accent"></i> <span class="text-dark/80">Air-conditioning</span></li>
                        <li class="flex items-center gap-3"><i class="fas fa-check text-accent"></i> <span class="text-dark/80">En-suite bathroom with hot shower</span></li>
                        <li class="flex items-center gap-3"><i class="fas fa-check text-accent"></i> <span class="text-dark/80">Private balcony overlooking the forest</span></li>
                        <li class="flex items-center gap-3"><i class="fas fa-check text-accent"></i> <span class="text-dark/80">Daily housekeeping</span></li>
                        <li class="flex items-center gap-3"><i class="fas fa-check text-accent"></i> <span class="text-dark/80">Complimentary breakfast</span></li>
                        <li class="flex items-center gap-3"><i class="fas fa-check text-accent"></i> <span class="text-dark/80">Free Wi-Fi (Lobby area only)</span></li>
                    </ul>
                </div>

                <div class="animate-fade-in-up opacity-0 delay-3">
                    <div class="bg-white p-8 rounded-2xl shadow-sm border border-gray-100 sticky top-24">
                        <h4 class="font-bold text-xl mb-4">Reservation Details</h4>
                        <div class="space-y-4 mb-8">
                            <div><p class="eyebrow text-muted mb-1">Check-in</p><p class="font-medium text-dark">2:00 PM onwards</p></div>
                            <div><p class="eyebrow text-muted mb-1">Check-out</p><p class="font-medium text-dark">Before 11:00 AM</p></div>
                            <div><p class="eyebrow text-muted mb-1">Max Occupancy</p><p class="font-medium text-dark">2 Adults, 1 Child</p></div>
                            <div>
                                <p class="eyebrow text-muted mb-1">Booking Notice</p>
                                <p class="text-sm text-dark/80 mt-1">Due to high demand during peak seasons, we recommend booking at least 2 months in advance.</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/inquiry" class="btn btn-primary w-full py-3">Inquire Availability</a>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-32">
                <h1 class="text-3xl font-bold text-dark mb-4">Accommodation Not Found</h1>
                <p class="text-muted mb-8">The accommodation you are looking for does not exist or has been removed.</p>
                <a href="${pageContext.request.contextPath}/accommodation" class="btn btn-outline">Browse Accommodations</a>
            </div>
        </c:otherwise>
    </c:choose>
  </div>
</section>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>
