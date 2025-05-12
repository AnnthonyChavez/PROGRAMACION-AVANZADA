package com.example.ExamenPactico1.Controler;

import com.example.ExamenPactico1.Model.Cliente;
import com.example.ExamenPactico1.Service.CalculadoraFinanciera;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/finanzas")
public class BancoController {

    @Autowired
    private CalculadoraFinanciera calculadoraFinanciera;

    @GetMapping
    public String mostrarFormulario(Model model) {
        model.addAttribute("cliente", new Cliente());
        return "formulario";
    }

    @PostMapping("/calcular")
    public String calcular(@ModelAttribute Cliente cliente, Model model) {
        Cliente resultado = calculadoraFinanciera.calcularEstadoFinanciero(cliente);
        model.addAttribute("cliente", resultado);
        return "resultado";
    }
}
