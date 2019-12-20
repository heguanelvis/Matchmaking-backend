package com.techelevator.model;

import java.util.HashMap;
import java.util.Map;

public class EmployerSchedule {

    private Long employerId;
    private String employerName;
    private int tableCount;
    private String daysToAttend;
    private Map<Integer, Student> studentInterviews = new HashMap<>();

    public Long getEmployerId() {
        return employerId;
    }

    public void setEmployerId(Long employerId) {
        this.employerId = employerId;
    }

    public String getEmployerName() {
        return employerName;
    }

    public void setEmployerName(String employerName) {
        this.employerName = employerName;
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

    public Map<Integer, Student> getStudentInterviews() {
        return studentInterviews;
    }

    public void setStudentInterviews(Map<Integer, Student> studentInterviews) {
        this.studentInterviews = studentInterviews;
    }

}
