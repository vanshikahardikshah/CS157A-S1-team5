package com.nearfix.dao;

import com.nearfix.model.SearchResult;
import com.nearfix.model.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public List<SearchResult> search(String keyword, String zipCode) throws SQLException {
        return search(keyword, zipCode, null);
    }

    public List<SearchResult> search(String keyword, String zipCode, String preferredZip) throws SQLException {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasZipFilter = zipCode != null && !zipCode.trim().isEmpty();

        String trimmedKeyword = hasKeyword ? keyword.trim() : "";
        String trimmedPreferredZip = preferredZip == null ? "" : preferredZip.trim();

        String contains = "%" + trimmedKeyword + "%";
        String prefix = trimmedKeyword + "%";

        StringBuilder sql = new StringBuilder(
            "SELECT s.service_id, s.provider_id, s.service_name, s.description, " +
            "s.price, s.location_zip, c.category_name, p.business_name, " +
            "p.contact_number, u.email, " +
            "COALESCE(rev.avg_rating, 0) AS avg_rating, " +
            "COALESCE(rev.review_count, 0) AS review_count " +
            "FROM services s " +
            "JOIN providers p ON s.provider_id = p.provider_id " +
            "JOIN users u ON p.user_id = u.user_id " +
            "JOIN service_categories c ON s.category_id = c.category_id " +
            "LEFT JOIN (" +
            "    SELECT provider_id, AVG(rating) AS avg_rating, COUNT(*) AS review_count " +
            "    FROM reviews GROUP BY provider_id" +
            ") rev ON rev.provider_id = p.provider_id " +
            "WHERE 1 = 1"
        );

        if (hasKeyword) {
            sql.append(
                " AND (" +
                "s.service_name LIKE ? OR " +
                "s.description LIKE ? OR " +
                "c.category_name LIKE ? OR " +
                "p.business_name LIKE ?" +
                ")"
            );
        }

        if (hasZipFilter) {
            sql.append(" AND s.location_zip = ?");
        }

        sql.append(
            " ORDER BY CASE " +
            "   WHEN ? <> '' AND s.service_name = ? THEN 0 " +
            "   WHEN ? <> '' AND s.service_name LIKE ? THEN 1 " +
            "   WHEN ? <> '' AND c.category_name LIKE ? THEN 2 " +
            "   WHEN ? <> '' AND p.business_name LIKE ? THEN 3 " +
            "   ELSE 4 END, " +
            " CASE WHEN ? <> '' AND s.location_zip = ? THEN 0 ELSE 1 END, " +
            " s.service_name"
        );

        List<SearchResult> results = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;

            if (hasKeyword) {
                ps.setString(idx++, contains);
                ps.setString(idx++, contains);
                ps.setString(idx++, contains);
                ps.setString(idx++, contains);
            }

            if (hasZipFilter) {
                ps.setString(idx++, zipCode.trim());
            }

            ps.setString(idx++, trimmedKeyword);
            ps.setString(idx++, trimmedKeyword);
            ps.setString(idx++, trimmedKeyword);
            ps.setString(idx++, prefix);
            ps.setString(idx++, trimmedKeyword);
            ps.setString(idx++, contains);
            ps.setString(idx++, trimmedKeyword);
            ps.setString(idx++, contains);
            ps.setString(idx++, trimmedPreferredZip);
            ps.setString(idx++, trimmedPreferredZip);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SearchResult r = new SearchResult();
                    r.setServiceId(rs.getInt("service_id"));
                    r.setProviderId(rs.getInt("provider_id"));
                    r.setServiceName(rs.getString("service_name"));
                    r.setDescription(rs.getString("description"));
                    r.setPrice(rs.getBigDecimal("price"));
                    r.setLocationZip(rs.getString("location_zip"));
                    r.setCategoryName(rs.getString("category_name"));
                    r.setBusinessName(rs.getString("business_name"));
                    r.setContactNumber(rs.getString("contact_number"));
                    r.setProviderEmail(rs.getString("email"));
                    r.setAvgRating(rs.getBigDecimal("avg_rating"));
                    r.setReviewCount(rs.getInt("review_count"));
                    results.add(r);
                }
            }
        }

        return results;
    }

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
