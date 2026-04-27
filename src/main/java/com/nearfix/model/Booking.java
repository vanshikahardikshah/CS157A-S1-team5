package com.nearfix.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Booking {
    private int bookingId;
    private int customerId;
    private int serviceId;
    private Date bookingDate;
    private String status;
    private BigDecimal totalPrice;
    private String serviceName;
    private String customerName;
    private String providerBusinessName;

    public Booking() {}

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getProviderBusinessName() { return providerBusinessName; }
    public void setProviderBusinessName(String providerBusinessName) { this.providerBusinessName = providerBusinessName; }
}
