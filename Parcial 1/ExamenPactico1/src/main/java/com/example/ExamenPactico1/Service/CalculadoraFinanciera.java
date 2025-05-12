package com.example.ExamenPactico1.Service;

import com.example.ExamenPactico1.Model.Cliente;
import org.springframework.stereotype.Service;

@Service
public class CalculadoraFinanciera {

    public Cliente calcularEstadoFinanciero(Cliente cliente) {
        double saldoAnterior = cliente.getSaldoAnterior();
        double compras = cliente.getCompras();
        double pagos = cliente.getPagos();

        double intereses = 0;
        double multa = 0;

        double pagoMinimoAnterior = saldoAnterior * 0.15;

        if (pagos < pagoMinimoAnterior) {
            intereses = saldoAnterior * 0.12;
            multa = 200;
        }

        double saldoActual = saldoAnterior + compras + intereses + multa - pagos;

        double nuevoPagoMinimo = saldoActual * 0.15;

        double pagoSinInteres = saldoActual * 0.85;

        cliente.setIntereses(intereses);
        cliente.setMulta(multa);
        cliente.setSaldoActual(saldoActual);
        cliente.setPagoMinimo(nuevoPagoMinimo);
        cliente.setPagoSinInteres(pagoSinInteres);

        return cliente;
    }
}