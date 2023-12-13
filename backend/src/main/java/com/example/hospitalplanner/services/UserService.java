package com.example.hospitalplanner.services;

import com.example.hospitalplanner.jpas.UserJPA;
import com.example.hospitalplanner.repos.UserRepository;
import org.apache.commons.validator.routines.EmailValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
//    public void registerUser(String first_name, String last_name, String email, String phone_number, String user_password) {
//        UserJPA user = new UserJPA();
//
//        user.setFirst_name(first_name);
//        user.setLast_name(last_name);
//        user.setEmail(email);
//        user.setPhone_number(phone_number);
//        user.setUser_password(user_password);
//
//        userRepository.save(user);
//
//        Integer generatedId = user.getUser_id();
//        System.out.println("Generated ID: " + generatedId);
//    }



    public UserJPA registerUser(UserJPA userJPA) {
        UserJPA userJPA1 = new UserJPA();
        userJPA1.setFirst_name(userJPA.getFirst_name());
        userJPA1.setLast_name(userJPA.getLast_name());
        userJPA1.setEmail(userJPA.getEmail());
        userJPA1.setPhone_number(userJPA.getPhone_number());
        userJPA1.setUser_password(userJPA.getUser_password());
        userRepository.save(userJPA1);

       Integer generatedId = userJPA1.getUser_id();
        System.out.println("Generated ID: " + generatedId);

        return userJPA1;
    }

    public boolean  loginUser(String email, String user_password) {
        UserJPA user = userRepository.findByEmail(email);

        if(user != null) {
            return user.getUser_password().equals(user_password);
        }
        return false;
    }

    public void addDoctor(String email) {
        UserJPA user = userRepository.findByEmail(email);
        user.setRole(1);
        userRepository.save(user);
    }

    public void removeDoctor(String email) {
        UserJPA user = userRepository.findByEmail(email);
        user.setRole(0);
        userRepository.save(user);
    }

    public boolean checkEmail(String email) {
        return EmailValidator.getInstance().isValid(email);
    }

    public boolean checkPassword(String user_password) {
        return user_password.length() >= 8;
    }

    public UserJPA getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    public UserJPA getUserById(int user_id) {
        return userRepository.findById(user_id);
    }

    public List<UserJPA> getUsersByRole(int role) {
        return userRepository.findByRole(role);
    }
    public List<UserJPA> getAll() {
        return userRepository.findAll();
    }
}
