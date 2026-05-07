package com.nearfix.dao;

import com.nearfix.model.Payment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean createPayment(Payment payment) {
        String sql = "INSERT INTO payments (card_last4, payment_method, amount, payment_status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, payment.getCardLast4());
            ps.setString(2, payment.getPaymentMethod());
            ps.setBigDecimal(3, payment.getAmount());
            ps.setString(4, payment.getPaymentStatus());
            if (ps.executeUpdate() == 0) {
                return false;
            }
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    payment.setPaymentId(keys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void createPaymentForBooking(Connection conn, int bookingId, Payment payment) throws SQLException {
        String paymentSql = "INSERT INTO payments (card_last4, payment_method, amount, payment_status) VALUES (?, ?, ?, ?)";
        String hasPaymentSql = "INSERT INTO has_payment (booking_id, payment_id) VALUES (?, ?)";

        int paymentId;
        try (PreparedStatement ps = conn.prepareStatement(paymentSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, payment.getCardLast4());
            ps.setString(2, payment.getPaymentMethod());
            ps.setBigDecimal(3, payment.getAmount());
            ps.setString(4, payment.getPaymentStatus());
            if (ps.executeUpdate() == 0) {
                throw new SQLException("Creating payment failed, no rows affected.");
            }
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("Creating payment failed, no ID obtained.");
                }
                paymentId = keys.getInt(1);
                payment.setPaymentId(paymentId);
            }
        }

        try (PreparedStatement ps = conn.prepareStatement(hasPaymentSql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, paymentId);
            if (ps.executeUpdate() == 0) {
                throw new SQLException("Creating HasPayment relationship failed.");
            }
        }
    }

    public Payment getById(int paymentId) {
        String sql = "SELECT * FROM payments WHERE payment_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Payment getByBookingId(int bookingId) {
        String sql = "SELECT p.* " +
                     "FROM payments p " +
                     "JOIN has_payment hp ON p.payment_id = hp.payment_id " +
                     "WHERE hp.booking_id = ?";
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

    public List<Payment> getByCustomerId(int customerId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.* " +
                     "FROM payments p " +
                     "JOIN has_payment hp ON p.payment_id = hp.payment_id " +
                     "JOIN bookings b ON hp.booking_id = b.booking_id " +
                     "WHERE b.customer_id = ? " +
                     "ORDER BY p.payment_date DESC, p.payment_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                payments.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    private Payment mapRow(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setCardLast4(rs.getString("card_last4"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentStatus(rs.getString("payment_status"));
        return p;
    }
}
