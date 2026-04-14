package com.nearfix.dao;

import com.nearfix.model.Provider;

import java.sql.*;

public class ProviderDAO {

    public boolean createProvider(int userId, String businessName, String contactNumber) {
        String sql = "INSERT INTO providers (user_id, business_name, contact_number) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, businessName);
            ps.setString(3, contactNumber);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Provider getByUserId(int userId) {
        String sql = "SELECT * FROM providers WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Provider getById(int providerId) {
        String sql = "SELECT * FROM providers WHERE provider_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateProfile(int providerId, String businessName, String contactNumber) {
        String sql = "UPDATE providers SET business_name = ?, contact_number = ? WHERE provider_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, businessName);
            ps.setString(2, contactNumber);
            ps.setInt(3, providerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Provider mapRow(ResultSet rs) throws SQLException {
        Provider p = new Provider();
        p.setProviderId(rs.getInt("provider_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setBusinessName(rs.getString("business_name"));
        p.setContactNumber(rs.getString("contact_number"));
        p.setApprovalStatus(rs.getString("approval_status"));
        return p;
    }
}
