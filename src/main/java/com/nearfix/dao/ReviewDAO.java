package com.nearfix.dao;

import com.nearfix.model.Review;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public boolean submitReview(int bookingId, int customerId, int providerId, int rating, String comment) {
        if (rating < 1 || rating > 5) return false;
        String checkSql =
            "SELECT b.booking_id FROM bookings b " +
            "JOIN services s ON b.service_id = s.service_id " +
            "WHERE b.booking_id = ? AND b.customer_id = ? " +
            "  AND b.status = 'completed' AND s.provider_id = ?";
        String insertSql =
            "INSERT INTO reviews (booking_id, customer_id, provider_id, rating, comment) " +
            "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement check = conn.prepareStatement(checkSql)) {
            check.setInt(1, bookingId);
            check.setInt(2, customerId);
            check.setInt(3, providerId);
            try (ResultSet rs = check.executeQuery()) {
                if (!rs.next()) return false;
            }
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, customerId);
                ps.setInt(3, providerId);
                ps.setInt(4, rating);
                ps.setString(5, comment);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Integer> getReviewableBookingIds(int customerId, int providerId) {
        List<Integer> ids = new ArrayList<>();
        String sql =
            "SELECT b.booking_id FROM bookings b " +
            "JOIN services s ON b.service_id = s.service_id " +
            "LEFT JOIN reviews r ON r.booking_id = b.booking_id " +
            "WHERE b.customer_id = ? AND s.provider_id = ? " +
            "  AND b.status = 'completed' AND r.review_id IS NULL " +
            "ORDER BY b.booking_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, providerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt("booking_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }

    public List<Review> getByProvider(int providerId) {
        List<Review> reviews = new ArrayList<>();
        String sql =
            "SELECT r.*, u.name AS customer_name FROM reviews r " +
            "JOIN users u ON r.customer_id = u.user_id " +
            "WHERE r.provider_id = ? ORDER BY r.review_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setBookingId(rs.getInt("booking_id"));
                    r.setCustomerId(rs.getInt("customer_id"));
                    r.setProviderId(rs.getInt("provider_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setReviewDate(rs.getTimestamp("review_date"));
                    r.setCustomerName(rs.getString("customer_name"));
                    reviews.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }
}
