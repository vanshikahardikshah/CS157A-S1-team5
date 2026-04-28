package com.nearfix.model;

import java.math.BigDecimal;
import java.sql.Date;

public class BookingDetails {
    private int bookingId;
    private int customerId;
    private int serviceId;
    private int providerId;
    private Date bookingDate;
    private String status;
    private BigDecimal totalPrice;
    private String serviceName;
    private String categoryName;
    private String businessName;
    private String providerContact;
    private String providerEmail;

    public BookingDetails() {}

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getProviderContact() { return providerContact; }
    public void setProviderContact(String providerContact) { this.providerContact = providerContact; }

    public String getProviderEmail() { return providerEmail; }
    public void setProviderEmail(String providerEmail) { this.providerEmail = providerEmail; }
}
