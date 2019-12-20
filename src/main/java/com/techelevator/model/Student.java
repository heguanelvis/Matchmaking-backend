package com.techelevator.model;

public class Student {

    private Long studentId;
    private String studentFirstName;
    private String studentLastName;
    private String studentEmail;
    private String studentLinkedinUrl;
    private String studentImgUrl;

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

    public String getStudentEmail() {
        return studentEmail;
    }

    public void setStudentEmail(String studentEmail) {
        this.studentEmail = studentEmail;
    }

    public String getStudentLinkedinUrl() {
        return studentLinkedinUrl;
    }

    public void setStudentLinkedinUrl(String studentLinkedinUrl) {
        this.studentLinkedinUrl = studentLinkedinUrl;
    }

    public String getStudentImgUrl() {
        return studentImgUrl;
    }

    public void setStudentImgUrl(String studentImgUrl) {
        this.studentImgUrl = studentImgUrl;
    }

}
