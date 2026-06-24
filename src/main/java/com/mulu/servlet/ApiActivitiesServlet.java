package com.mulu.servlet;

import com.google.gson.Gson;
import com.mulu.dao.ActivityDAO;
import com.mulu.model.Activity;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class ApiActivitiesServlet extends HttpServlet {
    private final ActivityDAO activityDao = new ActivityDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = req.getParameter("q");
        List<Activity> activities = activityDao.findAll();
        
        if (query != null && !query.trim().isEmpty()) {
            String lowerQuery = query.toLowerCase();
            activities = activities.stream()
                .filter(a -> a.getName().toLowerCase().contains(lowerQuery) || 
                             a.getDescription().toLowerCase().contains(lowerQuery))
                .collect(Collectors.toList());
        }

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(activities));
    }
}
