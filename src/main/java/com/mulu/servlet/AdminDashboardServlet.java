package com.mulu.servlet;

import com.mulu.dao.InquiryDAO;
import com.mulu.model.Admin;
import com.mulu.model.Inquiry;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Admin dashboard. Protected by AuthFilter — runs only when an Admin is in session.
 * - GET: Reads the full inquiry list, passes to the JSP.
 * - POST: Handles AJAX delete/edit operations for inquiries.
 */
public class AdminDashboardServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(AdminDashboardServlet.class);

    private static final Pattern EMAIL_RE =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern CONTACT_RE =
            Pattern.compile("^[0-9+\\-\\s()]{7,20}$");

    private final InquiryDAO inquiryDao = new InquiryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        req.setAttribute("admin", admin);

        List<Inquiry> inquiries = inquiryDao.findAll();
        req.setAttribute("inquiries", inquiries);

        req.setAttribute("pageTitle", "Admin Dashboard");
        req.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String action = trim(req.getParameter("action"));
        PrintWriter out = resp.getWriter();

        if (action.equals("delete")) {
            handleDelete(req, resp, out);
        } else if (action.equals("edit")) {
            handleEdit(req, resp, out);
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\":false,\"message\":\"Invalid or missing action\"}");
        }
        out.flush();
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, PrintWriter out) {
        String idStr = trim(req.getParameter("id"));
        if (idStr.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\":false,\"message\":\"Inquiry ID is required\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            boolean ok = inquiryDao.delete(id);
            if (ok) {
                out.write("{\"success\":true}");
            } else {
                out.write("{\"success\":false,\"message\":\"Could not delete inquiry. It may not exist.\"}");
            }
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\":false,\"message\":\"Invalid Inquiry ID format\"}");
        }
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp, PrintWriter out) {
        String idStr     = trim(req.getParameter("id"));
        String name      = trim(req.getParameter("name"));
        String contact   = trim(req.getParameter("contact"));
        String gender    = trim(req.getParameter("gender"));
        String email     = trim(req.getParameter("email"));
        String heardFrom = trim(req.getParameter("heard_from"));
        String message   = trim(req.getParameter("message"));

        if (idStr.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\":false,\"message\":\"Inquiry ID is required\"}");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\":false,\"message\":\"Invalid Inquiry ID format\"}");
            return;
        }

        // Server-side validation
        StringBuilder errors = new StringBuilder();
        if (name.isEmpty())      errors.append("Name is required. ");
        if (contact.isEmpty())   errors.append("Contact is required. ");
        else if (!CONTACT_RE.matcher(contact).matches()) errors.append("Contact format is invalid. ");
        if (gender.isEmpty() || !gender.matches("Male|Female|Other")) errors.append("Select a valid gender. ");
        if (email.isEmpty())     errors.append("Email is required. ");
        else if (!EMAIL_RE.matcher(email).matches()) errors.append("Email format is invalid. ");
        if (heardFrom.isEmpty()) errors.append("Heard from is required. ");
        if (message.isEmpty())   errors.append("Message is required. ");

        if (errors.length() > 0) {
            out.write("{\"success\":false,\"message\":\"" + errors.toString().trim() + "\"}");
            return;
        }

        Inquiry inq = new Inquiry();
        inq.setId(id);
        inq.setName(name);
        inq.setContact(contact);
        inq.setGender(gender);
        inq.setEmail(email);
        inq.setHeardFrom(heardFrom);
        inq.setMessage(message);

        boolean ok = inquiryDao.update(inq);
        if (ok) {
            out.write("{\"success\":true}");
        } else {
            out.write("{\"success\":false,\"message\":\"Database update failed.\"}");
        }
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }
}