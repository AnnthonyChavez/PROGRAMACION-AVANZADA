package com.example.bdd_dto.dto;

public class SeguroDTO {
    private Long id;
    private Long automovilId;
    private double costoTotal;

    // Nuevos campos para incluir información del Automóvil y Propietario
    private String modeloAutomovil;
    private int accidentesAutomovil;
    private String nombrePropietario;
    private String apellidoPropietario;
    private int edadPropietario;

    // Constructores
    public SeguroDTO() {}

    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Double getCostoTotal() { return costoTotal; }
    public void setCostoTotal(Double costoTotal) { this.costoTotal = costoTotal; }
    public Long getAutomovilId() { return automovilId; }
    public void setAutomovilId(Long automovilId) { this.automovilId = automovilId; }

    // *Nuevos Getters y Setters para los campos adicionales*
    public String getModeloAutomovil() { return modeloAutomovil; }
    public void setModeloAutomovil(String modeloAutomovil) { this.modeloAutomovil = modeloAutomovil; }
    public int getAccidentesAutomovil() { return accidentesAutomovil; }
    public void setAccidentesAutomovil(int accidentesAutomovil) { this.accidentesAutomovil = accidentesAutomovil; }
    public String getNombrePropietario() { return nombrePropietario; }
    public void setNombrePropietario(String nombrePropietario) { this.nombrePropietario = nombrePropietario; }
    public String getApellidoPropietario() { return apellidoPropietario; }
    public void setApellidoPropietario(String apellidoPropietario) { this.apellidoPropietario = apellidoPropietario; }
    public int getEdadPropietario() { return edadPropietario; }
    public void setEdadPropietario(int edadPropietario) { this.edadPropietario = edadPropietario; }
}