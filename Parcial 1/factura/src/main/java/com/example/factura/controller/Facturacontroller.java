package com.example.factura.controller;

import com.example.factura.model.Factura;
import com.example.factura.model.Producto;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
public class Facturacontroller {

    private List<Producto> productos = new ArrayList<>();
    private List<Factura> facturasGeneradas = new ArrayList<>();

    @GetMapping("/factura")
    public String mostrarFormulario(Model model) {
        model.addAttribute("producto", new Producto());
        model.addAttribute("productos", productos);
        return "formularioFactura";
    }

    @PostMapping("/agregarProducto")
    public String agregarProducto(@ModelAttribute Producto producto, Model model) {
        productos.add(producto);
        model.addAttribute("producto", new Producto());
        model.addAttribute("productos", productos);
        return "formularioFactura";
    }

    @PostMapping("/calcularFactura")
    public String calcularFactura(@RequestParam("iva") double ivaPorcentaje, Model model) {
        if (productos.isEmpty()) {
            model.addAttribute("producto", new Producto());
            model.addAttribute("productos", productos);
            model.addAttribute("mensajeError", "Debe agregar al menos un producto.");
            return "formularioFactura";
        }

        double totalFactura = 0;

        for (Producto p : productos) {
            double precioBase = p.getPrecio();
            double precioFinal;

            if (p.isEsConsumoEspecial()) {
                // Aplica solo el 10% de impuesto especial
                precioFinal = precioBase * 1.10;
            } else {
                // Aplica el IVA ingresado por el usuario
                precioFinal = precioBase * (1 + ivaPorcentaje / 100.0);
            }

            totalFactura += precioFinal;
        }

        // Crear y guardar la factura
        Factura factura = new Factura();
        factura.setProductos(new ArrayList<>(productos));  // Se guarda una copia
        factura.setIvaPorcentaje(ivaPorcentaje);
        factura.setTotal(totalFactura);

        facturasGeneradas.add(factura);
        productos.clear();  // Limpiar para la siguiente factura

        model.addAttribute("facturas", facturasGeneradas);
        return "resultadoFactura";
    }
}