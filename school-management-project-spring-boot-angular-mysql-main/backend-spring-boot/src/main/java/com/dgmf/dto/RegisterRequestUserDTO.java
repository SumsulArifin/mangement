package com.dgmf.dto;

import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class RegisterRequestUserDTO {
    private String firstName;
    private String lastName;
    private String username;
    private String email;
    private String password;
}
