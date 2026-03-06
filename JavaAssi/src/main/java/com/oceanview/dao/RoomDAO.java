package com.oceanview.dao;

import com.oceanview.db.DBConnection;
import com.oceanview.model.Room;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * RoomDAO - Data Access Object Pattern
 * ──────────────────────────────────────
 * Handles all database operations related to the 'rooms' table.
 *
 * Design Pattern: DAO (Data Access Object)
 */
public class RoomDAO {

    private final Connection conn;

    public RoomDAO() {
        this.conn = DBConnection.getInstance().getConnection();
    }

    /**
     * Retrieves all rooms from the database.
     *
     * @return List of all Room objects
     */
    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT id, room_number, room_type, rate_per_night, description, is_available "
                   + "FROM rooms ORDER BY room_type, room_number";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            System.err.println("[RoomDAO] getAllRooms() error: " + e.getMessage());
        }
        return rooms;
    }

    /**
     * Retrieves a single room by its primary key ID.
     *
     * @param roomId the room's database ID
     * @return Room object or null
     */
    public Room getRoomById(int roomId) {
        String sql = "SELECT id, room_number, room_type, rate_per_night, description, is_available "
                   + "FROM rooms WHERE id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToRoom(rs);
            }
        } catch (SQLException e) {
            System.err.println("[RoomDAO] getRoomById() error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Retrieves all available rooms of a specific type.
     *
     * @param roomType the room type string (e.g. "Deluxe")
     * @return List of matching available rooms
     */
    public List<Room> getAvailableRoomsByType(String roomType) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT id, room_number, room_type, rate_per_night, description, is_available "
                   + "FROM rooms WHERE room_type = ? AND is_available = 1";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, roomType);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            System.err.println("[RoomDAO] getAvailableRoomsByType() error: " + e.getMessage());
        }
        return rooms;
    }

    /**
     * Returns distinct room types for populating the dropdown in the form.
     *
     * @return List of room type strings
     */
    public List<String> getDistinctRoomTypes() {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT room_type FROM rooms ORDER BY room_type";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                types.add(rs.getString("room_type"));
            }
        } catch (SQLException e) {
            System.err.println("[RoomDAO] getDistinctRoomTypes() error: " + e.getMessage());
        }
        return types;
    }

    /**
     * Returns the rate per night for the first available room of a given type.
     * Used in bill calculation helpers.
     *
     * @param roomType room type string
     * @return rate per night as BigDecimal, or ZERO if not found
     */
    public BigDecimal getRateByType(String roomType) {
        String sql = "SELECT rate_per_night FROM rooms WHERE room_type = ? LIMIT 1";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, roomType);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("rate_per_night");
            }
        } catch (SQLException e) {
            System.err.println("[RoomDAO] getRateByType() error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    // ── Private helper ────────────────────────────────────────────────────────

    /**
     * Maps a single ResultSet row to a Room object.
     */
    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setId(rs.getInt("id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomType(rs.getString("room_type"));
        room.setRatePerNight(rs.getBigDecimal("rate_per_night"));
        room.setDescription(rs.getString("description"));
        room.setAvailable(rs.getBoolean("is_available"));
        return room;
    }
}
