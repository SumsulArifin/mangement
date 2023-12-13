package com.dgmf.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class HomeController {
    @GetMapping("/home")
    public String home() {
        System.out.println("Stack Trace - HomeController - home()");

        return "Welcome from Secure Endpoint";
    }
}
