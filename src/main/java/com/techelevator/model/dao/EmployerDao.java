package com.techelevator.model.dao;

import java.util.List;

import com.techelevator.model.Employer;
import com.techelevator.model.EmployerApplications;
import com.techelevator.model.User;

public interface EmployerDao {

    public Employer saveEmployer(Employer employer, User user);

    public Employer getEmployerByUserName(String userName);

    public List<Employer> getAllEmployers();

    public Employer getEmployerByEmployerId(Long employeeId);
    
    public List<Long> getAllEmployerIds();
    
}
