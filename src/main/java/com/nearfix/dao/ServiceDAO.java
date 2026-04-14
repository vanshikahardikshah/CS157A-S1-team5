package com.nearfix.dao;

import com.nearfix.model.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public boolean createService(Service service) {
        String sql = "INSERT INTO services (provider_id, category_id, service_name, description, price, location_zip) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, service.getProviderId());
            ps.setInt(2, service.getCategoryId());
            ps.setString(3, service.getServiceName());
            ps.setString(4, service.getDescription());
            ps.setBigDecimal(5, service.getPrice());
            ps.setString(6, service.getLocationZip());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Service> getByProviderId(int providerId) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE provider_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                services.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    public Service getById(int serviceId) {
        String sql = "SELECT * FROM services WHERE service_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateService(Service service) {
        String sql = "UPDATE services SET category_id = ?, service_name = ?, description = ?, price = ?, location_zip = ? WHERE service_id = ? AND provider_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, service.getCategoryId());
            ps.setString(2, service.getServiceName());
            ps.setString(3, service.getDescription());
            ps.setBigDecimal(4, service.getPrice());
            ps.setString(5, service.getLocationZip());
            ps.setInt(6, service.getServiceId());
            ps.setInt(7, service.getProviderId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteService(int serviceId, int providerId) {
        String sql = "DELETE FROM services WHERE service_id = ? AND provider_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            ps.setInt(2, providerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Service mapRow(ResultSet rs) throws SQLException {
        Service s = new Service();
        s.setServiceId(rs.getInt("service_id"));
        s.setProviderId(rs.getInt("provider_id"));
        s.setCategoryId(rs.getInt("category_id"));
        s.setServiceName(rs.getString("service_name"));
        s.setDescription(rs.getString("description"));
        s.setPrice(rs.getBigDecimal("price"));
        s.setLocationZip(rs.getString("location_zip"));
        return s;
    }
}
