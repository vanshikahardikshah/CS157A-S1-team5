package com.nearfix.dao;

import com.nearfix.model.Review;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ReviewDAO {

    public boolean createReview(Review review) {
        String sql = "INSERT INTO reviews (booking_id, customer_id, provider_id, rating, comment) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getBookingId());
            ps.setInt(2, review.getCustomerId());
            ps.setInt(3, review.getProviderId());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getComment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Review getByBookingId(int bookingId) {
        String sql = "SELECT * FROM reviews WHERE booking_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Review> getByProviderId(int providerId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.name AS customer_name, s.service_name " +
                     "FROM reviews r " +
                     "JOIN users u ON r.customer_id = u.user_id " +
                     "JOIN bookings b ON r.booking_id = b.booking_id " +
                     "JOIN services s ON b.service_id = s.service_id " +
                     "WHERE r.provider_id = ? " +
                     "ORDER BY r.review_date DESC, r.review_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                reviews.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public RatingStats getProviderRatingStats(int providerId) {
        String sql = "SELECT AVG(rating) AS avg_rating, COUNT(*) AS review_count FROM reviews WHERE provider_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("review_count");
                double avg = count > 0 ? rs.getDouble("avg_rating") : 0.0;
                return new RatingStats(avg, count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new RatingStats(0.0, 0);
    }

    public List<Review> getAll() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.name AS customer_name, s.service_name, p.business_name AS provider_business_name " +
                     "FROM reviews r " +
                     "JOIN users u ON r.customer_id = u.user_id " +
                     "JOIN bookings b ON r.booking_id = b.booking_id " +
                     "JOIN services s ON b.service_id = s.service_id " +
                     "JOIN providers p ON r.provider_id = p.provider_id " +
                     "ORDER BY r.review_date DESC, r.review_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                reviews.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public boolean delete(int reviewId) {
        String sql = "DELETE FROM reviews WHERE review_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Set<Integer> getReviewedBookingIdsForCustomer(int customerId) {
        Set<Integer> ids = new HashSet<>();
        String sql = "SELECT booking_id FROM reviews WHERE customer_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("booking_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }

    private Review mapRow(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setReviewId(rs.getInt("review_id"));
        r.setBookingId(rs.getInt("booking_id"));
        r.setCustomerId(rs.getInt("customer_id"));
        r.setProviderId(rs.getInt("provider_id"));
        r.setRating(rs.getInt("rating"));
        r.setComment(rs.getString("comment"));
        r.setReviewDate(rs.getTimestamp("review_date"));
        try { r.setCustomerName(rs.getString("customer_name")); } catch (SQLException ignored) {}
        try { r.setServiceName(rs.getString("service_name")); } catch (SQLException ignored) {}
        try { r.setProviderBusinessName(rs.getString("provider_business_name")); } catch (SQLException ignored) {}
        return r;
    }

    public static class RatingStats {
        private final double averageRating;
        private final int reviewCount;

        public RatingStats(double averageRating, int reviewCount) {
            this.averageRating = averageRating;
            this.reviewCount = reviewCount;
        }

        public double getAverageRating() { return averageRating; }
        public int getReviewCount() { return reviewCount; }
    }
}
