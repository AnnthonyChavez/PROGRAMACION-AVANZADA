package com.example.factura.service;

import com.example.factura.model.Producto;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FacturaServicio {

    public double calcularTotalFactura(List<Producto> productos, int ivaPorcentaje) {
        double total = 0.0;

        for (Producto producto : productos) {
            double precio = producto.getPrecio();
            double descuento = 0.0;

            if (precio > 300) {
                descuento = 0.07;
            } else if (precio > 200) {
                descuento = 0.05;
            }

            double precioConDescuento = precio - (precio * descuento);
            double iva = precioConDescuento * (ivaPorcentaje / 100.0);
            double impuestoConsumoEspecial = 0.0;

            if (producto.isEsConsumoEspecial()) {
                impuestoConsumoEspecial = precio * 0.10;
            }

            total += precioConDescuento + iva + impuestoConsumoEspecial;
        }

        return total;
    }
}