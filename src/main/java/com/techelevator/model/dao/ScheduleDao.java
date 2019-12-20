package com.techelevator.model.dao;

import java.util.List;

import com.techelevator.model.EmployerSchedule;
import com.techelevator.model.StudentSchedule;

public interface ScheduleDao {

    public EmployerSchedule getEmployerScheduleByUserName(String userName);

    public List<EmployerSchedule> getAllEmployerSchedules();

    public StudentSchedule getStudentScheduleByUserName(String userName);

}
