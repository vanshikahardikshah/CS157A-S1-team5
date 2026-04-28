package com.nearfix.model;

import java.math.BigDecimal;

public class SearchResult {
    private int serviceId;
    private int providerId;
    private String serviceName;
    private String description;
    private BigDecimal price;
    private String locationZip;
    private String categoryName;
    private String businessName;
    private String contactNumber;
    private String providerEmail;
    private java.math.BigDecimal avgRating;
    private int reviewCount;

    public SearchResult() {}

    public java.math.BigDecimal getAvgRating() { return avgRating; }
    public void setAvgRating(java.math.BigDecimal avgRating) { this.avgRating = avgRating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getLocationZip() { return locationZip; }
    public void setLocationZip(String locationZip) { this.locationZip = locationZip; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getProviderEmail() { return providerEmail; }
    public void setProviderEmail(String providerEmail) { this.providerEmail = providerEmail; }
}
