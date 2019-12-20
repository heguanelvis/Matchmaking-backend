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
import com.techelevator.model.EmployerApplications;
import com.techelevator.model.RankingDisplay;
import com.techelevator.model.RankingSubmit;
import com.techelevator.model.Student;
import com.techelevator.model.StudentApplicant;

@Component
public class JdbcRankingDao implements RankingDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public JdbcRankingDao(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public RankingSubmit saveRanking(RankingSubmit rankingSubmit) {
        String sql = "INSERT INTO ranking (student_id, employer_id, ranking) VALUES (?, ?, ?)";

        jdbcTemplate.update(sql, rankingSubmit.getStudentId(), rankingSubmit.getEmployerId(),
                rankingSubmit.getRanking());

        return rankingSubmit;
    }

    @Override
    public RankingDisplay getRankingByUserName(String userName) {
        String sql = "SELECT s.*, e.*, r.ranking FROM ranking r INNER JOIN student s "
                + "ON r.student_id = s.student_id INNER JOIN employer e "
                + "ON r.employer_id = e.employer_id INNER JOIN student_user su "
                + "ON su.student_id = s.student_id INNER JOIN users u "
                + "ON u.user_id = su.user_id WHERE username = ?";

        RankingDisplay rankingDisplay = new RankingDisplay();
        Map<Integer, Employer> rankedEmployers = new HashMap<>();
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);

        while (results.next()) {
            if (rankingDisplay.getStudent() == null) {
                Student student = mapResultToStudent(results);
                rankingDisplay.setStudent(student);
            }
            rankedEmployers.put(results.getInt("ranking"), mapResultToEmployer(results));
        }

        rankingDisplay.setRankedEmployers(rankedEmployers);

        return rankingDisplay;
    }
    
    @Override
    public RankingDisplay getRankingByStudentId(Long studentId) {
        String sql = "SELECT s.*, e.*, r.ranking FROM ranking r INNER JOIN student s "
                + "ON r.student_id = s.student_id INNER JOIN employer e "
                + "ON r.employer_id = e.employer_id INNER JOIN student_user su "
                + "ON su.student_id = s.student_id INNER JOIN users u "
                + "ON u.user_id = su.user_id WHERE s.student_id = ?";
        
        RankingDisplay rankingDisplay = new RankingDisplay();
        Map<Integer, Employer> rankedEmployers = new HashMap<>();
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, studentId);

        while (results.next()) {
            if (rankingDisplay.getStudent() == null) {
                Student student = mapResultToStudent(results);
                rankingDisplay.setStudent(student);
            }
            
            rankedEmployers.put(results.getInt("ranking"), mapResultToEmployer(results));
        }

        rankingDisplay.setRankedEmployers(rankedEmployers);

        return rankingDisplay;
    }

    @Override
    public EmployerApplications getEmployerApplicationsWithRankingByEmployerId(Long employerId) {
        String sql1 = "SELECT s.*, r.ranking FROM ranking r INNER JOIN student s "
                + "ON r.student_id = s.student_id INNER JOIN employer e "
                + "ON r.employer_id = e.employer_id INNER JOIN student_user su "
                + "ON su.student_id = s.student_id INNER JOIN users u "
                + "ON u.user_id = su.user_id WHERE e.employer_id = ? ORDER BY r.ranking";

        EmployerApplications employerApplications = new EmployerApplications();
        employerApplications.setEmployerId(employerId);
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql1, employerId);
        List<StudentApplicant> studentApplicants = new ArrayList<>();

        String sql2 = "SELECT employer_name FROM employer WHERE employer_id = ?";
        SqlRowSet employerNameResults = jdbcTemplate.queryForRowSet(sql2, employerId);
        if (employerNameResults.next()) {
            employerApplications.setEmployerName(employerNameResults.getString("employer_name"));
        }

        while (results.next()) {
            studentApplicants.add(mapResultToStudentApplicant(results));
        }

        employerApplications.setStudentApplicants(studentApplicants);

        return employerApplications;
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

    private StudentApplicant mapResultToStudentApplicant(SqlRowSet results) {
        StudentApplicant studentApplicant = new StudentApplicant();

        studentApplicant.setStudentId(results.getLong("student_id"));
        studentApplicant.setStudentFirstName(results.getString("student_first_name"));
        studentApplicant.setStudentLastName(results.getString("student_last_name"));
        studentApplicant.setRanking(results.getInt("ranking"));

        return studentApplicant;
    }

}
