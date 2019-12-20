package com.techelevator.controller;

import com.techelevator.authentication.AuthProvider;
import com.techelevator.authentication.UnauthorizedException;
import com.techelevator.model.Employer;
import com.techelevator.model.EmployerApplications;
import com.techelevator.model.EmployerSchedule;
import com.techelevator.model.RankingDisplay;
import com.techelevator.model.RankingSubmit;
import com.techelevator.model.Student;
import com.techelevator.model.StudentSchedule;
import com.techelevator.model.UserProfileImg;
import com.techelevator.model.dao.EmployerDao;
import com.techelevator.model.dao.RankingDao;
import com.techelevator.model.dao.ScheduleDao;
import com.techelevator.model.dao.StudentDao;
import com.techelevator.model.dao.UserDao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin
@RequestMapping("/api")
public class ApiController {

    @Autowired
    private AuthProvider authProvider;

    @Autowired
    private UserDao userdao;

    @Autowired
    private StudentDao studentdao;

    @Autowired
    private EmployerDao employerdao;

    @Autowired
    private RankingDao rankingdao;

    @Autowired
    private ScheduleDao scheduledao;

    @GetMapping("/employers")
    public List<Employer> getAllEmployersEndpoint() throws UnauthorizedException {
        if (!authProvider.isLoggedIn()) {
            throw new UnauthorizedException();
        }

        return employerdao.getAllEmployers();
    }

    @GetMapping("/visitemployers/{employerId}")
    public Employer getEmployerByEmployeeIdEndpoint(@PathVariable Long employerId) throws UnauthorizedException {
        if (!authProvider.isLoggedIn()) {
            throw new UnauthorizedException();
        }

        return employerdao.getEmployerByEmployerId(employerId);
    }

    @GetMapping("/employers/{userName}")
    public Employer getEmployerByUserNameEndpoint(@PathVariable String userName) throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "employer" })) {
            throw new UnauthorizedException();
        }

        return employerdao.getEmployerByUserName(userName);
    }

    @GetMapping("/employer/schedule")
    public EmployerSchedule getEmployerScheduleByUserNameEndpoint() throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "employer" })) {
            throw new UnauthorizedException();
        }

        return scheduledao.getEmployerScheduleByUserName(authProvider.getCurrentUser().getUsername());
    }

    @GetMapping("/allschedules")
    public List<EmployerSchedule> getAllEmployerSchedulesEndpoint() throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "admin" })) {
            throw new UnauthorizedException();
        }

        return scheduledao.getAllEmployerSchedules();
    }

    @GetMapping("/student/schedule")
    public StudentSchedule getStudentScheduleByUserNameEndpoint() throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "student" })) {
            throw new UnauthorizedException();
        }

        return scheduledao.getStudentScheduleByUserName(authProvider.getCurrentUser().getUsername());
    }

    @GetMapping("/students")
    public List<Student> getAllStudentsEndpoint() throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "admin" })) {
            throw new UnauthorizedException();
        }

        return studentdao.getAllStudents();
    }

    @GetMapping("/visitstudents/{studentId}")
    public Student getStudentByStudentIdEndpoint(@PathVariable Long studentId) throws UnauthorizedException {
        if (!authProvider.isLoggedIn()) {
            throw new UnauthorizedException();
        }

        return studentdao.getStudentByStudentId(studentId);
    }

    @GetMapping("/students/{userName}")
    public Student getStudentByUserNameEndpoint(@PathVariable String userName) throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "student" })) {
            throw new UnauthorizedException();
        }

        return studentdao.getStudentByUserName(userName);
    }

    @GetMapping("/visitstudentranking/{studentId}")
    public RankingDisplay getRankingByStudentIdEndpoint(@PathVariable Long studentId) throws UnauthorizedException {
        if (!authProvider.isLoggedIn()) {
            throw new UnauthorizedException();
        }

        return rankingdao.getRankingByStudentId(studentId);
    }

    @GetMapping("/studentranking/{userName}")
    public RankingDisplay getRankingByUserNameEndpoint(@PathVariable String userName) throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "student" })) {
            throw new UnauthorizedException();
        }

        return rankingdao.getRankingByUserName(userName);
    }

    @GetMapping("/employerstudent/rankings")
    public List<EmployerApplications> getAllEmployersApplicationsEndPoint() throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "admin" })) {
            throw new UnauthorizedException();
        }

        List<EmployerApplications> allEmployersApplications = new ArrayList<>();
        List<Long> allEmployerIds = employerdao.getAllEmployerIds();
        allEmployerIds.forEach(employerId -> {
            allEmployersApplications.add(rankingdao.getEmployerApplicationsWithRankingByEmployerId(employerId));
        });

        return allEmployersApplications;
    }

    @GetMapping("/userprofileimg")
    public UserProfileImg getUserProfileImgByUsernameAndRoleEndpoint() throws UnauthorizedException {
        if (!authProvider.isLoggedIn()) {
            throw new UnauthorizedException();
        }

        String role = authProvider.getCurrentUser().getRole();
        String userName = authProvider.getCurrentUser().getUsername();

        return userdao.getUserProfileImgByUsernameAndRole(userName, role);
    }

    @PostMapping("/registerstudent")
    public Student registerStudentEndpoint(@RequestBody Student student) throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "student" })) {
            throw new UnauthorizedException();
        }

        Student newStudent = studentdao.saveStudent(student, authProvider.getCurrentUser());
        return newStudent;
    }

    @PostMapping("/registeremployer")
    public Employer registerEmployerEndpoint(@RequestBody Employer employer) throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "employer" })) {
            throw new UnauthorizedException();
        }

        Employer newEmployer = employerdao.saveEmployer(employer, authProvider.getCurrentUser());
        return newEmployer;
    }

    @PostMapping("/saveranking")
    public List<RankingSubmit> saveRankingEndpoint(@RequestBody List<RankingSubmit> rankingSubmitList)
            throws UnauthorizedException {
        if (!authProvider.userHasRole(new String[] { "student" })) {
            throw new UnauthorizedException();
        }

        List<RankingSubmit> rankingSavedList = new ArrayList<>();
        for (RankingSubmit rankingSubmit : rankingSubmitList) {
            Student currentStudent = studentdao.getStudentByUserName(authProvider.getCurrentUser().getUsername());
            rankingSubmit.setStudentId(currentStudent.getStudentId());
            RankingSubmit rankingSaved = rankingdao.saveRanking(rankingSubmit);
            rankingSavedList.add(rankingSaved);
        }

        return rankingSavedList;
    }

}