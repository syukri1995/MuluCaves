<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<header class="page-header py-5 text-white">
    <div class="container text-center">
        <h1 class="fw-bold">Things to do</h1>
        <p class="lead mb-0">Four signature Mulu experiences</p>
    </div>
</header>

<section class="container my-5">
    <div class="row mb-4">
        <div class="col-md-6 mx-auto">
            <input type="text" id="searchInput" class="form-control form-control-lg shadow-sm" placeholder="Search activities... (e.g., cave, canopy)">
        </div>
    </div>
    
    <div class="row g-4" id="activitiesContainer">
        <c:forEach var="a" items="${activities}" varStatus="status">
            <div class="col-md-6">
                <div class="card h-100 shadow-sm border-0 activity-card">
                    <div class="row g-0 h-100">
                        <div class="col-4">
                            <img src="${pageContext.request.contextPath}/${a.imagePath}"
                                 alt="${a.name}"
                                 class="img-fluid h-100 w-100 activity-thumb">
                        </div>
                        <div class="col-8">
                            <div class="card-body">
                                <span class="badge bg-success mb-2">Activity ${status.count}</span>
                                <h5 class="card-title">${a.name}</h5>
                                <p class="card-text text-muted">${a.description}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
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
        debounceTimer = setTimeout(() => {
            fetchActivities(query);
        }, 300); // 300ms debounce
    });

    async function fetchActivities(query) {
        if (currentAbortController) {
            currentAbortController.abort();
        }
        
        currentAbortController = new AbortController();
        
        try {
            const url = contextPath + '/api/activities?q=' + encodeURIComponent(query);
            const response = await fetch(url, { signal: currentAbortController.signal });
            
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            
            const data = await response.json();
            renderActivities(data);
            
        } catch (error) {
            if (error.name === 'AbortError') {
                console.log('Fetch aborted');
            } else {
                console.error('Fetch error:', error);
            }
        }
    }

    function renderActivities(activities) {
        container.innerHTML = '';
        if (activities.length === 0) {
            container.innerHTML = '<div class="col-12 text-center text-muted"><p>No activities found.</p></div>';
            return;
        }

        activities.forEach((a, index) => {
            const col = document.createElement('div');
            col.className = 'col-md-6';
            col.innerHTML = `
                <div class="card h-100 shadow-sm border-0 activity-card">
                    <div class="row g-0 h-100">
                        <div class="col-4">
                            <img src="\${contextPath}/\${a.imagePath}"
                                 alt="\${a.name}"
                                 class="img-fluid h-100 w-100 activity-thumb" style="object-fit: cover;">
                        </div>
                        <div class="col-8">
                            <div class="card-body">
                                <span class="badge bg-success mb-2">Activity \${index + 1}</span>
                                <h5 class="card-title">\${a.name}</h5>
                                <p class="card-text text-muted">\${a.description}</p>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            container.appendChild(col);
        });
    }
});
</script>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>