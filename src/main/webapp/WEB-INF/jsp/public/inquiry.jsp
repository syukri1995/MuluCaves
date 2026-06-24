<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<header class="page-header py-5 text-white">
    <div class="container text-center">
        <h1 class="fw-bold">Get in touch</h1>
        <p class="lead mb-0">Tell us a little about your trip and we'll get back to you</p>
    </div>
</header>

<section class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4 p-md-5">

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-1"></i> ${error}
                        </div>
                    </c:if>

                    <form id="inquiryForm"
                          action="${pageContext.request.contextPath}/inquiry"
                          method="post"
                          novalidate>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="name" class="form-label">Full name</label>
                                <input type="text" class="form-control" id="name" name="name"
                                       value="${name}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="contact" class="form-label">Contact number</label>
                                <input type="tel" class="form-control" id="contact" name="contact"
                                       value="${contact}" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label d-block">Gender</label>
                                <div class="btn-group" role="group" aria-label="Gender">
                                    <input type="radio" class="btn-check" name="gender" id="g-male"
                                           value="Male" ${gender eq 'Male'   ? 'checked' : ''} required>
                                    <label class="btn btn-outline-success" for="g-male">Male</label>

                                    <input type="radio" class="btn-check" name="gender" id="g-female"
                                           value="Female" ${gender eq 'Female' ? 'checked' : ''}>
                                    <label class="btn btn-outline-success" for="g-female">Female</label>

                                    <input type="radio" class="btn-check" name="gender" id="g-other"
                                           value="Other" ${gender eq 'Other'  ? 'checked' : ''}>
                                    <label class="btn btn-outline-success" for="g-other">Other</label>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label">Email address</label>
                                <input type="email" class="form-control" id="email" name="email"
                                       value="${email}" required>
                            </div>

                            <div class="col-12">
                                <label for="heard_from" class="form-label">How did you hear about us?</label>
                                <select class="form-select" id="heard_from" name="heard_from" required>
                                    <option value="" disabled ${empty heardFrom ? 'selected' : ''}>-- select one --</option>
                                    <option value="Friend"        ${heardFrom eq 'Friend'        ? 'selected' : ''}>Friend or family</option>
                                    <option value="Social Media"  ${heardFrom eq 'Social Media'  ? 'selected' : ''}>Social media</option>
                                    <option value="Google Search" ${heardFrom eq 'Google Search' ? 'selected' : ''}>Google search</option>
                                    <option value="Travel Blog"   ${heardFrom eq 'Travel Blog'   ? 'selected' : ''}>Travel blog</option>
                                    <option value="Other"         ${heardFrom eq 'Other'         ? 'selected' : ''}>Other</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <label for="message" class="form-label">Your message</label>
                                <textarea class="form-control" id="message" name="message" rows="5"
                                          required>${message}</textarea>
                            </div>

                            <div class="col-12 d-flex justify-content-end gap-2 mt-3">
                                <button type="reset" class="btn btn-outline-secondary">
                                    <i class="fa-solid fa-eraser me-1"></i> Clear
                                </button>
                                <button type="submit" class="btn btn-success">
                                    <i class="fa-solid fa-paper-plane me-1"></i> Submit inquiry
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    // Client-side required-field check before submit.
    document.getElementById('inquiryForm').addEventListener('submit', function (e) {
        const required = this.querySelectorAll('[required]');
        for (const el of required) {
            if (!el.value || (el.type === 'radio' && !this.querySelector(`[name="${el.name}"]:checked`))) {
                e.preventDefault();
                Swal.fire({
                    icon: 'warning',
                    title: 'Please complete all fields',
                    text: 'Every field is required before you can submit your inquiry.',
                });
                return;
            }
        }
    });

    // Show success toast after redirect from POST
    const params = new URLSearchParams(window.location.search);
    if (params.get('success') === '1') {
        Swal.fire({
            icon: 'success',
            title: 'Submitted!',
            text: 'Your inquiry has been received. We will get back to you shortly.',
        });
    }
</script>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>