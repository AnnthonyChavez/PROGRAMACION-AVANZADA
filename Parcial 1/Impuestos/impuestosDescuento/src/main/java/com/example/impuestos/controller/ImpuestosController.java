package com.example.impuestos.controller;

import com.example.impuestos.service.ServiciosImpuestos;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class ImpuestosController{
    private final ServiciosImpuestos servicio;
    //Constructir con inyeccion de dependencias
    public ImpuestosController(ServiciosImpuestos servicio) {
        this.servicio = servicio;
    }

    @GetMapping("/impuestos")
    public String formulario(Model model){
        model.addAttribute("monto",0.0);
        return "impuestos";
    }

    @PostMapping("/impuestos")
    public String calcular(Model model, double monto) {
        double resultado = servicio.calcularIVA(monto);
        double total = monto + resultado; // Monto + IVA

        model.addAttribute("monto", monto); // Para poder mostrar el mensaje y monto original
        model.addAttribute("resultado", resultado); // IVA calculado
        model.addAttribute("total", total); // Total a pagar

        return "impuestos";
    }
}
