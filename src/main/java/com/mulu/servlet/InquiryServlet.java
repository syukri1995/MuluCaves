package com.mulu.servlet;

import com.mulu.dao.InquiryDAO;
import com.mulu.model.Inquiry;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.regex.Pattern;

/**
 * Handles the public inquiry form. GET renders the form; POST validates + persists.
 */
public class InquiryServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(InquiryServlet.class);

    private static final Pattern EMAIL_RE =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern CONTACT_RE =
            Pattern.compile("^[0-9+\\-\\s()]{7,20}$");

    private final InquiryDAO inquiryDao = new InquiryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("pageTitle", "Inquire");
        req.getRequestDispatcher("/WEB-INF/jsp/public/inquiry.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String name      = trim(req.getParameter("name"));
        String contact   = trim(req.getParameter("contact"));
        String gender    = trim(req.getParameter("gender"));
        String email     = trim(req.getParameter("email"));
        String heardFrom = trim(req.getParameter("heard_from"));
        String message   = trim(req.getParameter("message"));

        // ---------- Server-side validation ----------
        StringBuilder errors = new StringBuilder();

        if (name.isEmpty())      errors.append("Name is required. ");
        if (contact.isEmpty())   errors.append("Contact number is required. ");
        else if (!CONTACT_RE.matcher(contact).matches()) errors.append("Contact format looks invalid. ");
        if (gender.isEmpty() || !gender.matches("Male|Female|Other"))
            errors.append("Please select a gender. ");
        if (email.isEmpty())     errors.append("Email is required. ");
        else if (!EMAIL_RE.matcher(email).matches()) errors.append("Email format looks invalid. ");
        if (heardFrom.isEmpty()) errors.append("Please tell us where you heard about us. ");
        if (message.isEmpty())   errors.append("Message is required. ");

        if (errors.length() > 0) {
            req.setAttribute("error", errors.toString().trim());
            req.setAttribute("name", name);
            req.setAttribute("contact", contact);
            req.setAttribute("gender", gender);
            req.setAttribute("email", email);
            req.setAttribute("heardFrom", heardFrom);
            req.setAttribute("message", message);
            req.setAttribute("pageTitle", "Inquire");
            req.getRequestDispatcher("/WEB-INF/jsp/public/inquiry.jsp").forward(req, resp);
            return;
        }

        // ---------- Persist ----------
        Inquiry inq = new Inquiry();
        inq.setName(name);
        inq.setContact(contact);
        inq.setGender(gender);
        inq.setEmail(email);
        inq.setHeardFrom(heardFrom);
        inq.setMessage(message);

        boolean ok = inquiryDao.insert(inq);

        if (ok) {
            log.info("Inquiry accepted from '{}'", name);
            req.getSession().setAttribute("flashSuccess",
                    "Thank you, " + name + "! Your inquiry has been submitted.");
            resp.sendRedirect(req.getContextPath() + "/inquiry?success=1");
        } else {
            req.setAttribute("error", "We could not save your inquiry right now. Please try again later.");
            req.setAttribute("pageTitle", "Inquire");
            req.getRequestDispatcher("/WEB-INF/jsp/public/inquiry.jsp").forward(req, resp);
        }
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }
}