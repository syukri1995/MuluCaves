<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<header class="page-header py-5 text-white">
    <div class="container text-center">
        <h1 class="fw-bold">About the Developer</h1>
        <p class="lead mb-0">CSC584 Web Front-End Development · March 2026 – August 2026</p>
    </div>
</header>

<section class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4 p-md-5">
                    <div class="text-center mb-4">
                        <img src="${pageContext.request.contextPath}/images/team/developer.jpg"
                             alt="Developer photo"
                             class="rounded-circle shadow developer-photo mb-3">
                        <h3 class="fw-bold mb-1">Your Name</h3>
                        <p class="text-muted mb-0">Student ID: 2024XXXXXX</p>
                    </div>
                    <hr>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <h6 class="fw-bold mb-1">Programme</h6>
                            <p class="text-muted mb-0">Bachelor of Computer Science (Hons.) — Software Engineering</p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="fw-bold mb-1">University</h6>
                            <p class="text-muted mb-0">Universiti Teknologi MARA (UiTM)</p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="fw-bold mb-1">Course</h6>
                            <p class="text-muted mb-0">CSC584 — Web Front-End Development</p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="fw-bold mb-1">Contact</h6>
                            <p class="text-muted mb-0">
                                <i class="fa-solid fa-envelope me-1"></i> your.email@example.com<br>
                                <i class="fa-brands fa-github me-1"></i> github.com/yourhandle
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>