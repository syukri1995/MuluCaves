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
 * API-layer counterpart to AuthFilter.
 *
 * Guards /api/admin/* — the JSON endpoints used by the React admin
 * dashboard. If there's no admin session, this filter writes a 401
 * JSON response (instead of redirecting to /admin/login, which would
 * break fetch() on the React side).
 */
public class ApiAuthFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(ApiAuthFilter.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        log.info("ApiAuthFilter initialised");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getServletPath();

        // Always allow the JSON login/logout endpoints through (they
        // need to be reachable without an existing admin session).
        if (path != null && (path.equals("/api/admin/login") || path.equals("/api/admin/logout"))) {
            chain.doFilter(request, response);
            return;
        }

        // CORS preflight — short-circuit with the right headers.
        if ("OPTIONS".equalsIgnoreCase(req.getMethod())) {
            res.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        HttpSession session = req.getSession(false);
        Admin admin = (session == null) ? null : (Admin) session.getAttribute("currentAdmin");

        if (admin == null) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            res.setContentType("application/json");
            res.setCharacterEncoding("UTF-8");
            res.getWriter().write("{\"success\":false,\"message\":\"Not authenticated\"}");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        log.info("ApiAuthFilter destroyed");
    }
}