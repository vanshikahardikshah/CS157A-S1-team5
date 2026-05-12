package com.nearfix.dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SearchDAO {

    public static class SearchResult {
        private int serviceId;
        private int providerId;
        private String serviceName;
        private String description;
        private BigDecimal price;
        private String locationZip;
        private String businessName;
        private String providerEmail;
        private int categoryId;
        private String categoryName;
        private double avgRating;
        private int reviewCount;
        private int relevance;
        private int zipMatch;

        public int getServiceId() { return serviceId; }
        public int getProviderId() { return providerId; }
        public String getServiceName() { return serviceName; }
        public String getDescription() { return description; }
        public BigDecimal getPrice() { return price; }
        public String getLocationZip() { return locationZip; }
        public String getBusinessName() { return businessName; }
        public String getProviderEmail() { return providerEmail; }
        public int getCategoryId() { return categoryId; }
        public String getCategoryName() { return categoryName; }
        public double getAvgRating() { return avgRating; }
        public int getReviewCount() { return reviewCount; }
        public int getRelevance() { return relevance; }
        public int getZipMatch() { return zipMatch; }
    }

    public List<SearchResult> searchServices(
            String keyword,
            String zipCode,
            int categoryId,
            int minRating,
            String availableOn) {

        List<SearchResult> results = new ArrayList<>();

        String kw = (keyword == null) ? "" : keyword.trim();
        boolean hasKeyword = !kw.isEmpty();
        String kwLike = "%" + kw + "%";
        String kwPrefix = kw + "%";

        String zip = (zipCode == null) ? "" : zipCode.trim();
        boolean hasZip = !zip.isEmpty();

        String date = (availableOn == null) ? "" : availableOn.trim();
        boolean hasDate = !date.isEmpty();

        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT s.service_id, s.provider_id, s.service_name, s.description, s.price, s.location_zip, ")
           .append("p.business_name, u.email, c.category_id, c.category_name, ")
           .append("COALESCE(rs.avg_rating, 0) AS avg_rating, ")
           .append("COALESCE(rs.review_count, 0) AS review_count, ");

        if (hasKeyword) {
            sql.append("((CASE WHEN s.service_name LIKE ? THEN 5 ELSE 0 END) ")
               .append("+ (CASE WHEN s.service_name LIKE ? THEN 3 ELSE 0 END) ")
               .append("+ (CASE WHEN c.category_name LIKE ? THEN 3 ELSE 0 END) ")
               .append("+ (CASE WHEN s.description LIKE ? THEN 1 ELSE 0 END)) AS relevance, ");
            params.add(kwLike);
            params.add(kwPrefix);
            params.add(kwLike);
            params.add(kwLike);
        } else {
            sql.append("0 AS relevance, ");
        }

        if (hasZip) {
            sql.append("(CASE WHEN s.location_zip = ? THEN 1 ELSE 0 END) AS zip_match ");
            params.add(zip);
        } else {
            sql.append("0 AS zip_match ");
        }

        sql.append("FROM services s ")
           .append("JOIN providers p ON s.provider_id = p.provider_id ")
           .append("JOIN users u ON p.user_id = u.user_id ")
           .append("JOIN service_categories c ON s.category_id = c.category_id ")
           .append("LEFT JOIN (SELECT provider_id, AVG(rating) AS avg_rating, COUNT(*) AS review_count ")
           .append("FROM reviews GROUP BY provider_id) rs ON s.provider_id = rs.provider_id ")
           .append("WHERE 1=1 ");

        if (hasKeyword) {
            sql.append("AND (s.service_name LIKE ? OR c.category_name LIKE ? OR s.description LIKE ?) ");
            params.add(kwLike);
            params.add(kwLike);
            params.add(kwLike);
        }
        if (categoryId > 0) {
            sql.append("AND c.category_id = ? ");
            params.add(categoryId);
        }
        if (minRating > 0) {
            sql.append("AND COALESCE(rs.avg_rating, 0) >= ? ");
            params.add(minRating);
        }
        if (hasDate) {
            sql.append("AND EXISTS (SELECT 1 FROM availability a WHERE a.provider_id = s.provider_id AND a.available_date = ?) ");
            params.add(date);
        }

        sql.append("ORDER BY relevance DESC, zip_match DESC, avg_rating DESC, p.business_name ASC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    private SearchResult mapRow(ResultSet rs) throws SQLException {
        SearchResult r = new SearchResult();
        r.serviceId = rs.getInt("service_id");
        r.providerId = rs.getInt("provider_id");
        r.serviceName = rs.getString("service_name");
        r.description = rs.getString("description");
        r.price = rs.getBigDecimal("price");
        r.locationZip = rs.getString("location_zip");
        r.businessName = rs.getString("business_name");
        r.providerEmail = rs.getString("email");
        r.categoryId = rs.getInt("category_id");
        r.categoryName = rs.getString("category_name");
        r.avgRating = rs.getDouble("avg_rating");
        r.reviewCount = rs.getInt("review_count");
        r.relevance = rs.getInt("relevance");
        r.zipMatch = rs.getInt("zip_match");
        return r;
    }
}
