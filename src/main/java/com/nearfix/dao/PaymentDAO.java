package com.nearfix.dao;

import com.nearfix.model.Payment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean createPayment(Payment payment) {
        String sql = "INSERT INTO payments (booking_id, card_last4, payment_method, amount, payment_status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, payment.getBookingId());
            ps.setString(2, payment.getCardLast4());
            ps.setString(3, payment.getPaymentMethod());
            ps.setBigDecimal(4, payment.getAmount());
            ps.setString(5, payment.getPaymentStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Payment getByBookingId(int bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id = ?";
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
                     "JOIN bookings b ON p.booking_id = b.booking_id " +
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
        p.setBookingId(rs.getInt("booking_id"));
        p.setCardLast4(rs.getString("card_last4"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentStatus(rs.getString("payment_status"));
        return p;
    }
}
