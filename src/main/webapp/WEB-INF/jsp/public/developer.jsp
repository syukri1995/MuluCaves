<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<main class="min-h-screen py-20 bg-light flex flex-col justify-center animate-fade-in">
    <div class="container-max">
        <!-- Developer Profile Card -->
        <div class="max-w-4xl mx-auto bg-white rounded-2xl shadow-xl overflow-hidden border border-gray-100 flex flex-col md:flex-row">
            
            <!-- Photo Section -->
            <div class="md:w-5/12 bg-gray-50 flex items-center justify-center p-12 border-r border-gray-100 relative">
                <div class="absolute top-0 left-0 w-full h-1/2 bg-primary"></div>
                <div class="relative w-56 h-56 rounded-full overflow-hidden shadow-xl border-4 border-white z-10">
                    <img src="${pageContext.request.contextPath}/images/team/dDeveloper.jpg?v=<%= System.currentTimeMillis() %>" 
                         alt="Developer photo" class="w-full h-full object-cover">
                </div>
            </div>
            
            <!-- Details Section -->
            <div class="md:w-7/12 p-10 md:p-14 flex flex-col justify-center">
                <div class="mb-6">
                    <span class="inline-block py-1.5 px-3 rounded-full bg-green-50 text-primary text-xs font-bold uppercase tracking-wider mb-4 border border-green-100">
                        System Developer
                    </span>
                    <h1 class="text-display-lg text-gray-900 mb-1 leading-tight font-display">Muhammad Syukri</h1>
                    <p class="text-xl text-gray-500 font-medium">Student ID: <span class="text-gray-900">2023214896</span></p>
                </div>
                
                <div class="space-y-4">
                    <div class="flex items-start">
                        <div class="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center text-primary mr-4 shrink-0 border border-gray-100">
                            <i class="fa-solid fa-graduation-cap"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500 font-medium">Programme & Course</p>
                            <p class="text-gray-900 font-medium">Bachelor of Computer Science (Hons.)</p>
                            <p class="text-gray-600 text-sm">CSC584 — Web Front-End Development</p>
                        </div>
                    </div>

                    <div class="flex items-start">
                        <div class="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center text-primary mr-4 shrink-0 border border-gray-100">
                            <i class="fa-solid fa-envelope"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500 font-medium">Contact Details</p>
                            <p class="text-gray-900 font-medium">2023214896@student.uitm.edu.my</p>
                        </div>
                    </div>
                    
                    <div class="flex items-start">
                        <div class="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center text-primary mr-4 shrink-0 border border-gray-100">
                            <i class="fa-brands fa-github"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500 font-medium">GitHub Repository</p>
                            <a href="#" class="text-primary hover:text-accent font-medium transition-colors">github.com/syukri</a>
                        </div>
                    </div>
                </div>
                
                <div class="mt-8 pt-8 border-t border-gray-100">
                    <p class="text-sm text-gray-500 mb-4">External Links</p>
                    <a href="https://maps.google.com/?q=Mulu+Caves+Sarawak+Malaysia" target="_blank" class="inline-flex items-center justify-center px-6 py-3 bg-primary text-white hover:bg-[#0d4a32] rounded-lg transition-all shadow-md font-medium text-sm">
                        <i class="fa-solid fa-map-location-dot mr-2"></i> View Mulu Caves on Google Maps
                    </a>
                </div>
            </div>
            
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>