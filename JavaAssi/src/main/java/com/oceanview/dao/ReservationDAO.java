package com.oceanview.dao;

import com.oceanview.db.DBConnection;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * ReservationDAO - Data Access Object Pattern
 * ─────────────────────────────────────────────
 * Handles all database operations for the 'reservations' table.
 * Also performs bill calculation using room rate × number of nights.
 *
 * Design Pattern: DAO (Data Access Object)
 */
public class ReservationDAO {

    private final Connection conn;

    public ReservationDAO() {
        this.conn = DBConnection.getInstance().getConnection();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ADD  (Create)
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Adds a new reservation record to the database.
     * Also auto-calculates the totalCost (nights × rate) before inserting.
     *
     * @param res the Reservation model (populated from the form)
     * @return true if insert succeeded, false otherwise
     */
    public boolean addReservation(Reservation res) {
        // 1. Auto-generate a unique Reservation Number: OVR-XXXXX
        String reservationNo = generateReservationNo();
        res.setReservationNo(reservationNo);

        // 2. Calculate total cost: nights × rate_per_night
        BigDecimal totalCost = calculateCost(res.getRoomId(),
                                              res.getCheckInDate(),
                                              res.getCheckOutDate());
        res.setTotalCost(totalCost);

        String sql = "INSERT INTO reservations "
                   + "(reservation_no, guest_name, address, contact_no, room_id, "
                   + " check_in_date, check_out_date, total_cost, status, created_by) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED', ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, res.getReservationNo());
            pstmt.setString(2, res.getGuestName());
            pstmt.setString(3, res.getAddress());
            pstmt.setString(4, res.getContactNo());
            pstmt.setInt(5, res.getRoomId());
            pstmt.setDate(6, Date.valueOf(res.getCheckInDate()));
            pstmt.setDate(7, Date.valueOf(res.getCheckOutDate()));
            pstmt.setBigDecimal(8, res.getTotalCost());
            pstmt.setInt(9, res.getCreatedBy());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("[ReservationDAO] addReservation() error: " + e.getMessage());
            return false;
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // READ  (Retrieve)
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Finds a reservation by its database ID (integer primary key).
     * Performs a JOIN with rooms and users tables to fill display fields.
     *
     * @param id the reservation's ID
     * @return Reservation object or null if not found
     */
    public Reservation getById(int id) {
        String sql = "SELECT r.*, rm.room_number, rm.room_type, rm.rate_per_night, "
                   + "       rm.description, rm.is_available, u.full_name AS staff_name "
                   + "FROM reservations r "
                   + "JOIN rooms rm ON r.room_id = rm.id "
                   + "JOIN users u  ON r.created_by = u.id "
                   + "WHERE r.id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("[ReservationDAO] getById() error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Finds a reservation by its human-readable Reservation Number (e.g. OVR-00003).
     *
     * @param reservationNo the reservation number string
     * @return Reservation object or null
     */
    public Reservation getByReservationNo(String reservationNo) {
        String sql = "SELECT r.*, rm.room_number, rm.room_type, rm.rate_per_night, "
                   + "       rm.description, rm.is_available, u.full_name AS staff_name "
                   + "FROM reservations r "
                   + "JOIN rooms rm ON r.room_id = rm.id "
                   + "JOIN users u  ON r.created_by = u.id "
                   + "WHERE r.reservation_no = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, reservationNo);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("[ReservationDAO] getByReservationNo() error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Retrieves all reservations (used for API and admin view).
     *
     * @return List of all Reservation objects
     */
    public List<Reservation> getAll() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, rm.room_number, rm.room_type, rm.rate_per_night, "
                   + "       rm.description, rm.is_available, u.full_name AS staff_name "
                   + "FROM reservations r "
                   + "JOIN rooms rm ON r.room_id = rm.id "
                   + "JOIN users u  ON r.created_by = u.id "
                   + "ORDER BY r.created_at DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("[ReservationDAO] getAll() error: " + e.getMessage());
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // BILL CALCULATION
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Calculates the bill for a given room and date range.
     * Formula: Number of Nights × Room Rate Per Night
     *
     * @param roomId       the room's ID
     * @param checkIn      check-in date
     * @param checkOut     check-out date
     * @return calculated total cost
     */
    public BigDecimal calculateCost(int roomId, LocalDate checkIn, LocalDate checkOut) {
        String sql = "SELECT rate_per_night FROM rooms WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                BigDecimal rate = rs.getBigDecimal("rate_per_night");
                long nights = java.time.temporal.ChronoUnit.DAYS.between(checkIn, checkOut);
                if (nights <= 0) nights = 1;
                return rate.multiply(BigDecimal.valueOf(nights));
            }
        } catch (SQLException e) {
            System.err.println("[ReservationDAO] calculateCost() error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRIVATE HELPERS
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Generates the next sequential reservation number in format OVR-XXXXX.
     */
    private String generateReservationNo() {
        String sql = "SELECT COUNT(*) AS total FROM reservations";
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                int nextNum = rs.getInt("total") + 1;
                return String.format("OVR-%05d", nextNum);
            }
        } catch (SQLException e) {
            System.err.println("[ReservationDAO] generateReservationNo() error: " + e.getMessage());
        }
        return "OVR-00001";
    }

    /**
     * Maps a ResultSet row (from a JOIN query) to a Reservation object.
     */
    private Reservation mapResultSet(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        res.setId(rs.getInt("id"));
        res.setReservationNo(rs.getString("reservation_no"));
        res.setGuestName(rs.getString("guest_name"));
        res.setAddress(rs.getString("address"));
        res.setContactNo(rs.getString("contact_no"));
        res.setRoomId(rs.getInt("room_id"));
        res.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        res.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        res.setTotalCost(rs.getBigDecimal("total_cost"));
        res.setStatus(rs.getString("status"));
        res.setCreatedBy(rs.getInt("created_by"));
        res.setCreatedByName(rs.getString("staff_name"));

        // Build nested Room object from JOIN columns
        Room room = new Room();
        room.setId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomType(rs.getString("room_type"));
        room.setRatePerNight(rs.getBigDecimal("rate_per_night"));
        room.setDescription(rs.getString("description"));
        room.setAvailable(rs.getBoolean("is_available"));
        res.setRoom(room);

        return res;
    }
}
