package com.example.impuestos.service;

import org.springframework.stereotype.Service;

@Service
public class ServiciosImpuestos {
    private static final double IVA = 0.15;
    private static final double DESCUENTO = 0.05;

    public double[] calcularIVA(double monto) {
        if (monto > 1200) {
            monto = monto - (monto * DESCUENTO);
        }
        double iva = monto * IVA;
        double total = monto + iva;
        return new double[]{iva, total};
    }
}