package com.techelevator.model.dao;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import com.techelevator.model.Student;
import com.techelevator.model.User;

@Component
public class JdbcStudentDao implements StudentDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public JdbcStudentDao(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public Student saveStudent(Student student, User user) {
        String sql1 = "INSERT INTO student (student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url) VALUES (?, ?, ?, ?, ?) RETURNING student_id";
        long newStudentId = jdbcTemplate.queryForObject(sql1, Long.class, student.getStudentFirstName(),
                student.getStudentLastName(), user.getEmail(), student.getStudentLinkedinUrl(), student.getStudentImgUrl());

        Long userId = user.getUserId();
        String sql2 = "INSERT INTO student_user (user_id, student_id) VALUES (?, ?)";
        jdbcTemplate.update(sql2, userId, newStudentId);

        student.setStudentId(newStudentId);
        student.setStudentEmail(user.getEmail());
        return student;
    }

    @Override
    public Student getStudentByUserName(String userName) {
        String sql = "SELECT s.* FROM student s INNER JOIN "
                + "student_user su ON s.student_id = su.student_id INNER JOIN "
                + "users u ON su.user_id = u.user_id WHERE u.username = ?";
        
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);

        if (results.next()) {
            return mapResultToStudent(results);
        } else {
            return null;
        }
    }
    
    @Override
    public List<Student> getAllStudents() {
        String sql = "SELECT * FROM student";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql);
        List<Student> allStudents = new ArrayList<>();

        while (results.next()) {
            allStudents.add(mapResultToStudent(results));
        }

        return allStudents;
    }
    
    @Override
    public Student getStudentByStudentId(Long studentId) {
        String sql = "SELECT * FROM student WHERE student_id = ?";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, studentId);
        
        if (results.next()) {
            return mapResultToStudent(results);
        } else {
            return null;
        }
    }
    
    private Student mapResultToStudent(SqlRowSet results) {
        Student student = new Student();

        student.setStudentId(results.getLong("student_id"));
        student.setStudentFirstName(results.getString("student_first_name"));
        student.setStudentLastName(results.getString("student_last_name"));
        student.setStudentEmail(results.getString("student_email"));
        student.setStudentLinkedinUrl(results.getString("student_linkedin_url"));
        student.setStudentImgUrl(results.getString("student_img_url"));

        return student;
    }

}
