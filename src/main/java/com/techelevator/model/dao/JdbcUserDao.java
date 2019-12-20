package com.techelevator.model.dao;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.techelevator.authentication.PasswordHasher;
import com.techelevator.model.User;
import com.techelevator.model.UserProfileImg;

import org.bouncycastle.util.encoders.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

@Component
public class JdbcUserDao implements UserDao {

    private JdbcTemplate jdbcTemplate;
    private PasswordHasher passwordHasher;

    @Autowired
    public JdbcUserDao(DataSource dataSource, PasswordHasher passwordHasher) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.passwordHasher = passwordHasher;
    }

    @Override
    public User saveUser(String userName, String email, String password, String role) {
        byte[] salt = passwordHasher.generateRandomSalt();
        String hashedPassword = passwordHasher.computeHash(password, salt);
        String saltString = new String(Base64.encode(salt));
        long newUserId = jdbcTemplate.queryForObject(
                "INSERT INTO users(username, email, password, salt, role) VALUES (?, ?, ?, ?, ?) RETURNING user_id",
                Long.class, userName, email, hashedPassword, saltString, role);

        User newUser = new User();
        newUser.setUserId(newUserId);
        newUser.setUsername(userName);
        newUser.setEmail(email);
        newUser.setRole(role);

        return newUser;
    }

    @Override
    public void changePassword(User user, String newPassword) {
        byte[] salt = passwordHasher.generateRandomSalt();
        String hashedPassword = passwordHasher.computeHash(newPassword, salt);
        String saltString = new String(Base64.encode(salt));

        jdbcTemplate.update("UPDATE users SET password=?, salt=? WHERE user_id=?", hashedPassword, saltString,
                user.getUserId());
    }

    @Override
    public User getValidUserWithPassword(String userName, String password) {
        String sqlSearchForUser = "SELECT * FROM users WHERE UPPER(username) = ?";

        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSearchForUser, userName.toUpperCase());
        if (results.next()) {
            String storedSalt = results.getString("salt");
            String storedPassword = results.getString("password");
            String hashedPassword = passwordHasher.computeHash(password, Base64.decode(storedSalt));
            if (storedPassword.equals(hashedPassword)) {
                return mapResultToUser(results);
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<User>();
        String sqlSelectAllUsers = "SELECT user_id, username, email, role FROM users";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectAllUsers);

        while (results.next()) {
            User user = mapResultToUser(results);
            users.add(user);
        }

        return users;
    }

    @Override
    public User getUserByUsername(String username) {
        String sqlSelectUserByUsername = "SELECT user_id, username, email, role FROM users WHERE username = ?";

        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectUserByUsername, username);

        if (results.next()) {
            return mapResultToUser(results);
        } else {
            return null;
        }
    }
    
    @Override
    public UserProfileImg getUserProfileImgByUsernameAndRole(String username, String role) {
        String studentSql = "SELECT s.student_img_url FROM users u INNER JOIN student_user su "
                + "ON u.user_id = su.user_id INNER JOIN student s ON "
                + "s.student_id = su.student_id WHERE u.username = ?";

        String employerSql = "SELECT e.employer_img_url FROM users u INNER JOIN employer_user eu "
                + "ON u.user_id = eu.user_id INNER JOIN employer e ON "
                + "eu.employer_id = e.employer_id WHERE u.username = ?";
        
        UserProfileImg userProfileImg = new UserProfileImg();
        userProfileImg.setUserProfileImgLink("https://via.placeholder.com/150");
        
        if (role.equals("student")) {
            SqlRowSet studentImg = jdbcTemplate.queryForRowSet(studentSql, username);
            if (studentImg.next()) {
                userProfileImg.setUserProfileImgLink(studentImg.getString("student_img_url"));
            }
        }
        
        if (role.equals("employer")) {
            SqlRowSet employerImg = jdbcTemplate.queryForRowSet(employerSql, username);
            
            if (employerImg.next()) {
                userProfileImg.setUserProfileImgLink(employerImg.getString("employer_img_url"));
            }
        }
        
        return userProfileImg;
    }

    private User mapResultToUser(SqlRowSet results) {
        User user = new User();
        user.setUserId(results.getLong("user_id"));
        user.setUsername(results.getString("username"));
        user.setEmail(results.getString("email"));
        user.setRole(results.getString("role"));
        return user;
    }

}
