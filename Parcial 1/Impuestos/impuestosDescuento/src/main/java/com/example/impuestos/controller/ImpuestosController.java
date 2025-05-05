package com.example.impuestos.controller;

import com.example.impuestos.service.ServiciosImpuestos;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class ImpuestosController {
    private final ServiciosImpuestos servicio;

    public ImpuestosController(ServiciosImpuestos servicio) {
        this.servicio = servicio;
    }

    @GetMapping("/impuestos")
    public String formulario(Model model) {
        model.addAttribute("monto", 0.0);
        return "impuestos";
    }

    @PostMapping("/impuestos")
    public String calcular(Model model, double monto) {
        double[] resultados = servicio.calcularIVA(monto);
        model.addAttribute("monto", monto);
        model.addAttribute("iva", resultados[0]);
        model.addAttribute("total", resultados[1]);
        return "impuestos";
    }
}