package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * DashboardServlet - MVC Controller
 * ────────────────────────────────────
 * Displays the main dashboard with a list of recent reservations.
 * GET /dashboard → Fetch recent reservations → Forward to dashboard.jsp
 *
 * Design Pattern: MVC - Controller
 */
public class DashboardServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Security check: must be logged in ───────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ── Fetch all reservations to show on dashboard ──────────────────────
        List<Reservation> reservations = reservationDAO.getAll();
        request.setAttribute("reservations", reservations);

        // ── Forward to the View (dashboard.jsp) ─────────────────────────────
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}
