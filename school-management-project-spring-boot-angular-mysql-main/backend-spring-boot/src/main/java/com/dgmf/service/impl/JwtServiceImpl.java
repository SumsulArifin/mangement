package com.dgmf.service.impl;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import com.dgmf.service.JwtService;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

@Service
public class JwtServiceImpl implements JwtService {
    private static final String SECRET_KEY = "586E3272357538782F413F4428472B4B6250655368566B597033733676397924";

    // 4. Retrieval of "Username" (JWT subject)
    // Before implementing this method, we need to implement
    // the process to extract Claims
    @Override
    public String getUsernameFromToken(String token) {
        System.out.println("Stack Trace - JwtServiceImpl - getUsernameFromToken() \nRetrieval of the Username");

        // Subject ==> "username" or "email" in the JWT Token world
        return getClaim(token, Claims::getSubject); // E
    }

    // To generate a JWT Token out of Extracted Claims and UserDetails
    // Map<String, Object> contains the extracted Claims that
    // we want to add
    @Override
    public String getToken(
            Map<String, Object> extraClaims, UserDetails user) { // F
        System.out.println("Stack Trace - JwtServiceImpl - generateToken() \nGeneration of a JWT Token out of Extracted Claims and UserDetails");

        return Jwts
                .builder()
                .setClaims(extraClaims)
                .setSubject(user.getUsername())
                // When the Claim was created, this will help to make calculations
                .setIssuedAt(new Date(System.currentTimeMillis()))
                // The JWT Token will be valid for 24 hours
                .setExpiration(new Date(System.currentTimeMillis()+1000*60*24))
                .signWith(getKey(), SignatureAlgorithm.HS256)
                // Generates and returns the JWT Token
                .compact();
    }

    // To generate a JWT Token without having Extracted
    // Claims, just only using UserDetails itself
    @Override
    public String getToken(UserDetails user) { // G
        System.out.println("Stack Trace - JwtServiceImpl - generateToken() \nGeneration of a JWT Token just only using UserDetails itself");

        // Assigning a Token to the saved User
        return getToken(new HashMap<>(), user);
    }

    // To validate if the JWT Token belongs to the saved User
    @Override
    public boolean isTokenValid(String token, UserDetails userDetails) { // J
        final String username = getUsernameFromToken(token);

        System.out.println("Stack Trace - JwtServiceImpl - isTokenValid()");

        // Returns "true" if the "Username" of the saved User is the same
        // that the one inputted and if the JWT Token is not expired
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }

    @Override
    public boolean isTokenExpired(String token) { // I
        System.out.println("Stack Trace - JwtServiceImpl - isTokenExpired()");

        // Returns "true" if the expiration date has not passed with
        // respect to the current date
        return getExpiration(token).before(new Date());
    }

    @Override
    public Date getExpiration(String token) { // H
        System.out.println("Stack Trace - JwtServiceImpl - getExpiration()");

        // Retrieves Expiration date from the Payload Claims
        return getClaim(token, Claims::getExpiration);
    }

    // 4 Retrieval of "username/email" (JWT subject)
    // Extract all Claims
    @Override
    public Claims getAllClaims(String token) { // B
        System.out.println("Stack Trace - JwtServiceImpl - getAllClaims() \nExtract all Claims");

        return Jwts
                .parserBuilder()
                // The "SigningKey" is the "Secret Key" needed to try
                // to generate or decode a JWT Token
                .setSigningKey(getKey())
                .build()
                .parseClaimsJws(token)
                // Retrieval all the Claims from the Payload
                .getBody();
    }

    @Override
    public Key getKey() { // D
        // Decode the "SECRET_KEY"
        byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);

        System.out.println("Stack Trace - JwtServiceImpl - getSigningKey() \nReturn of the decoded 'SECRET_KEY'");

        // Return of the decoded "SECRET_KEY"
        return Keys.hmacShaKeyFor(keyBytes);
    }

    // 4 Retrieval of "username/email" (JWT subject)
    // Extract a single Claim
    @Override
    public <T> T getClaim(
            String token,
            Function<Claims, T> claimsResolver)
        { // E
        final Claims claims = getAllClaims(token);

        System.out.println("Stack Trace - JwtServiceImpl - getClaim() \nExtract a single Claim");

        // We get the one for the list of all Claims, and return it
        return claimsResolver.apply(claims);
    }
}
