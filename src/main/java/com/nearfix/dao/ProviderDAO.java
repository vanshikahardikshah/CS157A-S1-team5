package com.nearfix.dao;

import com.nearfix.model.Provider;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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

    public List<Provider> getAllProviders() {
        List<Provider> providers = new ArrayList<>();

        String sql = "SELECT p.provider_id, p.user_id, p.business_name, p.contact_number, p.approval_status, " +
                     "u.name, u.email, u.zip_code " +
                     "FROM providers p " +
                     "JOIN users u ON p.user_id = u.user_id " +
                     "ORDER BY p.provider_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Provider provider = new Provider();
                provider.setProviderId(rs.getInt("provider_id"));
                provider.setUserId(rs.getInt("user_id"));
                provider.setBusinessName(rs.getString("business_name"));
                provider.setContactNumber(rs.getString("contact_number"));
                provider.setApprovalStatus(rs.getString("approval_status"));
                provider.setName(rs.getString("name"));
                provider.setEmail(rs.getString("email"));
                provider.setZipCode(rs.getString("zip_code"));
                providers.add(provider);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return providers;
    }

    public boolean updateApprovalStatus(int providerId, String status) {
        String sql = "UPDATE providers SET approval_status = ? WHERE provider_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, providerId);
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