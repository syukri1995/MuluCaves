<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login · Mulu Caves</title>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#0f5a3f",
              accent: "#d97706",
              dark: "#0f172a",
            },
            fontFamily: {
              display: ['"Cormorant Garamond"', "serif"],
              sans: ['"Inter"', "sans-serif"],
            }
          }
        }
      }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .bg-image {
            background-image: linear-gradient(rgba(15, 23, 42, 0.7), rgba(15, 23, 42, 0.9)), url('${pageContext.request.contextPath}/images/hero/explore-hero.jpg');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body class="bg-image min-h-screen flex items-center justify-center p-4">

    <div class="w-full max-w-md bg-white rounded-2xl shadow-2xl overflow-hidden animate-fade-in-up transition-all" style="animation: fadeInUp 0.5s ease-out forwards;">
        
        <!-- Header -->
        <div class="bg-primary p-6 text-center text-white">
            <i class="fa-solid fa-mountain-sun text-4xl mb-3 text-accent"></i>
            <h2 class="font-display text-3xl font-semibold tracking-tight">Admin Console</h2>
            <p class="text-white/80 text-sm mt-1">Mulu Caves Tourism Platform</p>
        </div>

        <!-- Form Section -->
        <div class="p-8">
            <c:if test="${param.loggedOut eq '1'}">
                <div class="bg-green-50 text-green-700 p-3 rounded-lg flex items-center gap-2 mb-6 text-sm border border-green-200">
                    <i class="fa-solid fa-circle-check"></i> You have been successfully logged out.
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="bg-red-50 text-red-700 p-3 rounded-lg flex items-center gap-2 mb-6 text-sm border border-red-200">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/login" method="post" autocomplete="off" class="space-y-5">
                <div>
                    <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400">
                            <i class="fa-solid fa-user"></i>
                        </div>
                        <input type="text" id="username" name="username" value="${username}" required autofocus
                               class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-shadow text-gray-900 bg-gray-50">
                    </div>
                </div>

                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400">
                            <i class="fa-solid fa-lock"></i>
                        </div>
                        <input type="password" id="password" name="password" required
                               class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-shadow text-gray-900 bg-gray-50">
                    </div>
                </div>

                <button type="submit" class="w-full bg-primary hover:bg-[#0d4a32] text-white font-medium py-3 rounded-lg transition-colors flex justify-center items-center gap-2 shadow-lg shadow-primary/30 mt-2">
                    <i class="fa-solid fa-right-to-bracket"></i> Sign in to Dashboard
                </button>
            </form>

            <!-- Credential Hint -->
            <div class="mt-6 text-center text-xs text-gray-400 bg-gray-50 border border-gray-100 rounded-lg p-3">
                <p class="mb-1"><strong>Demo Credentials</strong></p>
                <p>Username: <code class="bg-gray-200 px-1 rounded text-gray-700">admin</code> | Password: <code class="bg-gray-200 px-1 rounded text-gray-700">admin123</code></p>
            </div>
        </div>
        
        <!-- Footer link -->
        <div class="bg-gray-50 p-4 border-t border-gray-100 text-center">
            <a href="${pageContext.request.contextPath}/home" class="text-sm text-gray-500 hover:text-primary transition-colors flex items-center justify-center gap-1.5 font-medium">
                <i class="fa-solid fa-arrow-left"></i> Back to public site
            </a>
        </div>
    </div>

    <style>
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</body>
</html>