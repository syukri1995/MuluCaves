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

/**
 * JSON API for the React admin dashboard.
 *
 *   GET  /api/admin/inquiries       -> JSON list of all inquiries (auth-gated)
 *   GET  /api/admin/me              -> {username} if logged in, 401 otherwise
 *   GET  /api/admin/stats           -> aggregate counts (total, social, referrals)
 *
 * All endpoints require a valid admin session (the /api/admin/* URL prefix
 * is protected by AuthFilter in web.xml). AuthFilter runs before this
 * servlet and will redirect unauthenticated requests to /admin/login.
 *
 * For the JSON admin we want a 401 instead of a redirect, so the servlet
 * itself also checks for the session and returns JSON 401 if missing.
 */
public class ApiAdminServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(ApiAdminServlet.class);

    private final InquiryDAO inquiryDao = new InquiryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        // Defence in depth — AuthFilter should have caught this already,
        // but we double-check so the React client always gets JSON 401
        // (not a 302 to /admin/login, which fetch can't follow as JSON).
        HttpSession session = req.getSession(false);
        Admin admin = (session == null) ? null : (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\":false,\"message\":\"Not authenticated\"}");
            out.flush();
            return;
        }

        String path = req.getServletPath();
        try {
            switch (path) {
                case "/api/admin/me" -> handleMe(resp, out, admin);
                case "/api/admin/inquiries" -> handleList(resp, out);
                case "/api/admin/stats" -> handleStats(resp, out);
                default -> {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.write("{\"success\":false,\"message\":\"Unknown endpoint: " + path + "\"}");
                }
            }
        } catch (Exception e) {
            log.error("API error on {}: {}", path, e.getMessage(), e);
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\":false,\"message\":\"Internal server error\"}");
        }
        out.flush();
    }

    private void handleMe(HttpServletResponse resp, PrintWriter out, Admin admin) {
        out.write("{\"success\":true,\"username\":\"" + escape(admin.getUsername()) + "\"}");
    }

    private void handleList(HttpServletResponse resp, PrintWriter out) {
        List<Inquiry> inqs = inquiryDao.findAll();
        StringBuilder sb = new StringBuilder(1024);
        sb.append("{\"success\":true,\"inquiries\":[");
        for (int i = 0; i < inqs.size(); i++) {
            if (i > 0) sb.append(',');
            Inquiry inq = inqs.get(i);
            sb.append('{')
              .append("\"id\":").append(inq.getId()).append(',')
              .append("\"name\":\"").append(escape(inq.getName())).append("\",")
              .append("\"contact\":\"").append(escape(inq.getContact())).append("\",")
              .append("\"gender\":\"").append(escape(inq.getGender())).append("\",")
              .append("\"email\":\"").append(escape(inq.getEmail())).append("\",")
              .append("\"heardFrom\":\"").append(escape(inq.getHeardFrom())).append("\",")
              .append("\"message\":\"").append(escape(inq.getMessage())).append("\",")
              .append("\"submittedAt\":\"").append(inq.getSubmittedAt() == null ? "" : inq.getSubmittedAt().toString()).append("\"")
              .append('}');
        }
        sb.append("]}");
        out.write(sb.toString());
    }

    private void handleStats(HttpServletResponse resp, PrintWriter out) {
        List<Inquiry> inqs = inquiryDao.findAll();
        int total = inqs.size();
        int social = 0, referrals = 0;
        for (Inquiry inq : inqs) {
            if ("Social Media".equals(inq.getHeardFrom())) social++;
            if ("Friend".equals(inq.getHeardFrom())) referrals++;
        }
        out.write("{\"success\":true,\"total\":" + total
                + ",\"social\":" + social
                + ",\"referrals\":" + referrals + "}");
    }

    /** Minimal JSON string escaper — escapes ", \, control chars. */
    private static String escape(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder(s.length() + 8);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"':  sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n");  break;
                case '\r': sb.append("\\r");  break;
                case '\t': sb.append("\\t");  break;
                default:
                    if (c < 0x20) sb.append(String.format("\\u%04x", (int) c));
                    else sb.append(c);
            }
        }
        return sb.toString();
    }
}