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

/** Destroys the admin session and redirects to the login page. */
public class AdminLogoutServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(AdminLogoutServlet.class);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doLogout(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doLogout(req, resp);
    }

    private void doLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            Admin admin = (Admin) session.getAttribute("currentAdmin");
            if (admin != null) {
                log.info("Admin '{}' logging out", admin.getUsername());
            }
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/admin/login?loggedOut=1");
    }
}