package com.example.ExamenPactico1.Model;

public class Cliente {
    private double saldoAnterior;
    private double compras;
    private double pagos;

    private double saldoActual;
    private double pagoMinimo;
    private double pagoSinInteres;
    private double intereses;
    private double multa;

    public Cliente() {
    }

// Getters y Setters

    public double getSaldoAnterior() {
        return saldoAnterior;
    }

    public void setSaldoAnterior(double saldoAnterior) {
        this.saldoAnterior = saldoAnterior;
    }

    public double getCompras() {
        return compras;
    }

    public void setCompras(double compras) {
        this.compras = compras;
    }

    public double getPagos() {
        return pagos;
    }

    public void setPagos(double pagos) {
        this.pagos = pagos;
    }

    public double getSaldoActual() {
        return saldoActual;
    }

    public void setSaldoActual(double saldoActual) {
        this.saldoActual = saldoActual;
    }

    public double getPagoMinimo() {
        return pagoMinimo;
    }

    public void setPagoMinimo(double pagoMinimo) {
        this.pagoMinimo = pagoMinimo;
    }

    public double getPagoSinInteres() {
        return pagoSinInteres;
    }

    public void setPagoSinInteres(double pagoSinInteres) {
        this.pagoSinInteres = pagoSinInteres;
    }

    public double getIntereses() {
        return intereses;
    }

    public void setIntereses(double intereses) {
        this.intereses = intereses;
    }

    public double getMulta() {
        return multa;
    }

    public void setMulta(double multa) {
        this.multa = multa;
    }
}