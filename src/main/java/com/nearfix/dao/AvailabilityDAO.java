package com.nearfix.dao;

import com.nearfix.model.Availability;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AvailabilityDAO {

    public boolean addSlot(Availability slot) {
        String sql = "INSERT INTO availability (provider_id, available_date, start_time, end_time) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slot.getProviderId());
            ps.setDate(2, slot.getAvailableDate());
            ps.setTime(3, slot.getStartTime());
            ps.setTime(4, slot.getEndTime());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void deleteExpiredSlots() {
        String sql = "DELETE FROM availability " +
                     "WHERE available_date < CURDATE() " +
                     "OR (available_date = CURDATE() AND end_time <= CURTIME())";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Availability> getByProviderId(int providerId) {
        List<Availability> slots = new ArrayList<>();

        deleteExpiredSlots();

        String sql = "SELECT * FROM availability " +
                     "WHERE provider_id = ? " +
                     "AND (available_date > CURDATE() " +
                     "OR (available_date = CURDATE() AND end_time > CURTIME())) " +
                     "ORDER BY available_date, start_time";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                slots.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return slots;
    }

    public Availability getById(int availabilityId) {
        deleteExpiredSlots();

        String sql = "SELECT * FROM availability " +
                     "WHERE availability_id = ? " +
                     "AND (available_date > CURDATE() " +
                     "OR (available_date = CURDATE() AND end_time > CURTIME()))";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, availabilityId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteSlot(int availabilityId, int providerId) {
        String sql = "DELETE FROM availability WHERE availability_id = ? AND provider_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, availabilityId);
            ps.setInt(2, providerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Availability mapRow(ResultSet rs) throws SQLException {
        Availability a = new Availability();
        a.setAvailabilityId(rs.getInt("availability_id"));
        a.setProviderId(rs.getInt("provider_id"));
        a.setAvailableDate(rs.getDate("available_date"));
        a.setStartTime(rs.getTime("start_time"));
        a.setEndTime(rs.getTime("end_time"));
        return a;
    }
}