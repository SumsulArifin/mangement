package com.example.hospitalplanner.jpas;

import jakarta.persistence.*;
@Entity
@Table(name = "consultation", uniqueConstraints = {
        @UniqueConstraint(columnNames = "consultation_id"),

})
public class ConsultationJPA {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "consultation_id")
    private int consultationId;
    @Column(name = "user_id")
    private int userId;
    @Column(name = "doctor_id")
    private int doctorId;
    private String consultation_date;
    private String status = "Pending";

    public int getConsultationId() {
        return consultationId;
    }

    public void setConsultationId(int consultationId) {
        this.consultationId = consultationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public String getConsultation_date() {
        return consultation_date;
    }

    public void setConsultation_date(String consultation_date) {
        this.consultation_date = consultation_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
