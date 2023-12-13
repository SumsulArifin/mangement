package com.example.hospitalplanner.services;

import com.example.hospitalplanner.jpas.ConsultationJPA;
import com.example.hospitalplanner.repos.ConsultationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ConsultationService {

    private ConsultationRepository consultationRepository;

    @Autowired
    public ConsultationService(ConsultationRepository consultationRepository) {
        this.consultationRepository = consultationRepository;
    }

    public ConsultationJPA addConsultation(int user_id, int doctor_id, String consultation_date) {
        ConsultationJPA consultation = new ConsultationJPA();

        consultation.setUserId(user_id);
        consultation.setDoctorId(doctor_id);
        consultation.setConsultation_date(consultation_date);

        consultationRepository.save(consultation);

        return consultation;
    }

    public void modifyStatus(int consultation_id, String status) {
        ConsultationJPA consultation = getConsultationById(consultation_id);

        consultation.setStatus(status);

        consultationRepository.save(consultation);
    }

    public List<ConsultationJPA> getConsultationsByDoctorId(int doctor_id) {
        return consultationRepository.findAllByDoctorId(doctor_id);
    }

    public List<ConsultationJPA> getConsultationsByUserId(int user_id) {
        return consultationRepository.findAllByUserId(user_id);
    }

    public ConsultationJPA getConsultationById(int consultation_id) {
        return consultationRepository.findByConsultationId(consultation_id);
    }
}
