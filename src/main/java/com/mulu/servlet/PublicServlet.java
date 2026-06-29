package com.mulu.servlet;

import com.mulu.dao.AccommodationDAO;
import com.mulu.dao.ActivityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Front controller for the public site. Dispatches by path suffix to JSPs
 * under /WEB-INF/jsp/public/.
 */
public class PublicServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(PublicServlet.class);

    private final ActivityDAO      activityDao      = new ActivityDAO();
    private final AccommodationDAO accommodationDao  = new AccommodationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        if (path == null || path.equals("/") || path.equals("/home")) {
            showHome(req, resp);
        } else if (path.equals("/explore")) {
            showExplore(req, resp);
        } else if (path.equals("/activities")) {
            showActivities(req, resp);
        } else if (path.equals("/activity")) {
            showActivity(req, resp);
        } else if (path.equals("/accommodation")) {
            showAccommodation(req, resp);
        } else if (path.equals("/accommodation-detail")) {
            showAccommodationDetail(req, resp);
        } else if (path.equals("/developer")) {
            showDeveloper(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showHome(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("pageTitle", "Mulu Caves — Home");
        req.setAttribute("activities", activityDao.findAll());
        req.getRequestDispatcher("/WEB-INF/jsp/public/home.jsp").forward(req, resp);
    }

    private void showExplore(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("pageTitle", "Explore the Park");
        req.getRequestDispatcher("/WEB-INF/jsp/public/explore.jsp").forward(req, resp);
    }

    private void showActivities(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("pageTitle", "Activities");
        req.setAttribute("activities", activityDao.findAll());
        req.getRequestDispatcher("/WEB-INF/jsp/public/activities.jsp").forward(req, resp);
    }

    private void showAccommodation(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("pageTitle", "Where to Stay");
        req.setAttribute("accommodations", accommodationDao.findAll());
        req.getRequestDispatcher("/WEB-INF/jsp/public/accommodation.jsp").forward(req, resp);
    }

    private void showActivity(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                req.setAttribute("activity", activityDao.findById(id));
            } catch (NumberFormatException ignored) {}
        }
        req.setAttribute("pageTitle", "Activity Details");
        req.getRequestDispatcher("/WEB-INF/jsp/public/activity_detail.jsp").forward(req, resp);
    }

    private void showAccommodationDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                req.setAttribute("accommodation", accommodationDao.findById(id));
            } catch (NumberFormatException ignored) {}
        }
        req.setAttribute("pageTitle", "Accommodation Details");
        req.getRequestDispatcher("/WEB-INF/jsp/public/accommodation_detail.jsp").forward(req, resp);
    }

    private void showDeveloper(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("pageTitle", "Developer");
        req.getRequestDispatcher("/WEB-INF/jsp/public/developer.jsp").forward(req, resp);
    }
}