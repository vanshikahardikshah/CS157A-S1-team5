package com.nearfix.model;

import java.sql.Date;
import java.sql.Time;

public class Availability {
    private int availabilityId;
    private int providerId;
    private Date availableDate;
    private Time startTime;
    private Time endTime;

    public Availability() {}

    public int getAvailabilityId() { return availabilityId; }
    public void setAvailabilityId(int availabilityId) { this.availabilityId = availabilityId; }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public Date getAvailableDate() { return availableDate; }
    public void setAvailableDate(Date availableDate) { this.availableDate = availableDate; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }
}
