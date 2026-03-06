package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

/**
 * ReservationServlet - MVC Controller
 * ─────────────────────────────────────
 * Manages the Add Reservation and View Reservation flows.
 *
 * GET  /reservation?action=add   → Show the Add Reservation form
 * GET  /reservation?action=view  → Show View/Search form (with optional result by ID)
 * POST /reservation               → Validate & Save a new reservation
 *
 * Design Pattern: MVC - Controller
 */
public class ReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomDAO        roomDAO        = new RoomDAO();

    // ── Security helper ───────────────────────────────────────────────────────
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("loggedInUser") != null;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET
    // ─────────────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("view".equals(action)) {
            // ── View Reservation: search by Reservation No ──────────────────
            String reservationNo = request.getParameter("reservationNo");
            if (reservationNo != null && !reservationNo.trim().isEmpty()) {
                Reservation res = reservationDAO.getByReservationNo(reservationNo.trim().toUpperCase());
                if (res != null) {
                    request.setAttribute("reservation", res);
                } else {
                    request.setAttribute("searchError",
                        "No reservation found with number: " + reservationNo.toUpperCase());
                }
            }
            request.getRequestDispatcher("/views/viewReservation.jsp").forward(request, response);

        } else {
            // ── Add Reservation: Show form with room list ───────────────────
            List<Room> rooms = roomDAO.getAllRooms();
            request.setAttribute("rooms", rooms);
            request.getRequestDispatcher("/views/addReservation.jsp").forward(request, response);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POST — Save new reservation
    // ─────────────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ── Read form parameters ────────────────────────────────────────────
        String guestName    = request.getParameter("guestName");
        String address      = request.getParameter("address");
        String contactNo    = request.getParameter("contactNo");
        String roomIdStr    = request.getParameter("roomId");
        String checkInStr   = request.getParameter("checkInDate");
        String checkOutStr  = request.getParameter("checkOutDate");

        // ── Server-side validation ──────────────────────────────────────────
        List<String> errors = new ArrayList<>();

        if (guestName == null || guestName.trim().isEmpty())
            errors.add("Guest name is required.");
        if (address == null || address.trim().isEmpty())
            errors.add("Address is required.");
        if (contactNo == null || contactNo.trim().isEmpty())
            errors.add("Contact number is required.");
        else if (!contactNo.trim().matches("^[0-9+\\-\\s]{7,15}$"))
            errors.add("Contact number must be 7-15 digits.");
        if (roomIdStr == null || roomIdStr.trim().isEmpty())
            errors.add("Please select a room.");

        LocalDate checkIn  = null;
        LocalDate checkOut = null;

        try {
            if (checkInStr != null && !checkInStr.isEmpty())
                checkIn = LocalDate.parse(checkInStr);
            else
                errors.add("Check-in date is required.");
        } catch (DateTimeParseException e) {
            errors.add("Invalid check-in date format.");
        }

        try {
            if (checkOutStr != null && !checkOutStr.isEmpty())
                checkOut = LocalDate.parse(checkOutStr);
            else
                errors.add("Check-out date is required.");
        } catch (DateTimeParseException e) {
            errors.add("Invalid check-out date format.");
        }

        if (checkIn != null && checkOut != null) {
            if (!checkIn.isBefore(checkOut))
                errors.add("Check-out date must be after check-in date.");
            if (checkIn.isBefore(LocalDate.now()))
                errors.add("Check-in date cannot be in the past.");
        }

        // ── If validation failed, re-show form with errors ──────────────────
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("rooms", roomDAO.getAllRooms());
            // Preserve form data so the user doesn't re-type everything
            request.setAttribute("enteredGuestName",  guestName);
            request.setAttribute("enteredAddress",    address);
            request.setAttribute("enteredContactNo",  contactNo);
            request.setAttribute("enteredRoomId",     roomIdStr);
            request.setAttribute("enteredCheckIn",    checkInStr);
            request.setAttribute("enteredCheckOut",   checkOutStr);
            request.getRequestDispatcher("/views/addReservation.jsp").forward(request, response);
            return;
        }

        // ── Build Reservation model and save ────────────────────────────────
        HttpSession session = request.getSession(false);
        User loggedInUser   = (User) session.getAttribute("loggedInUser");

        Reservation res = new Reservation();
        res.setGuestName(guestName.trim());
        res.setAddress(address.trim());
        res.setContactNo(contactNo.trim());
        res.setRoomId(Integer.parseInt(roomIdStr));
        res.setCheckInDate(checkIn);
        res.setCheckOutDate(checkOut);
        res.setCreatedBy(loggedInUser.getId());

        boolean success = reservationDAO.addReservation(res);

        if (success) {
            // ─ Show success message with the generated reservation number ───
            request.setAttribute("successMsg",
                "Reservation added successfully! Reservation No: " + res.getReservationNo());
            request.setAttribute("rooms", roomDAO.getAllRooms());
            request.getRequestDispatcher("/views/addReservation.jsp").forward(request, response);
        } else {
            request.setAttribute("errors",
                List.of("Failed to save reservation. Please try again."));
            request.setAttribute("rooms", roomDAO.getAllRooms());
            request.getRequestDispatcher("/views/addReservation.jsp").forward(request, response);
        }
    }
}
