package com.example.bdd_dto.service;

import com.example.bdd_dto.dto.SeguroDTO;
import com.example.bdd_dto.model.Automovil;
import com.example.bdd_dto.model.Propietario;
import com.example.bdd_dto.model.Seguro;
import com.example.bdd_dto.repository.AutomovilRepository;
import com.example.bdd_dto.repository.SeguroRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // Importar para @Transactional

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SeguroService {

    private final SeguroRepository seguroRepository;
    private final AutomovilRepository automovilRepository;

    public SeguroService(SeguroRepository seguroRepository,
                         AutomovilRepository automovilRepository) {
        this.seguroRepository = seguroRepository;
        this.automovilRepository = automovilRepository;
    }

    public SeguroDTO crearSeguro(Long automovilId) {
        Automovil automovil = automovilRepository.findById(automovilId)
                .orElseThrow(() -> new RuntimeException("Automóvil no encontrado"));

        double costoTotal = calcularCostoSeguro(automovil); // <-- ¡Aquí se calcula!

        Seguro seguro = new Seguro();
        seguro.setAutomovil(automovil);
        seguro.setCostoTotal(costoTotal); // <-- ¡Aquí se asigna el costo calculado!

        Seguro guardado = seguroRepository.save(seguro); // <-- ¡Aquí se guarda el seguro con el costo!
        return convertirADTO(guardado); // <-- ¡Aquí se convierte a DTO, debe contener el costo!
    }

    public SeguroDTO obtenerPorAutomovilId(Long automovilId) {
        Seguro seguro = seguroRepository.findByAutomovilId(automovilId)
                .orElseThrow(() -> new RuntimeException("Seguro no encontrado para el automóvil con ID: " + automovilId));
        return convertirADTO(seguro);
    }

    public SeguroDTO recalcular(Long automovilId) {
        Automovil automovil = automovilRepository.findById(automovilId)
                .orElseThrow(() -> new RuntimeException("Automóvil no encontrado"));

        double nuevoCosto = calcularCostoSeguro(automovil);

        Seguro seguro = seguroRepository.findByAutomovilId(automovilId)
                .orElse(new Seguro()); // Si no existe seguro, crea uno nuevo para ese auto

        seguro.setAutomovil(automovil);
        seguro.setCostoTotal(nuevoCosto);

        Seguro actualizado = seguroRepository.save(seguro);
        return convertirADTO(actualizado);
    }

    @Transactional // Añadir @Transactional para asegurar la operación de borrado
    public void eliminarPorAutomovilId(Long automovilId) {
        seguroRepository.deleteByAutomovilId(automovilId);
    }

    public void eliminarSeguroPorId(Long id) {
        if (!seguroRepository.existsById(id)) {
            throw new RuntimeException("Seguro no encontrado con ID: " + id);
        }
        seguroRepository.deleteById(id);
    }

    public List<SeguroDTO> obtenerTodosLosSeguros() {
        return seguroRepository.findAll().stream()
                .map(this::convertirADTO)
                .collect(Collectors.toList());
    }

    public Seguro guardar(Seguro seguro) {
        return seguroRepository.save(seguro);
    }

    public double calcularCostoSeguro(Automovil automovil) {
        if (automovil.getPropietario() == null) {
            throw new RuntimeException("El automóvil debe tener un propietario asociado para calcular el seguro.");
        }
        if (automovil.getPropietario().getEdad() < 18) {
            throw new RuntimeException("No se puede asegurar a menores de 18 años");
        }

        double cargoValor = automovil.getValor() * 0.035;

        double cargoModelo;
        switch (automovil.getModelo().toUpperCase()) {
            case "A":
                cargoModelo = automovil.getValor() * 0.011;
                break;
            case "B":
                cargoModelo = automovil.getValor() * 0.012;
                break;
            case "C":
                cargoModelo = automovil.getValor() * 0.015;
                break;
            default:
                throw new RuntimeException("Modelo no válido. Debe ser A, B o C");
        }

        int cargoEdad;
        int edad = automovil.getPropietario().getEdad();
        if (edad >= 18 && edad < 24) {
            cargoEdad = 360;
        } else if (edad >= 24 && edad < 53) {
            cargoEdad = 240;
        } else if (edad >= 53 && edad < 80) {
            cargoEdad = 430;
        } else {
            throw new RuntimeException("Edad no válida para seguro");
        }

        double cargoAccidentes;
        int accidentes = automovil.getAccidentes();
        if (accidentes <= 3) {
            cargoAccidentes = accidentes * 17;
        } else {
            cargoAccidentes = (3 * 17) + ((accidentes - 3) * 21);
        }

        return cargoValor + cargoModelo + cargoEdad + cargoAccidentes;
    }

    // --- Métodos de búsqueda adicionales para el trabajo universitario ---
    public List<SeguroDTO> buscarPorModeloAutomovil(String modelo) {
        return seguroRepository.findByAutomovilModeloContainingIgnoreCase(modelo).stream()
                .map(this::convertirADTO)
                .collect(Collectors.toList());
    }

    public List<SeguroDTO> buscarPorNombrePropietario(String nombrePropietario) {
        return seguroRepository.findByPropietarioNombreContainingIgnoreCase(nombrePropietario).stream()
                .map(this::convertirADTO)
                .collect(Collectors.toList());
    }

    // --- Método de conversión de entidad a DTO (ACTUALIZADO) ---
    public SeguroDTO convertirADTO(Seguro seguro) {
        SeguroDTO dto = new SeguroDTO();
        dto.setId(seguro.getId());
        dto.setCostoTotal(seguro.getCostoTotal());

        // Rellenar la información del Automóvil y Propietario
        if (seguro.getAutomovil() != null) {
            dto.setAutomovilId(seguro.getAutomovil().getId());
            dto.setModeloAutomovil(seguro.getAutomovil().getModelo());
            dto.setAccidentesAutomovil(seguro.getAutomovil().getAccidentes());

            if (seguro.getAutomovil().getPropietario() != null) {
                dto.setNombrePropietario(seguro.getAutomovil().getPropietario().getNombre());
                dto.setApellidoPropietario(seguro.getAutomovil().getPropietario().getApellido());
                dto.setEdadPropietario(seguro.getAutomovil().getPropietario().getEdad());
            }
        }
        return dto;
    }
}