package com.dgmf.service;

import com.dgmf.dto.LoginRequestUserDTO;
import com.dgmf.dto.RegisterRequestUserDTO;
import com.dgmf.controller.auth.AuthResponse;
import com.dgmf.entity.Token;
import com.dgmf.entity.User;

public interface AuthService {
    AuthResponse register(RegisterRequestUserDTO registerRequest);
    AuthResponse login(LoginRequestUserDTO loginRequest);
    Token savedUserToken(User savedUser, String jwtTokenSavedUser);
    // Revokes all existing Tokens for a specific User
    void revokeAllUserTokens(User user);
}
