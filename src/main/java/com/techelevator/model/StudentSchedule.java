package com.techelevator.model;

import java.util.HashMap;
import java.util.Map;

public class StudentSchedule {

    private Long studentId;
    private String studentFirstName;
    private String studentLastName;
    private Map<Integer, Employer> employerInterviews = new HashMap<>();

    public Long getStudentId() {
        return studentId;
    }

    public void setStudentId(Long studentId) {
        this.studentId = studentId;
    }

    public String getStudentFirstName() {
        return studentFirstName;
    }

    public void setStudentFirstName(String studentFirstName) {
        this.studentFirstName = studentFirstName;
    }

    public String getStudentLastName() {
        return studentLastName;
    }

    public void setStudentLastName(String studentLastName) {
        this.studentLastName = studentLastName;
    }

    public Map<Integer, Employer> getEmployerInterviews() {
        return employerInterviews;
    }

    public void setEmployerInterviews(Map<Integer, Employer> employerInterviews) {
        this.employerInterviews = employerInterviews;
    }

}
