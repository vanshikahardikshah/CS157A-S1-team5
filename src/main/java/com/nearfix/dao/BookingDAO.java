package com.nearfix.dao;

import com.nearfix.model.Booking;
import com.nearfix.model.BookingDetails;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    /**
     * Create a booking for the given customer against the given service and availability slot.
     * Atomically: validates the slot belongs to the service's provider, inserts the booking,
     * and consumes the slot. Returns the new booking_id, or null on any failure.
     */
    public Integer create(int customerId, int serviceId, int availabilityId) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            int slotProviderId;
            Date slotDate;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT provider_id, available_date FROM availability " +
                    "WHERE availability_id = ? FOR UPDATE")) {
                ps.setInt(1, availabilityId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) { conn.rollback(); return null; }
                    slotProviderId = rs.getInt("provider_id");
                    slotDate = rs.getDate("available_date");
                }
            }

            int serviceProviderId;
            BigDecimal price;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT provider_id, price FROM services WHERE service_id = ?")) {
                ps.setInt(1, serviceId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) { conn.rollback(); return null; }
                    serviceProviderId = rs.getInt("provider_id");
                    price = rs.getBigDecimal("price");
                }
            }

            if (slotProviderId != serviceProviderId) {
                conn.rollback();
                return null;
            }

            int bookingId;
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO bookings (customer_id, service_id, booking_date, status, total_price) " +
                    "VALUES (?, ?, ?, 'pending', ?)",
                    Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, customerId);
                ps.setInt(2, serviceId);
                ps.setDate(3, slotDate);
                ps.setBigDecimal(4, price);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) { conn.rollback(); return null; }
                    bookingId = keys.getInt(1);
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM availability WHERE availability_id = ?")) {
                ps.setInt(1, availabilityId);
                ps.executeUpdate();
            }

            conn.commit();
            return bookingId;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignore) {}
            }
            e.printStackTrace();
            return null;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException ignore) {}
            }
        }
    }

    public List<BookingDetails> getDetailsByCustomerId(int customerId) {
        List<BookingDetails> out = new ArrayList<>();
        String sql =
            "SELECT b.booking_id, b.customer_id, b.service_id, b.booking_date, " +
            "       b.status, b.total_price, " +
            "       s.service_name, c.category_name, " +
            "       p.provider_id, p.business_name, p.contact_number, u.email " +
            "FROM bookings b " +
            "JOIN services s ON b.service_id = s.service_id " +
            "JOIN service_categories c ON s.category_id = c.category_id " +
            "JOIN providers p ON s.provider_id = p.provider_id " +
            "JOIN users u ON p.user_id = u.user_id " +
            "WHERE b.customer_id = ? " +
            "ORDER BY b.booking_date DESC, b.booking_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingDetails d = new BookingDetails();
                    d.setBookingId(rs.getInt("booking_id"));
                    d.setCustomerId(rs.getInt("customer_id"));
                    d.setServiceId(rs.getInt("service_id"));
                    d.setBookingDate(rs.getDate("booking_date"));
                    d.setStatus(rs.getString("status"));
                    d.setTotalPrice(rs.getBigDecimal("total_price"));
                    d.setServiceName(rs.getString("service_name"));
                    d.setCategoryName(rs.getString("category_name"));
                    d.setProviderId(rs.getInt("provider_id"));
                    d.setBusinessName(rs.getString("business_name"));
                    d.setProviderContact(rs.getString("contact_number"));
                    d.setProviderEmail(rs.getString("email"));
                    out.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return out;
    }

    public boolean cancelByCustomer(int bookingId, int customerId) {
        String sql = "UPDATE bookings SET status = 'cancelled' " +
                     "WHERE booking_id = ? AND customer_id = ? AND status IN ('pending', 'confirmed')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Booking> getByProviderId(int providerId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.* FROM bookings b " +
                     "JOIN services s ON b.service_id = s.service_id " +
                     "WHERE s.provider_id = ? " +
                     "ORDER BY b.booking_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookings.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public Booking getById(int bookingId) {
        String sql = "SELECT * FROM bookings WHERE booking_id = ?";
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

    public boolean updateStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Booking mapRow(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setCustomerId(rs.getInt("customer_id"));
        b.setServiceId(rs.getInt("service_id"));
        b.setBookingDate(rs.getDate("booking_date"));
        b.setStatus(rs.getString("status"));
        b.setTotalPrice(rs.getBigDecimal("total_price"));
        return b;
    }
}
