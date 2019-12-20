package com.techelevator.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import com.techelevator.model.Employer;
import com.techelevator.model.EmployerSchedule;
import com.techelevator.model.Student;
import com.techelevator.model.StudentSchedule;

@Component
public class JdbcScheduleDao implements ScheduleDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public JdbcScheduleDao(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public EmployerSchedule getEmployerScheduleByUserName(String userName) {
        String sql = "SELECT e.employer_id, e.employer_name, e.table_count, e.days_to_attend, "
                + "s.*, sd.appointment_datetime FROM users u INNER JOIN "
                + "employer_user eu ON u.user_id = eu.user_id INNER JOIN "
                + "employer e ON e.employer_id = eu.employer_id INNER JOIN "
                + "schedule sd ON sd.employer_id = e.employer_id INNER JOIN student s "
                + "ON sd.student_id = s.student_id WHERE username = ?";

        EmployerSchedule employerSchedule = new EmployerSchedule();
        Map<Integer, Student> studentInterviews = new HashMap<>();
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);

        while (results.next()) {
            if (employerSchedule.getEmployerName() == null) {
                employerSchedule.setEmployerId(results.getLong("employer_id"));
                employerSchedule.setEmployerName(results.getString("employer_name"));
                employerSchedule.setTableCount(results.getInt("table_count"));
                employerSchedule.setDaysToAttend(results.getString("days_to_attend"));
            }

            studentInterviews.put(results.getInt("appointment_datetime"), mapResultToStudent(results));
        }

        employerSchedule.setStudentInterviews(studentInterviews);

        return employerSchedule;
    }

    @Override
    public List<EmployerSchedule> getAllEmployerSchedules() {
        String sql1 = "SELECT e.employer_id, e.employer_name, e.table_count, e.days_to_attend, \r\n"
                + "s.*, sd.appointment_datetime FROM employer e INNER JOIN\r\n"
                + "schedule sd ON sd.employer_id = e.employer_id INNER JOIN student s \r\n"
                + "ON sd.student_id = s.student_id WHERE e.employer_id = ?";

        String sq12 = "SELECT * FROM employer";
        SqlRowSet employerResults = jdbcTemplate.queryForRowSet(sq12);
        List<EmployerSchedule> allEmployerSchedules = new ArrayList<>();

        while (employerResults.next()) {
            Long employerId = employerResults.getLong("employer_id");
            String employerName = employerResults.getString("employer_name");
            int tableCount = employerResults.getInt("table_count");
            String daysToAttend = employerResults.getString("days_to_attend");

            EmployerSchedule employerSchedule = new EmployerSchedule();
            Map<Integer, Student> studentInterviews = new HashMap<>();
            SqlRowSet results = jdbcTemplate.queryForRowSet(sql1, employerId);

            employerSchedule.setEmployerId(employerId);
            employerSchedule.setEmployerName(employerName);
            employerSchedule.setTableCount(tableCount);
            employerSchedule.setDaysToAttend(daysToAttend);

            while (results.next()) {
                studentInterviews.put(results.getInt("appointment_datetime"), mapResultToStudent(results));
            }

            employerSchedule.setStudentInterviews(studentInterviews);
            allEmployerSchedules.add(employerSchedule);
        }

        return allEmployerSchedules;
    }

    @Override
    public StudentSchedule getStudentScheduleByUserName(String userName) {
        String sql = "SELECT s.student_id, s.student_first_name, s.student_last_name, "
                + "e.*, sd.appointment_datetime FROM users u INNER JOIN "
                + "student_user su ON u.user_id = su.user_id INNER JOIN "
                + "student s ON su.student_id = s.student_id INNER JOIN "
                + "schedule sd ON sd.student_id = s.student_id INNER JOIN employer e "
                + "ON sd.employer_id = e.employer_id WHERE username = ?";
        
        StudentSchedule studentSchedule = new StudentSchedule();
        Map<Integer, Employer> employerInterviews = new HashMap<>();
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);
        
        while(results.next()) {
            if (studentSchedule.getStudentFirstName() == null) {
                studentSchedule.setStudentId(results.getLong("student_id"));
                studentSchedule.setStudentFirstName(results.getString("student_first_name"));
                studentSchedule.setStudentLastName(results.getString("student_last_name"));
            }
            
            employerInterviews.put(results.getInt("appointment_datetime"), mapResultToEmployer(results));
        }
        
        studentSchedule.setEmployerInterviews(employerInterviews);

        return studentSchedule;
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

    private Employer mapResultToEmployer(SqlRowSet results) {
        Employer employer = new Employer();

        employer.setEmployerId(results.getLong("employer_id"));
        employer.setEmployerName(results.getString("employer_name"));
        employer.setEmployerEmail(results.getString("employer_email"));
        employer.setTableCount(results.getInt("table_count"));
        employer.setDaysToAttend(results.getString("days_to_attend"));
        employer.setEmployerRepresentatives(results.getString("employer_representatives"));
        employer.setEmployerPositions(results.getString("employer_positions"));
        employer.setEmployerImgUrl(results.getString("employer_img_url"));
        employer.setEmployerDescription(results.getString("employer_description"));
        employer.setEmployerNote(results.getString("employer_note"));

        return employer;
    }

}
