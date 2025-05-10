package com.example.factura.model;

import java.util.List;

public class Factura {

    private List<Producto> productos;
    private double ivaPorcentaje;
    private double total;

    // Getters y setters
    public List<Producto> getProductos() {
        return productos;
    }

    public void setProductos(List<Producto> productos) {
        this.productos = productos;
    }

    public double getIvaPorcentaje() {
        return ivaPorcentaje;
    }

    public void setIvaPorcentaje(double ivaPorcentaje) {
        this.ivaPorcentaje = ivaPorcentaje;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }
}