package com.nearfix.dao;

import com.nearfix.model.Booking;
import com.nearfix.model.Payment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public boolean createBooking(Booking booking) {
        String sql = "INSERT INTO bookings (customer_id, service_id, booking_date, status, total_price) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, booking.getCustomerId());
            ps.setInt(2, booking.getServiceId());
            ps.setDate(3, booking.getBookingDate());
            ps.setString(4, booking.getStatus());
            ps.setBigDecimal(5, booking.getTotalPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createBookingWithPayment(Booking booking, int availabilityId, int providerId, Payment payment) {
        String bookingSql = "INSERT INTO bookings (customer_id, service_id, booking_date, status, total_price) VALUES (?, ?, ?, ?, ?)";
        String paymentSql = "INSERT INTO payments (booking_id, card_last4, payment_method, amount, payment_status) VALUES (?, ?, ?, ?, ?)";
        String availabilitySql = "DELETE FROM availability WHERE availability_id = ? AND provider_id = ?";

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            int bookingId;
            try (PreparedStatement ps = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, booking.getCustomerId());
                ps.setInt(2, booking.getServiceId());
                ps.setDate(3, booking.getBookingDate());
                ps.setString(4, booking.getStatus());
                ps.setBigDecimal(5, booking.getTotalPrice());
                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) {
                        conn.rollback();
                        return false;
                    }
                    bookingId = keys.getInt(1);
                }
            }

            booking.setBookingId(bookingId);
            payment.setBookingId(bookingId);
            if (payment.getAmount() == null) {
                payment.setAmount(booking.getTotalPrice());
            }

            try (PreparedStatement ps = conn.prepareStatement(paymentSql)) {
                ps.setInt(1, payment.getBookingId());
                ps.setString(2, payment.getCardLast4());
                ps.setString(3, payment.getPaymentMethod());
                ps.setBigDecimal(4, payment.getAmount());
                ps.setString(5, payment.getPaymentStatus());
                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(availabilitySql)) {
                ps.setInt(1, availabilityId);
                ps.setInt(2, providerId);
                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ignored) {
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    public List<Booking> getByProviderId(int providerId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, s.service_name, u.name AS customer_name, p.business_name, " +
                     "pay.payment_id, pay.card_last4, pay.payment_method, pay.payment_date, " +
                     "pay.amount AS payment_amount, pay.payment_status " +
                     "FROM bookings b " +
                     "JOIN services s ON b.service_id = s.service_id " +
                     "JOIN users u ON b.customer_id = u.user_id " +
                     "JOIN providers p ON s.provider_id = p.provider_id " +
                     "LEFT JOIN payments pay ON b.booking_id = pay.booking_id " +
                     "WHERE s.provider_id = ? " +
                     "ORDER BY b.booking_date DESC, b.booking_id DESC";
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

    public List<Booking> getByCustomerId(int customerId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, s.service_name, p.business_name, " +
                     "pay.payment_id, pay.card_last4, pay.payment_method, pay.payment_date, " +
                     "pay.amount AS payment_amount, pay.payment_status " +
                     "FROM bookings b " +
                     "JOIN services s ON b.service_id = s.service_id " +
                     "JOIN providers p ON s.provider_id = p.provider_id " +
                     "LEFT JOIN payments pay ON b.booking_id = pay.booking_id " +
                     "WHERE b.customer_id = ? " +
                     "ORDER BY b.booking_date DESC, b.booking_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
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
        String sql = "SELECT b.*, pay.payment_id, pay.card_last4, pay.payment_method, pay.payment_date, " +
                     "pay.amount AS payment_amount, pay.payment_status " +
                     "FROM bookings b " +
                     "LEFT JOIN payments pay ON b.booking_id = pay.booking_id " +
                     "WHERE b.booking_id = ?";
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

        try {
            b.setServiceName(rs.getString("service_name"));
        } catch (SQLException ignored) {
        }
        try {
            b.setCustomerName(rs.getString("customer_name"));
        } catch (SQLException ignored) {
        }
        try {
            b.setProviderBusinessName(rs.getString("business_name"));
        } catch (SQLException ignored) {
        }
        try {
            Object paymentId = rs.getObject("payment_id");
            if (paymentId != null) {
                b.setPaymentId(((Number) paymentId).intValue());
                b.setCardLast4(rs.getString("card_last4"));
                b.setPaymentMethod(rs.getString("payment_method"));
                b.setPaymentDate(rs.getTimestamp("payment_date"));
                b.setPaymentAmount(rs.getBigDecimal("payment_amount"));
                b.setPaymentStatus(rs.getString("payment_status"));
            }
        } catch (SQLException ignored) {
        }
        return b;
    }
}
