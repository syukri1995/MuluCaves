package com.mulu.servlet;

import com.mulu.dao.AdminDAO;
import com.mulu.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * JSON login endpoint for the React admin dashboard.
 *
 *   POST /api/admin/login
 *     Body: username=...&password=...  (form-encoded)
 *     Returns: {"success":true,"username":"..."} on success
 *              {"success":false,"message":"..."} on failure
 *
 * Unlike AdminLoginServlet, this one doesn't redirect — it just sets
 * the session cookie and returns JSON. The React client then navigates
 * programmatically.
 *
 * This servlet is NOT behind ApiAuthFilter (we WANT unauthenticated
 * access here). It is mapped to /api/admin/login in web.xml.
 */
public class ApiAdminLoginServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(ApiAdminLoginServlet.class);

    private final AdminDAO adminDao = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.isBlank()
                || password == null || password.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\":false,\"message\":\"Username and password are required.\"}");
            out.flush();
            return;
        }

        Admin admin = adminDao.authenticate(username, password);
        if (admin == null) {
            log.warn("Failed admin login attempt for username '{}'", username);
            try { Thread.sleep(500); } catch (InterruptedException ignored) { Thread.currentThread().interrupt(); }
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\":false,\"message\":\"Invalid username or password.\"}");
            out.flush();
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("currentAdmin", admin);
        session.setMaxInactiveInterval(30 * 60);
        log.info("Admin '{}' logged in via JSON API (id={})", admin.getUsername(), admin.getId());

        out.write("{\"success\":true,\"username\":\"" + escape(admin.getUsername()) + "\"}");
        out.flush();
    }

    private static String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}