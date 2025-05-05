package com.example.impuestos.service;

import org.springframework.stereotype.Service;

@Service
public class ServiciosImpuestos {
    private static final double IVA = 0.15;        // Porcentaje de IVA (15%)
    private static final double DESCUENTO = 0.05;  // Porcentaje de descuento (5%)

    // Método principal que calcula el IVA después de aplicar descuento si corresponde
    public double calcularIVA(double monto) {
        // Primero se aplica el descuento si el monto es mayor o igual a 1200
        double montoConDescuento = aplicarDescuento(monto);

        // Luego se calcula el IVA sobre el monto con descuento
        return montoConDescuento * IVA;
    }

    // Método que aplica el descuento del 5% si el monto es igual o mayor a 1200
    private double aplicarDescuento(double monto) {
        if (monto >= 1200) {
            return monto - (monto * DESCUENTO); // Aplica descuento del 5%
        }
        return monto; // Si no aplica el descuento, retorna el monto original
    }
}
