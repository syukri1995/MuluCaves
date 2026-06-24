<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<!-- HERO -->
<header class="page-header-editorial py-5 my-md-4">
    <div class="container">
        <div class="d-flex flex-column flex-lg-row align-items-center gap-5 justify-content-between">
            <div class="hero-text-editorial" style="max-width: 500px;">
                <span class="eyebrow text-muted mb-3 d-block">Sarawak, Borneo · UNESCO World Heritage</span>
                <h1 class="display-2 fw-bold text-dark lh-sm">
                    Where the rainforest meets the world's <em class="italic font-serif font-light" style="color: var(--rust-mineral);">largest</em> caves.
                </h1>
                <p class="lead text-muted mt-4">
                    A slow travel field journal — experiencing the ancient limestone passages, the raw wilderness, and the scale of nature.
                </p>
                <div class="mt-5 d-flex gap-3">
                    <a href="${pageContext.request.contextPath}/explore" class="btn btn-success">
                        Explore the Park
                    </a>
                    <a href="${pageContext.request.contextPath}/inquiry" class="btn btn-outline-success">
                        Plan Inquiry
                    </a>
                </div>
            </div>
            
            <div class="specimen-plate shadow-sm">
                <div class="plate-image-container">
                    <img src="${pageContext.request.contextPath}/images/hero/hero-1.jpg"
                         alt="Mulu pinnacles rising above the forest">
                </div>
                <div class="plate-caption">
                    <span>PLATE 01 // THE PINNACLES</span>
                    <span>4.05° N · 114.92° E</span>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- INTRO -->
<section class="container my-5 py-4">
    <div class="d-flex flex-column-reverse flex-lg-row align-items-center gap-5 justify-content-between">
        <div class="specimen-plate shadow-sm">
            <div class="plate-image-container square">
                <img src="${pageContext.request.contextPath}/images/gallery/gallery-1.jpg"
                     alt="Inside Deer Cave">
            </div>
            <div class="plate-caption">
                <span>PLATE 02 // DEER CAVE</span>
                <span>CHAMBER</span>
            </div>
        </div>
        
        <div style="max-width: 500px;">
            <h2 class="fw-bold mb-4">Tucked deep in the heart of Borneo...</h2>
            <p class="text-muted" style="font-size: 1.1rem; line-height: 1.8;">
                Mulu's limestone karst ecosystem harbours some of the most spectacular cave systems on Earth — including the world's largest cave chamber by surface area, Deer Cave, and the iconic Pinnacles spires that rise 45 metres into the sky.
            </p>
            <a href="${pageContext.request.contextPath}/activities" class="btn btn-outline-success mt-4">
                See activities
            </a>
        </div>
    </div>
</section>

<!-- FEATURED ACTIVITIES (3) -->
<section class="bg-light py-5 border-top">
    <div class="container py-4">
        <h2 class="fw-bold text-center mb-5" style="font-family: 'Cormorant Garamond', serif;">Must-do experiences</h2>
        <div class="d-flex flex-wrap justify-content-center gap-5">
            <c:forEach var="a" items="${activities}" begin="0" end="2" varStatus="status">
                <div class="specimen-plate shadow-sm">
                    <div class="plate-image-container square">
                        <img src="${pageContext.request.contextPath}/${a.imagePath}"
                             alt="${a.name}">
                    </div>
                    <div class="plate-caption">
                        <span>PLATE 0${status.count + 2}</span>
                        <span>${a.name}</span>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="text-center mt-5">
            <a href="${pageContext.request.contextPath}/activities" class="btn btn-success">
                All activities
            </a>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>