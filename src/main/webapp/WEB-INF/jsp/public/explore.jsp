<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<header class="page-header py-5 text-white">
    <div class="container text-center">
        <h1 class="fw-bold">Explore the Park</h1>
        <p class="lead mb-0">Eight moments from inside the rainforest</p>
    </div>
</header>

<section class="container my-5">
    <div class="row g-3">
        <c:set var="g" value="1" scope="page"/>
        <c:forEach var="i" begin="1" end="8">
            <div class="col-6 col-md-4 col-lg-3">
                <a href="${pageContext.request.contextPath}/images/gallery/gallery-${i}.jpg"
                   data-lightbox="mulu-gallery"
                   data-title="Mulu Caves — photograph ${i} of 8">
                    <img src="${pageContext.request.contextPath}/images/gallery/gallery-${i}.jpg"
                         alt="Mulu gallery photo ${i}"
                         class="img-fluid rounded shadow-sm gallery-thumb">
                </a>
            </div>
        </c:forEach>
    </div>
</section>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>