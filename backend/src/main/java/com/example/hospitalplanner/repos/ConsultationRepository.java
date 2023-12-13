package com.example.hospitalplanner.repos;

import com.example.hospitalplanner.jpas.ConsultationJPA;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConsultationRepository extends JpaRepository<ConsultationJPA, Integer> {
    List<ConsultationJPA> findAllByDoctorId(int doctor_id);
    List<ConsultationJPA> findAllByUserId(int user_id);
    ConsultationJPA findByConsultationId(int consultation_id);
}
