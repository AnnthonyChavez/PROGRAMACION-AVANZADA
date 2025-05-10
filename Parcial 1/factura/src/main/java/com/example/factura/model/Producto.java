package com.example.factura.model;

public class Producto {

    private String nombre;
    private double precio;
    private boolean esConsumoEspecial; // Indica si es producto especial

    // Getters y setters
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public boolean isEsConsumoEspecial() {
        return esConsumoEspecial;
    }

    public void setEsConsumoEspecial(boolean esConsumoEspecial) {
        this.esConsumoEspecial = esConsumoEspecial;
    }
}