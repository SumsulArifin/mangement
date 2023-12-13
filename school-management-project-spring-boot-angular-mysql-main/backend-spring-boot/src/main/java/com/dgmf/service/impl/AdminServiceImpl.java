package com.dgmf.service.impl;

import com.dgmf.entity.User;
import com.dgmf.entity.enums.Role;
import com.dgmf.repository.UserRepository;
import com.dgmf.service.AdminService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;

    @PostConstruct
    @Override
    public void createAdmin() {
        System.out.println("Stack Trace - AdminServiceImpl - " +
                "'Method' createAdmin()");

        Optional<User> admin = userRepository.findByRole(Role.ROLE_ADMIN);
        if(admin.isEmpty()) {
            User newAdmin = User.builder()
                .firstName("John")
                .lastName("Doe")
                .username("johndoe")
                .email("johndoe@gmail.com")
                .password(passwordEncoder.encode("1234"))
                .role(Role.ROLE_ADMIN)
                .build();

            userRepository.save(newAdmin);
        }

    }
}
