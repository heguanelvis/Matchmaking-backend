package com.techelevator.model;

import java.util.HashMap;
import java.util.Map;

public class RankingDisplay {

    private Student student = null;
    private Map<Integer, Employer> rankedEmployers = new HashMap<>();

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Map<Integer, Employer> getRankedEmployers() {
        return rankedEmployers;
    }

    public void setRankedEmployers(Map<Integer, Employer> rankedEmployers) {
        this.rankedEmployers = rankedEmployers;
    }

}
