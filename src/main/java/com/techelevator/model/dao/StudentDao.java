package com.techelevator.model.dao;

import java.util.List;

import com.techelevator.model.Student;
import com.techelevator.model.User;

public interface StudentDao {
    
    public Student saveStudent(Student student, User user);
    
    public Student getStudentByUserName(String userName);
    
    public List<Student> getAllStudents();
    
    public Student getStudentByStudentId(Long studentId);
    
}
