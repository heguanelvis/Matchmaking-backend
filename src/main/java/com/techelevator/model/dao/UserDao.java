package com.techelevator.model.dao;

import java.util.List;

import com.techelevator.model.User;
import com.techelevator.model.UserProfileImg;

public interface UserDao {

    public User saveUser(String userName, String email, String password, String role);

    public void changePassword(User user, String newPassword);

    public User getValidUserWithPassword(String userName, String password);

    public List<User> getAllUsers();

    public User getUserByUsername(String username);
    
    public UserProfileImg getUserProfileImgByUsernameAndRole(String username, String role);

}
