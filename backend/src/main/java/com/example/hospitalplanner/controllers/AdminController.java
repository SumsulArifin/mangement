package com.example.hospitalplanner.controllers;

import com.example.hospitalplanner.jpas.UserJPA;
import com.example.hospitalplanner.repos.UserRepository;
import com.example.hospitalplanner.services.UserService;
import org.apache.catalina.User;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin("*")
public class AdminController {
    UserService userService;
    UserRepository userRepository;
    @Autowired
    public AdminController(UserService userService) {

        this.userService = userService;
    }

    @PostMapping("/add-medic")
    public ResponseEntity<?> addMedic( @RequestParam String email ){
        UserJPA user;
        try {
            user = userService.getUserByEmail(email);
        } catch (Exception e) {
            return new ResponseEntity<>("Error!", HttpStatus.BAD_REQUEST);
        }

        userService.addDoctor(email);

        return new ResponseEntity<>("User converted to medic succesfully!", HttpStatus.OK);
    }

    @PostMapping("/remove-medic")
    public ResponseEntity<?> removeMedic( @RequestParam String email ){
        UserJPA user;
        try {
            user = userService.getUserByEmail(email);
        } catch (Exception e) {
            return new ResponseEntity<>("Error!", HttpStatus.BAD_REQUEST);
        }

        userService.removeDoctor(email);

        return new ResponseEntity<>("Medic converted to user succesfully!", HttpStatus.OK);
    }

    @GetMapping("/get-doctor-list")
    public ResponseEntity<?> getConsultationsDoctor() {
        List<UserJPA> doctors;
        try {
            doctors = userService.getUsersByRole(1);
        } catch (Exception e) {
            return new ResponseEntity<>("Doctor list not found!", HttpStatus.BAD_REQUEST);
        }

        JSONObject response = new JSONObject();
        response.put("doctors", doctors);

        return new ResponseEntity<>(response.toMap(), HttpStatus.OK);
    }
}
