package com.example.bdd_dto.controller;

import com.example.bdd_dto.dto.AutomovilDTO;
import com.example.bdd_dto.dto.PropietarioDTO;
import com.example.bdd_dto.dto.SeguroDTO;
import com.example.bdd_dto.service.AutomovilService;
import com.example.bdd_dto.service.PropietarioService;
import com.example.bdd_dto.service.SeguroService;
import com.example.bdd_dto.service.ExportService; // Importar ExportService

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.itextpdf.text.DocumentException; // Para manejar excepciones de iText

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/seguros")
@CrossOrigin(origins = "*") // Permite solicitudes desde cualquier origen (ajusta en producción si es necesario)
public class SeguroController {

    private final SeguroService seguroService;
    private final AutomovilService automovilService;
    private final PropietarioService propietarioService;
    private final ExportService exportService; // Inyectar ExportService

    // Constructor para inyección de dependencias
    public SeguroController(SeguroService seguroService, AutomovilService automovilService,
                            PropietarioService propietarioService, ExportService exportService) { // Añadir ExportService al constructor
        this.seguroService = seguroService;
        this.automovilService = automovilService;
        this.propietarioService = propietarioService;
        this.exportService = exportService; // Inicializar ExportService
    }

    // Endpoint para CREAR/GUARDAR una póliza (el que usa tu Flutter para "CREAR PÓLIZA")
    @PostMapping
    public ResponseEntity<?> crearSeguro(@RequestBody Map<String, Object> seguroData) {
        try {
            // 1. Extraer datos del Map enviado por Flutter
            String propietarioNombreCompleto = (String) seguroData.get("propietario");
            String modeloAuto = (String) seguroData.get("modeloAuto");
            Double valorSeguroAuto = ((Number) seguroData.get("valorSeguroAuto")).doubleValue();
            String edadPropietarioStr = (String) seguroData.get("edadPropietario");
            Integer accidentes = ((Number) seguroData.get("accidentes")).intValue();

            // 2. Convertir el rango de edad String a un int representativo para el PropietarioDTO
            int edadParaPropietario;
            switch (edadPropietarioStr) {
                case "18-23": edadParaPropietario = 20; break;
                case "23-55": edadParaPropietario = 35; break;
                case "55-80": edadParaPropietario = 65; break;
                case "80+": edadParaPropietario = 85; break;
                default: throw new RuntimeException("Rango de edad no válido: " + edadPropietarioStr);
            }

            // 3. Crear o encontrar el Propietario
            PropietarioDTO propDTO = new PropietarioDTO();
            propDTO.setNombreCompleto(propietarioNombreCompleto);
            propDTO.setEdad(edadParaPropietario);
            PropietarioDTO propietarioGuardado = propietarioService.crear(propDTO); // Usa tu método existente 'crear'

            // 4. Crear el Automóvil (asociado al propietario)
            AutomovilDTO autoDTO = new AutomovilDTO();
            autoDTO.setModelo(modeloAuto);
            autoDTO.setValor(valorSeguroAuto);
            autoDTO.setAccidentes(accidentes);
            autoDTO.setPropietarioId(propietarioGuardado.getId());
            AutomovilDTO automovilGuardado = automovilService.crear(autoDTO); // Usa tu método existente 'crear'

            // 5. OBTENER EL SEGURO RECIÉN CREADO/CALCULADO para DEVOLVERLO
            // El automovilService.crear() debería internamente invocar a seguroService.crearSeguro(automovilId).
            // Por lo tanto, después de crear el automóvil, el seguro ya existe y tiene un costo.
            SeguroDTO seguroCalculado = seguroService.obtenerPorAutomovilId(automovilGuardado.getId());

            return ResponseEntity.ok(seguroCalculado);

        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "Error interno del servidor", "detalle", e.getMessage()));
        }
    }

    // Endpoint para LISTAR TODAS LAS PÓLIZAS (el que usa tu Flutter para la tabla)
    @GetMapping
    public ResponseEntity<List<SeguroDTO>> obtenerTodosLosSeguros() {
        List<SeguroDTO> seguros = seguroService.obtenerTodosLosSeguros();
        return ResponseEntity.ok(seguros);
    }

    // Endpoint para ELIMINAR una póliza por ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarSeguro(@PathVariable Long id) {
        seguroService.eliminarSeguroPorId(id);
        return ResponseEntity.noContent().build(); // 204 No Content
    }

    // --- NUEVOS ENDPOINTS PARA EXPORTACIÓN ---

    /**
     * Endpoint para exportar todas las pólizas a un archivo Excel.
     * Devuelve el archivo Excel como un array de bytes.
     */
    @GetMapping("/export/excel")
    public ResponseEntity<byte[]> exportSegurosToExcel() throws IOException {
        List<SeguroDTO> seguros = seguroService.obtenerTodosLosSeguros(); // Obtén todos los datos del SeguroService
        ByteArrayOutputStream excelStream = exportService.exportSegurosToExcel(seguros);

        HttpHeaders headers = new HttpHeaders();
        // Tipo de contenido estándar para archivos .xlsx
        headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
        // Indica al navegador que el archivo debe ser descargado con el nombre "polizas.xlsx"
        headers.set(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"polizas.xlsx\"");
        headers.setContentLength(excelStream.size()); // Tamaño del archivo en bytes

        return new ResponseEntity<>(excelStream.toByteArray(), headers, HttpStatus.OK);
    }

    /**
     * Endpoint para exportar todas las pólizas a un archivo PDF.
     * Devuelve el archivo PDF como un array de bytes.
     */
    @GetMapping("/export/pdf")
    public ResponseEntity<byte[]> exportSegurosToPdf() throws DocumentException, IOException {
        List<SeguroDTO> seguros = seguroService.obtenerTodosLosSeguros(); // Obtén todos los datos del SeguroService
        ByteArrayOutputStream pdfStream = exportService.exportSegurosToPdf(seguros);

        HttpHeaders headers = new HttpHeaders();
        // Tipo de contenido estándar para archivos PDF
        headers.setContentType(MediaType.APPLICATION_PDF);
        // Indica al navegador que el archivo debe ser descargado con el nombre "polizas.pdf"
        headers.set(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"polizas.pdf\"");
        headers.setContentLength(pdfStream.size()); // Tamaño del archivo en bytes

        return new ResponseEntity<>(pdfStream.toByteArray(), headers, HttpStatus.OK);
    }
}