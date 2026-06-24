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

/** GET shows the login form; POST verifies credentials and starts a session. */
public class AdminLoginServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(AdminLoginServlet.class);

    private final AdminDAO adminDao = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // If already logged in, send straight to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentAdmin") != null) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }
        req.setAttribute("pageTitle", "Admin Login");
        req.getRequestDispatcher("/WEB-INF/jsp/admin/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.isBlank()
                || password == null || password.isBlank()) {
            req.setAttribute("error", "Username and password are required.");
            req.setAttribute("username", username);
            req.setAttribute("pageTitle", "Admin Login");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/login.jsp").forward(req, resp);
            return;
        }

        Admin admin = adminDao.authenticate(username, password);

        if (admin == null) {
            log.warn("Failed admin login attempt for username '{}'", username);
            // Small delay to slow down brute force
            try { Thread.sleep(500); } catch (InterruptedException ignored) { Thread.currentThread().interrupt(); }
            req.setAttribute("error", "Invalid username or password.");
            req.setAttribute("username", username);
            req.setAttribute("pageTitle", "Admin Login");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("currentAdmin", admin);
        session.setMaxInactiveInterval(30 * 60);
        log.info("Admin '{}' logged in (id={})", admin.getUsername(), admin.getId());

        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}