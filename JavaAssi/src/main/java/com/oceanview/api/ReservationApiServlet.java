package com.oceanview.api;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.List;

/**
 * ReservationApiServlet — RESTful Web Service
 * ─────────────────────────────────────────────
 * Demonstrates a simple REST API for the Hotel Reservation System.
 * All responses are in JSON format.
 *
 * Endpoints:
 *   GET  /api/reservations          → JSON array of ALL reservations
 *   GET  /api/reservations/{id}     → JSON object for ONE reservation
 *   POST /api/reservations          → Create a new reservation via JSON body
 *
 * This satisfies the "Distributed Application / Web Service" requirement.
 *
 * Design Pattern: RESTful Web Service using Pure Servlet
 */
public class ReservationApiServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomDAO        roomDAO        = new RoomDAO();

    // ─────────────────────────────────────────────────────────────────────────
    // Helper: set JSON response headers
    // ─────────────────────────────────────────────────────────────────────────
    private void setJsonHeaders(HttpServletResponse response) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        // Allow cross-origin access (CORS) for demo / testing with tools like Postman
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET — retrieve reservations
    // ─────────────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        setJsonHeaders(response);
        PrintWriter out = response.getWriter();

        // PathInfo will be null or "/" for /api/reservations
        // PathInfo will be "/3" for /api/reservations/3
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // ─ GET /api/reservations  →  list all ─────────────────────
                List<Reservation> all = reservationDAO.getAll();
                JSONArray jsonArray = new JSONArray();
                for (Reservation res : all) {
                    jsonArray.put(reservationToJson(res));
                }
                out.print(jsonArray.toString(2));  // pretty-print with 2-space indent

            } else {
                // ─ GET /api/reservations/{id}  →  single reservation ──────
                String idStr = pathInfo.substring(1);  // strip leading "/"
                try {
                    int id = Integer.parseInt(idStr);
                    Reservation res = reservationDAO.getById(id);
                    if (res != null) {
                        out.print(reservationToJson(res).toString(2));
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        out.print(errorJson("Reservation not found with id: " + id));
                    }
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(errorJson("Invalid ID format. Use an integer, e.g. /api/reservations/1"));
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(errorJson("Server error: " + e.getMessage()));
        }
        out.flush();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POST — create a new reservation via JSON
    // ─────────────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        setJsonHeaders(response);
        PrintWriter out = response.getWriter();

        // Read JSON body
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        try {
            JSONObject body = new JSONObject(sb.toString());

            // ── Validate required fields ────────────────────────────────────
            if (!body.has("guestName") || !body.has("address") || !body.has("contactNo")
                    || !body.has("roomId") || !body.has("checkInDate") || !body.has("checkOutDate")
                    || !body.has("createdBy")) {

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(errorJson("Required fields: guestName, address, contactNo, "
                                  + "roomId, checkInDate, checkOutDate, createdBy"));
                out.flush();
                return;
            }

            // ── Build Reservation model ─────────────────────────────────────
            Reservation res = new Reservation();
            res.setGuestName(body.getString("guestName"));
            res.setAddress(body.getString("address"));
            res.setContactNo(body.getString("contactNo"));
            res.setRoomId(body.getInt("roomId"));
            res.setCheckInDate(LocalDate.parse(body.getString("checkInDate")));
            res.setCheckOutDate(LocalDate.parse(body.getString("checkOutDate")));
            res.setCreatedBy(body.getInt("createdBy"));

            // ── Validate dates ──────────────────────────────────────────────
            if (!res.getCheckInDate().isBefore(res.getCheckOutDate())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(errorJson("checkOutDate must be after checkInDate"));
                out.flush();
                return;
            }

            // ── Save to DB ──────────────────────────────────────────────────
            boolean saved = reservationDAO.addReservation(res);
            if (saved) {
                response.setStatus(HttpServletResponse.SC_CREATED);  // 201 Created
                JSONObject result = new JSONObject();
                result.put("message", "Reservation created successfully");
                result.put("reservationNo", res.getReservationNo());
                result.put("totalCost", res.getTotalCost());
                out.print(result.toString(2));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(errorJson("Failed to save reservation. Check room ID and staff ID."));
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(errorJson("Invalid JSON or data error: " + e.getMessage()));
        }
        out.flush();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Private helpers
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Converts a Reservation object to a JSONObject for API responses.
     */
    private JSONObject reservationToJson(Reservation res) {
        JSONObject json = new JSONObject();
        json.put("id",              res.getId());
        json.put("reservationNo",   res.getReservationNo());
        json.put("guestName",       res.getGuestName());
        json.put("address",         res.getAddress());
        json.put("contactNo",       res.getContactNo());
        json.put("checkInDate",     res.getCheckInDate().toString());
        json.put("checkOutDate",    res.getCheckOutDate().toString());
        json.put("numberOfNights",  res.getNumberOfNights());
        json.put("totalCost",       res.getTotalCost());
        json.put("status",          res.getStatus());
        json.put("createdBy",       res.getCreatedByName());

        if (res.getRoom() != null) {
            JSONObject roomJson = new JSONObject();
            roomJson.put("roomNumber",  res.getRoom().getRoomNumber());
            roomJson.put("roomType",    res.getRoom().getRoomType());
            roomJson.put("ratePerNight", res.getRoom().getRatePerNight());
            json.put("room", roomJson);
        }
        return json;
    }

    /**
     * Creates a simple JSON error response object.
     */
    private String errorJson(String message) {
        return new JSONObject().put("error", message).toString();
    }
}
