package com.dgmf.service;

import io.jsonwebtoken.Claims;
import org.springframework.security.core.userdetails.UserDetails;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

public interface JwtService {
    String getToken(UserDetails savedUser);
    String getToken(Map<String, Object> extraClaims, UserDetails savedUser);
    Key getKey();
    // 4 Retrieval of "username/email" (JWT subject)
    String getUsernameFromToken(String token);

    boolean isTokenValid(String token, UserDetails userDetails);
    Claims getAllClaims(String token);
    <T> T getClaim(String token, Function<Claims, T> claimsResolver);
    Date getExpiration(String token);
    boolean isTokenExpired(String token);
}
