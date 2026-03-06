package com.oceanview.controller;

import com.oceanview.dao.ReportDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

/**
 * ReportServlet - MVC Controller
 * ────────────────────────────────
 * Gathers monthly statistics from ReportDAO and sets them as request attributes
 * for the reports JSP view.
 *
 * GET /reports → Fetch statistics → Forward to reports.jsp
 *
 * Design Pattern: MVC - Controller
 */
public class ReportServlet extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Security check ──────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ── Fetch all stats from the DAO ────────────────────────────────────
        int        monthlyCount       = reportDAO.getCurrentMonthReservationCount();
        BigDecimal monthlyRevenue     = reportDAO.getCurrentMonthRevenue();
        int        totalAllTime       = reportDAO.getTotalReservationsAllTime();
        int        activeCount        = reportDAO.getActiveReservationCount();
        Map<String, BigDecimal> revenueByType = reportDAO.getRevenueByRoomType();

        // ── Set as request attributes for the JSP ───────────────────────────
        request.setAttribute("monthlyCount",   monthlyCount);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("totalAllTime",   totalAllTime);
        request.setAttribute("activeCount",    activeCount);
        request.setAttribute("revenueByType",  revenueByType);

        // ── Forward to reports.jsp view ─────────────────────────────────────
        request.getRequestDispatcher("/views/reports.jsp").forward(request, response);
    }
}
