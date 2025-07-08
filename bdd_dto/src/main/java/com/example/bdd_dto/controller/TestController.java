package com.example.bdd_dto.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/seguros")
public class TestController {

    @GetMapping("/test")
    public String testConnection() {
        return "Backend conectado correctamente";
    }
}