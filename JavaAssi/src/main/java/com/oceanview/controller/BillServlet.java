package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * BillServlet - MVC Controller
 * ──────────────────────────────
 * Fetches a reservation by ID or Reservation No, calculates the bill,
 * and forwards to the bill print view.
 *
 * GET /bill?reservationNo=OVR-00001  → Show bill for that reservation
 *
 * Design Pattern: MVC - Controller
 */
public class BillServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Security check ──────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String reservationNo = request.getParameter("reservationNo");

        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            request.setAttribute("billError", "Reservation number is required to generate a bill.");
            request.getRequestDispatcher("/views/bill.jsp").forward(request, response);
            return;
        }

        // ── Fetch reservation from DB ────────────────────────────────────────
        Reservation res = reservationDAO.getByReservationNo(reservationNo.trim().toUpperCase());

        if (res == null) {
            request.setAttribute("billError",
                "No reservation found with number: " + reservationNo.toUpperCase());
        } else {
            // The total_cost is already stored in DB (calculated at booking time).
            // We set it in the request scope for the JSP view to render the bill.
            request.setAttribute("reservation", res);
        }

        request.getRequestDispatcher("/views/bill.jsp").forward(request, response);
    }
}
