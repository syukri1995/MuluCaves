package com.mulu.filter;

import com.mulu.model.Admin;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Blocks unauthenticated access to /admin/* except for /admin/login itself.
 * Mapped in web.xml so the order is explicit.
 */
public class AuthFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(AuthFilter.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        log.info("AuthFilter initialised");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getServletPath();

        // Always allow the login page and the login/logout POSTs through
        if (path == null
                || path.equals("/admin/login")
                || path.equals("/admin/logout")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Admin admin = (session == null) ? null : (Admin) session.getAttribute("currentAdmin");

        if (admin == null) {
            log.info("Blocking unauthenticated request to {}", path);
            res.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        log.info("AuthFilter destroyed");
    }
}