<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/fragments/header.jspf" %>

<section id="inquire" class="relative py-16 md:py-24 min-h-screen" style="background: var(--fern-mist, #d6dbd2)">
  <div class="container-max">
    <div class="grid lg:grid-cols-12 gap-10 lg:gap-16 items-start">
      
      <!-- LEFT: Form Panel -->
      <div class="lg:col-span-7">
        <div class="mb-8">
          <p class="eyebrow mb-3" style="color: var(--rust-mineral-dim, #96532d)">Chapter Four</p>
          <h1 class="display-serif text-primary mb-4" style="font-family: 'Cormorant Garamond', serif; font-weight: 500; font-size: clamp(2.2rem, 5vw, 3.4rem); line-height: 1.0;">
            Begin your <em style="font-style: italic; color: var(--rust-mineral, #d27e4e);">field note</em>.
          </h1>
          <p class="text-base md:text-lg max-w-2xl" style="color: rgba(11,14,12,0.75)">
            Every field below is read by the field office before any reply is sent. Required fields are marked with a small mono asterisk.
          </p>
        </div>

        <c:if test="${not empty error}">
          <div role="alert" class="mb-5" style="background: rgba(210,126,78,0.08); border: 1px solid var(--rust-mineral); color: var(--rust-mineral-dim); padding: 0.85rem 1rem; font-size: 0.95rem;">
            <span style="margin-right: 0.5rem;">⚠</span> ${error}
          </div>
        </c:if>

        <form id="inquiryForm" action="${pageContext.request.contextPath}/inquiry" method="post" class="inquiry-form-panel" style="background: rgba(255,255,255,0.45); border: 1px solid rgba(11,14,12,0.15); padding: 2rem;">
          
          <div class="grid md:grid-cols-2 gap-4">
            
            <div class="mb-4">
              <label style="display: block; font-family: 'JetBrains Mono', monospace; font-size: 11px; text-transform: uppercase; color: rgba(11,14,12,0.7); margin-bottom: 0.4rem;">
                Full name <span style="color: var(--rust-mineral); margin-left: 0.35rem;">*</span>
              </label>
              <input type="text" id="name" name="name" value="${name}" required class="w-full px-4 py-3 bg-white/50 border border-gray-300 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary font-sans">
            </div>

            <div class="mb-4">
              <label style="display: block; font-family: 'JetBrains Mono', monospace; font-size: 11px; text-transform: uppercase; color: rgba(11,14,12,0.7); margin-bottom: 0.4rem;">
                Contact number <span style="color: var(--rust-mineral); margin-left: 0.35rem;">*</span>
              </label>
              <input type="tel" id="contact" name="contact" value="${contact}" required class="w-full px-4 py-3 bg-white/50 border border-gray-300 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary font-sans">
            </div>

            <div class="mb-4">
              <label style="display: block; font-family: 'JetBrains Mono', monospace; font-size: 11px; text-transform: uppercase; color: rgba(11,14,12,0.7); margin-bottom: 0.4rem;">
                Gender <span style="color: var(--rust-mineral); margin-left: 0.35rem;">*</span>
              </label>
              <div class="flex flex-wrap gap-2">
                <label class="cursor-pointer" style="font-family: 'JetBrains Mono', monospace; font-size: 11px; text-transform: uppercase; padding: 0.55rem 1rem; border: 1px solid rgba(11,14,12,0.25);">
                  <input type="radio" name="gender" value="Male" ${gender eq 'Male' ? 'checked' : ''} required class="mr-2"> Male
                </label>
                <label class="cursor-pointer" style="font-family: 'JetBrains Mono', monospace; font-size: 11px; text-transform: uppercase; padding: 0.55rem 1rem; border: 1px solid rgba(11,14,12,0.25);">
                  <input type="radio" name="gender" value="Female" ${gender eq 'Female' ? 'checked' : ''} class="mr-2"> Female
                </label>
                <label class="cursor-pointer" style="font-family: 'JetBrains Mono', monospace; font-size: 11px; text-transform: uppercase; padding: 0.55rem 1rem; border: 1px solid rgba(11,14,12,0.25);">
                  <input type="radio" name="gender" value="Other" ${gender eq 'Other' ? 'checked' : ''} class="mr-2"> Other
                </label>
              </div>
            </div>

            <div class="mb-4">
              <label style="display: block; font-family: 'JetBrains Mono', monospace; font-size: 11px; text-transform: uppercase; color: rgba(11,14,12,0.7); margin-bottom: 0.4rem;">
                Email address <span style="color: var(--rust-mineral); margin-left: 0.35rem;">*</span>
              </label>
              <input type="email" id="email" name="email" value="${email}" required class="w-full px-4 py-3 bg-white/50 border border-gray-300 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary font-sans">
            </div>

            <div class="mb-4 md:col-span-2">
              <label style="display: block; font-family: 'JetBrains Mono', monospace; font-size: 11px; text-transform: uppercase; color: rgba(11,14,12,0.7); margin-bottom: 0.4rem;">
                How did you hear about us? <span style="color: var(--rust-mineral); margin-left: 0.35rem;">*</span>
              </label>
              <select id="heard_from" name="heard_from" required class="w-full px-4 py-3 bg-white/50 border border-gray-300 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary font-sans">
                <option value="" disabled ${empty heardFrom ? 'selected' : ''}>— select one —</option>
                <option value="Friend" ${heardFrom eq 'Friend' ? 'selected' : ''}>Friend or family</option>
                <option value="Social Media" ${heardFrom eq 'Social Media' ? 'selected' : ''}>Social media</option>
                <option value="Google Search" ${heardFrom eq 'Google Search' ? 'selected' : ''}>Google search</option>
                <option value="Travel Blog" ${heardFrom eq 'Travel Blog' ? 'selected' : ''}>Travel blog</option>
                <option value="Other" ${heardFrom eq 'Other' ? 'selected' : ''}>Other</option>
              </select>
            </div>

            <div class="mb-4 md:col-span-2">
              <label style="display: block; font-family: 'JetBrains Mono', monospace; font-size: 11px; text-transform: uppercase; color: rgba(11,14,12,0.7); margin-bottom: 0.4rem;">
                Your message <span style="color: var(--rust-mineral); margin-left: 0.35rem;">*</span>
              </label>
              <textarea id="message" name="message" rows="5" required class="w-full px-4 py-3 bg-white/50 border border-gray-300 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary font-sans" style="resize: vertical; min-height: 140px;">${message}</textarea>
            </div>
            
          </div>

          <div class="flex flex-wrap items-center justify-end gap-3 mt-6">
            <button type="reset" style="background: transparent; border: 1px solid rgba(11,14,12,0.25); color: rgba(11,14,12,0.7); font-family: 'JetBrains Mono', monospace; font-size: 12px; text-transform: uppercase; padding: 0.85rem 1.5rem;">
              Clear
            </button>
            <button type="submit" style="background: var(--rust-mineral, #d27e4e); border: 1px solid var(--rust-mineral, #d27e4e); color: #fff; font-family: 'JetBrains Mono', monospace; font-size: 12px; text-transform: uppercase; padding: 0.85rem 2rem;">
              Send Inquiry
            </button>
          </div>
          <p class="mt-5" style="font-family: 'JetBrains Mono', monospace; font-size: 10px; text-transform: uppercase; color: rgba(11,14,12,0.5);">
            Submitted inquiries are stored securely in the Mulu tourism database.
          </p>
        </form>
      </div>

      <!-- RIGHT: Field Notes Sidebar -->
      <aside class="lg:col-span-5 h-full">
        <div class="p-8 lg:p-10 h-full" style="background: var(--cave-shadow, #0b0e0c); color: var(--fern-mist, #d6dbd2); border-left: 3px solid var(--rust-mineral, #d27e4e);">
          <p style="font-family: 'JetBrains Mono', monospace; font-size: 10px; text-transform: uppercase; color: var(--rust-mineral, #d27e4e); margin-bottom: 1rem;">Field Notes</p>
          <h3 style="font-family: 'Cormorant Garamond', serif; font-size: 1.7rem; color: var(--fern-mist, #d6dbd2); margin-bottom: 1.5rem; font-weight: 500;">What happens next.</h3>
          
          <div style="padding: 1rem 0; border-top: 1px solid rgba(214,219,210,0.08);">
            <div style="font-family: 'JetBrains Mono', monospace; font-size: 10px; text-transform: uppercase; color: rgba(214,219,210,0.5); margin-bottom: 0.25rem;">Reading time</div>
            <div style="color: var(--fern-mist, #d6dbd2); font-size: 0.95rem;">Every inquiry is opened by the field office within two working days.</div>
          </div>
          
          <div style="padding: 1rem 0; border-top: 1px solid rgba(214,219,210,0.08);">
            <div style="font-family: 'JetBrains Mono', monospace; font-size: 10px; text-transform: uppercase; color: rgba(214,219,210,0.5); margin-bottom: 0.25rem;">Reply</div>
            <div style="color: var(--fern-mist, #d6dbd2); font-size: 0.95rem;">A written reply from a person who has been on the plank walk this season.</div>
          </div>

          <div style="padding: 1rem 0; border-top: 1px solid rgba(214,219,210,0.08); border-bottom: 1px solid rgba(214,219,210,0.08);">
            <div style="font-family: 'JetBrains Mono', monospace; font-size: 10px; text-transform: uppercase; color: rgba(214,219,210,0.5); margin-bottom: 0.25rem;">Direct line</div>
            <div style="color: var(--fern-mist, #d6dbd2); font-size: 0.95rem;">
              <span style="color: var(--rust-mineral, #d27e4e);">✉</span> <a href="mailto:field@mulucaves.com" style="color: var(--bio-glow, #c6f13a); text-decoration: none;">field@mulucaves.com</a>
            </div>
          </div>
          
          <blockquote style="font-family: 'Cormorant Garamond', serif; font-style: italic; font-size: 1.1rem; line-height: 1.4; color: rgba(214,219,210,0.85); border-left: 2px solid var(--bio-glow, #c6f13a); padding-left: 1rem; margin-top: 1.5rem;">
            “A walk into Deer Cave is a walk into a scale of nature we have forgotten how to read.”
          </blockquote>
        </div>
      </aside>

    </div>
  </div>
</section>

<!-- Client validation & Success Alert -->
<script>
document.addEventListener("DOMContentLoaded", function() {
    const params = new URLSearchParams(window.location.search);
    if (params.get('success') === '1') {
        Swal.fire({ icon: 'success', title: 'Submitted!', text: 'Your inquiry has been received. We will get back to you shortly.' });
    }
});
</script>

<%@ include file="/WEB-INF/fragments/footer.jspf" %>