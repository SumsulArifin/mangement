package com.example.hospitalplanner.repos;

import com.example.hospitalplanner.jpas.UserJPA;
import org.apache.catalina.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserJPA, Integer> {
    UserJPA findByEmail(String email);
    UserJPA findById(int user_id);
    List<UserJPA> findByRole(int role);
}
