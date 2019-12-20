package com.techelevator.model.dao;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import com.techelevator.model.Employer;
import com.techelevator.model.User;

@Component
public class JdbcEmployerDao implements EmployerDao {
    private JdbcTemplate jdbcTemplate;

    @Autowired
    public JdbcEmployerDao(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public Employer saveEmployer(Employer employer, User user) {
        String sql1 = "INSERT INTO employer (employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING employer_id";
        long newEmployerId = jdbcTemplate.queryForObject(sql1, Long.class, employer.getEmployerName(), user.getEmail(),
                employer.getTableCount(), employer.getDaysToAttend(), employer.getEmployerRepresentatives(),
                employer.getEmployerPositions(), employer.getEmployerImgUrl(), employer.getEmployerDescription(),
                employer.getEmployerNote());

        Long userId = user.getUserId();
        String sql2 = "INSERT INTO employer_user (user_id, employer_id) VALUES (?, ?)";
        jdbcTemplate.update(sql2, userId, newEmployerId);

        employer.setEmployerId(newEmployerId);
        employer.setEmployerEmail(user.getEmail());
        return employer;
    }

    @Override
    public Employer getEmployerByUserName(String userName) {
        String sql = "SELECT e.* FROM employer e INNER JOIN "
                + "employer_user eu ON e.employer_id = eu.employer_id INNER JOIN "
                + "users u ON u.user_id = eu.user_id WHERE u.username = ?";

        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);

        if (results.next()) {
            return mapResultToEmployer(results);
        } else {
            return null;
        }
    }

    @Override
    public List<Employer> getAllEmployers() {
        String sql = "SELECT * FROM employer";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql);
        List<Employer> allEmployers = new ArrayList<>();

        while (results.next()) {
            allEmployers.add(mapResultToEmployer(results));
        }

        return allEmployers;
    }

    @Override
    public Employer getEmployerByEmployerId(Long employeeId) {
        String sql = "SELECT * FROM employer WHERE employer_id = ?";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, employeeId);

        if (results.next()) {
            return mapResultToEmployer(results);
        } else {
            return null;
        }
    }

    @Override
    public List<Long> getAllEmployerIds() {
        String sql = "SELECT employer_id FROM employer";
        List<Long> allEmployerIds = new ArrayList<>();
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql);

        while (results.next()) {
            allEmployerIds.add(results.getLong("employer_id"));
        }

        return allEmployerIds;
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
