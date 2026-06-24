<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<header class="page-header py-5 text-white">
    <div class="container text-center">
        <h1 class="fw-bold">Where to stay</h1>
        <p class="lead mb-0">Four places to base yourself in and around the park</p>
    </div>
</header>

<section class="container my-5">
    <div class="row g-4">
        <c:forEach var="r" items="${accommodations}" varStatus="status">
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 shadow-sm border-0">
                    <img src="${pageContext.request.contextPath}/${r.imagePath}"
                         alt="${r.name}"
                         class="card-img-top accommodation-thumb">
                    <div class="card-body">
                        <span class="badge bg-success mb-2">Stay ${status.count}</span>
                        <h5 class="card-title">${r.name}</h5>
                        <p class="card-text text-muted small">${r.description}</p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>