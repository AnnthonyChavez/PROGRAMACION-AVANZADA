package com.example.impuestos.service;

import org.springframework.stereotype.Service;

@Service
public class ServiciosImpuestos {
    private static final double IVA=0.15;
    public double calcularIVA(double monto){
        return monto*IVA;
    }
}