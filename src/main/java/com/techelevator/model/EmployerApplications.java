package com.techelevator.model;

import java.util.ArrayList;
import java.util.List;

public class EmployerApplications {

    private Long employerId;
    private String employerName;
    private List<StudentApplicant> studentApplicants = new ArrayList<>();

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

    public List<StudentApplicant> getStudentApplicants() {
        return studentApplicants;
    }

    public void setStudentApplicants(List<StudentApplicant> studentApplicants) {
        this.studentApplicants = studentApplicants;
    }

}
