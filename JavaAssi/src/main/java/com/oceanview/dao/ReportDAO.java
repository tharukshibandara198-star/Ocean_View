package com.oceanview.dao;

import com.oceanview.db.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * ReportDAO - Data Access Object Pattern
 * ────────────────────────────────────────
 * Provides aggregated queries for the Reports/Dashboard page.
 * Returns summary statistics: reservation counts and revenue.
 *
 * Design Pattern: DAO (Data Access Object)
 */
public class ReportDAO {

    private final Connection conn;

    public ReportDAO() {
        this.conn = DBConnection.getInstance().getConnection();
    }

    /**
     * Returns the total number of reservations made in the current calendar month.
     *
     * @return count of reservations this month
     */
    public int getCurrentMonthReservationCount() {
        String sql = "SELECT COUNT(*) AS total FROM reservations "
                   + "WHERE MONTH(created_at) = MONTH(CURDATE()) "
                   + "  AND YEAR(created_at)  = YEAR(CURDATE())";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("[ReportDAO] getCurrentMonthReservationCount() error: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Returns the total revenue (sum of total_cost) for the current calendar month.
     *
     * @return total revenue as BigDecimal
     */
    public BigDecimal getCurrentMonthRevenue() {
        String sql = "SELECT COALESCE(SUM(total_cost), 0) AS revenue FROM reservations "
                   + "WHERE MONTH(created_at) = MONTH(CURDATE()) "
                   + "  AND YEAR(created_at)  = YEAR(CURDATE())";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("revenue");
            }
        } catch (SQLException e) {
            System.err.println("[ReportDAO] getCurrentMonthRevenue() error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    /**
     * Returns the total number of all reservations ever in the system.
     *
     * @return total reservation count (all time)
     */
    public int getTotalReservationsAllTime() {
        String sql = "SELECT COUNT(*) AS total FROM reservations";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("[ReportDAO] getTotalReservationsAllTime() error: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Returns the count of currently CONFIRMED reservations (active bookings).
     *
     * @return count of active confirmed reservations
     */
    public int getActiveReservationCount() {
        String sql = "SELECT COUNT(*) AS total FROM reservations WHERE status = 'CONFIRMED'";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("[ReportDAO] getActiveReservationCount() error: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Returns revenue grouped by room type for the current month.
     * Used to display a breakdown table on the reports page.
     *
     * @return Map of roomType -> revenue
     */
    public Map<String, BigDecimal> getRevenueByRoomType() {
        Map<String, BigDecimal> revenueMap = new LinkedHashMap<>();
        String sql = "SELECT rm.room_type, COALESCE(SUM(r.total_cost), 0) AS revenue "
                   + "FROM reservations r "
                   + "JOIN rooms rm ON r.room_id = rm.id "
                   + "WHERE MONTH(r.created_at) = MONTH(CURDATE()) "
                   + "  AND YEAR(r.created_at)  = YEAR(CURDATE()) "
                   + "GROUP BY rm.room_type "
                   + "ORDER BY revenue DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                revenueMap.put(rs.getString("room_type"), rs.getBigDecimal("revenue"));
            }
        } catch (SQLException e) {
            System.err.println("[ReportDAO] getRevenueByRoomType() error: " + e.getMessage());
        }
        return revenueMap;
    }
}
