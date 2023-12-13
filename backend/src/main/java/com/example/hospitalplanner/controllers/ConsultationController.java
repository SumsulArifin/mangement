package com.example.hospitalplanner.controllers;

import com.example.hospitalplanner.jpas.ConsultationJPA;
import com.example.hospitalplanner.jpas.UserJPA;
import com.example.hospitalplanner.services.ConsultationService;
import com.example.hospitalplanner.services.UserService;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/consultation")
@CrossOrigin("*")
public class ConsultationController {
    UserService userService;
    ConsultationService consultationService;

    @Autowired
    public ConsultationController(UserService userService, ConsultationService consultationService) {
        this.userService = userService;
        this.consultationService = consultationService;
    }

    @PostMapping("/create-consultation")
    public ResponseEntity<?> createConsultation(@RequestParam int user_id, @RequestParam String consultationDate, @RequestParam String doctorEmail) {
        UserJPA doctor;
        ConsultationJPA consultation;

        doctor = userService.getUserByEmail(doctorEmail);

        if(doctor.getRole() == 0) {
            return new ResponseEntity<>("User is not doctor!", HttpStatus.BAD_REQUEST);
        }

        if (doctor == null) {
            return new ResponseEntity<>("Doctor not found!", HttpStatus.BAD_REQUEST);
        }

        UserJPA pacient;

        pacient = userService.getUserById(user_id);

        if(pacient == null) {
            return new ResponseEntity<>("User not found!", HttpStatus.BAD_REQUEST);
        }

        consultation = consultationService.addConsultation(user_id, doctor.getUser_id(), consultationDate);

        JSONObject response = new JSONObject();

        response.put("consultation_id", consultation.getConsultationId());
        response.put("user_id", user_id);
        response.put("doctor_id", doctor.getUser_id());
        response.put("consultation_date", consultationDate);
        response.put("status", consultation.getStatus());

        Map<String, Object> responseMap = response.toMap();

        return new ResponseEntity<>(responseMap, HttpStatus.OK);
    }

    @GetMapping("/get-consultations-doctor")
    public ResponseEntity<?> getConsultationsDoctor(@RequestParam int doctor_id) {
        UserJPA doctor;
        try {
            doctor = userService.getUserById(doctor_id);
        } catch (Exception e) {
            return new ResponseEntity<>("Doctor not found!", HttpStatus.BAD_REQUEST);
        }

        List<ConsultationJPA> consultations = consultationService.getConsultationsByDoctorId(doctor.getUser_id());

        JSONObject response = new JSONObject();
        response.put("doctor_id", doctor.getUser_id());
        response.put("consultations", consultations);

        return new ResponseEntity<>(response.toMap(), HttpStatus.OK);
    }

    @GetMapping("/get-consultations-user")
    public ResponseEntity<?> getConsultationsUser(@RequestParam int user_id) {
        UserJPA pacient;
        try {
            pacient = userService.getUserById(user_id);
        } catch (Exception e) {
            return new ResponseEntity<>("User not found!", HttpStatus.BAD_REQUEST);
        }

        List<ConsultationJPA> consultations = consultationService.getConsultationsByUserId(pacient.getUser_id());

        JSONObject response = new JSONObject();
        response.put("user", user_id);
        response.put("consultations", consultations);

        return new ResponseEntity<>(response.toMap(), HttpStatus.OK);
    }

    @PutMapping("/change-status")
    public ResponseEntity<?> changeStatus(@RequestParam int consultation_id, @RequestParam String status) {
        ConsultationJPA consultation = consultationService.getConsultationById(consultation_id);

        if(consultation == null) {
            return new ResponseEntity<>("Consultation not found!", HttpStatus.BAD_REQUEST);
        }

        consultationService.modifyStatus(consultation_id, status);

        return new ResponseEntity<>("Status changed to " + status + " successfully!", HttpStatus.OK);
    }
}
