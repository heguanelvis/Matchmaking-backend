package com.techelevator.model;

public class Employer {

    private long employerId;
    private String employerName;
    private String employerEmail;
    private int tableCount;
    private String daysToAttend;
    private String employerRepresentatives;
    private String employerPositions;
    private String employerImgUrl;
    private String employerDescription;
    private String employerNote;

    public long getEmployerId() {
        return employerId;
    }

    public void setEmployerId(long employerId) {
        this.employerId = employerId;
    }

    public String getEmployerName() {
        return employerName;
    }

    public void setEmployerName(String employerName) {
        this.employerName = employerName;
    }
    
    public String getEmployerEmail() {
        return employerEmail;
    }

    public void setEmployerEmail(String employerEmail) {
        this.employerEmail = employerEmail;
    }


    public int getTableCount() {
        return tableCount;
    }

    public void setTableCount(int tableCount) {
        this.tableCount = tableCount;
    }
    
    public String getDaysToAttend() {
        return daysToAttend;
    }

    public void setDaysToAttend(String daysToAttend) {
        this.daysToAttend = daysToAttend;
    }
    
    public String getEmployerRepresentatives() {
        return employerRepresentatives;
    }

    public void setEmployerRepresentatives(String employerRepresentatives) {
        this.employerRepresentatives = employerRepresentatives;
    }
    
    public String getEmployerPositions() {
        return employerPositions;
    }

    public void setEmployerPositions(String employerPositions) {
        this.employerPositions = employerPositions;
    }

    public String getEmployerImgUrl() {
        return employerImgUrl;
    }

    public void setEmployerImgUrl(String employerImgUrl) {
        this.employerImgUrl = employerImgUrl;
    }

    public String getEmployerDescription() {
        return employerDescription;
    }

    public void setEmployerDescription(String employerDescription) {
        this.employerDescription = employerDescription;
    }

    public String getEmployerNote() {
        return employerNote;
    }

    public void setEmployerNote(String employerNote) {
        this.employerNote = employerNote;
    }

}
