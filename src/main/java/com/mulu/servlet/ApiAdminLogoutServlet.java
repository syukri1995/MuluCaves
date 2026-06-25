package com.mulu.servlet;

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
 * JSON logout endpoint for the React admin dashboard.
 *
 *   POST /api/admin/logout
 *     Invalidates the admin session and returns:
 *       {"success":true}
 *
 * NOT behind ApiAuthFilter (you should be able to log out even if
 * somehow auth state is stale on the client side).
 */
public class ApiAdminLogoutServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(ApiAdminLogoutServlet.class);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session != null) {
            Admin admin = (Admin) session.getAttribute("currentAdmin");
            if (admin != null) {
                log.info("Admin '{}' logging out via JSON API", admin.getUsername());
            }
            session.invalidate();
        }

        out.write("{\"success\":true}");
        out.flush();
    }
}