<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login · Mulu Caves</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
</head>
<body class="admin-login-body">

<div class="container">
    <div class="row justify-content-center align-items-center min-vh-100">
        <div class="col-md-5 col-lg-4">
            <div class="card shadow border-0 login-card">
                <div class="card-body p-4 p-md-5">
                    <div class="text-center mb-4">
                        <i class="fa-solid fa-mountain-sun fa-3x text-success mb-2"></i>
                        <h3 class="fw-bold mb-0">Admin Sign-in</h3>
                        <small class="text-muted">Mulu Caves Tourism · Admin Console</small>
                    </div>

                    <c:if test="${param.loggedOut eq '1'}">
                        <div class="alert alert-success py-2 small">
                            <i class="fa-solid fa-circle-check me-1"></i> You have been logged out.
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger py-2 small">
                            <i class="fa-solid fa-circle-exclamation me-1"></i> ${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/login" method="post" autocomplete="off">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                                <input type="text" class="form-control" id="username" name="username"
                                       value="${username}" required autofocus>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-success w-100">
                            <i class="fa-solid fa-right-to-bracket me-1"></i> Sign in
                        </button>
                    </form>

                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/home" class="small text-muted text-decoration-none">
                            <i class="fa-solid fa-arrow-left me-1"></i> Back to public site
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>