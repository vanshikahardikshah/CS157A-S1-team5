package com.nearfix.model;

import java.math.BigDecimal;

public class Service {
    private int serviceId;
    private int providerId;
    private int categoryId;
    private String serviceName;
    private String description;
    private BigDecimal price;
    private String locationZip;

    public Service() {}

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getLocationZip() { return locationZip; }
    public void setLocationZip(String locationZip) { this.locationZip = locationZip; }
}
