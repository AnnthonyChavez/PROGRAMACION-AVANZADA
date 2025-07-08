package com.example.bdd_dto.service;

import com.example.bdd_dto.dto.SeguroDTO; // Importa tu SeguroDTO
import org.apache.poi.ss.usermodel.*; // Importaciones generales de POI
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

// Importaciones explícitas para iText
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font; // iText Font
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase; // iText Phrase
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

@Service
public class ExportService {

    /**
     * Exporta una lista de objetos SeguroDTO a un archivo Excel (formato .xlsx).
     *
     * @param seguros Lista de SeguroDTO a exportar.
     * @return ByteArrayOutputStream que contiene los bytes del archivo Excel.
     * @throws IOException Si ocurre un error al escribir el workbook.
     */
    public ByteArrayOutputStream exportSegurosToExcel(List<SeguroDTO> seguros) throws IOException {
        // Crea un nuevo workbook de Excel en formato XLSX
        org.apache.poi.ss.usermodel.Workbook workbook = new XSSFWorkbook(); // Usar el tipo completo
        // Crea una nueva hoja en el workbook
        org.apache.poi.ss.usermodel.Sheet sheet = workbook.createSheet("Pólizas de Seguro");

        // Define las cabeceras de la tabla
        String[] headers = {"ID", "Nombre Propietario", "Apellido Propietario", "Edad Propietario", "Modelo Automóvil", "Accidentes Automóvil", "Costo Total"};
        // Crea la primera fila para las cabeceras
        org.apache.poi.ss.usermodel.Row headerRow = sheet.createRow(0);

        // Estilo para las cabeceras (opcional)
        org.apache.poi.ss.usermodel.CellStyle headerStyle = workbook.createCellStyle(); // Usar el tipo completo
        org.apache.poi.ss.usermodel.Font headerFont = workbook.createFont(); // Usar el tipo completo
        headerFont.setBold(true); // Método correcto para POI Font
        headerStyle.setFont(headerFont); // Método correcto para POI CellStyle

        // Llena las celdas de la cabecera
        for (int i = 0; i < headers.length; i++) {
            org.apache.poi.ss.usermodel.Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle); // Aplica el estilo
        }

        // Llena los datos de las pólizas a partir de la segunda fila
        int rowNum = 1;
        for (SeguroDTO seguro : seguros) {
            org.apache.poi.ss.usermodel.Row row = sheet.createRow(rowNum++);
            // Manejo de valores nulos para objetos (Long, String)
            // Para primitivos (int, double), no se necesita != null, solo se usa el valor directo
            row.createCell(0).setCellValue(seguro.getId() != null ? seguro.getId() : 0L); // ID (Long)
            row.createCell(1).setCellValue(seguro.getNombrePropietario() != null ? seguro.getNombrePropietario() : "N/A"); // Nombre (String)
            row.createCell(2).setCellValue(seguro.getApellidoPropietario() != null ? seguro.getApellidoPropietario() : "N/A"); // Apellido (String)
            row.createCell(3).setCellValue(seguro.getEdadPropietario()); // Edad (int) - no puede ser null
            row.createCell(4).setCellValue(seguro.getModeloAutomovil() != null ? seguro.getModeloAutomovil() : "N/A"); // Modelo (String)
            row.createCell(5).setCellValue(seguro.getAccidentesAutomovil()); // Accidentes (int) - no puede ser null
            row.createCell(6).setCellValue(seguro.getCostoTotal()); // Costo Total (double) - no puede ser null
        }

        // Autoajusta el ancho de las columnas para que el contenido sea visible
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        // Escribe el contenido del workbook a un ByteArrayOutputStream
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        workbook.write(outputStream);
        workbook.close(); // Cierra el workbook para liberar recursos
        return outputStream;
    }

    /**
     * Exporta una lista de objetos SeguroDTO a un archivo PDF.
     *
     * @param seguros Lista de SeguroDTO a exportar.
     * @return ByteArrayOutputStream que contiene los bytes del archivo PDF.
     * @throws DocumentException Si ocurre un error al crear el documento PDF.
     * @throws IOException Si ocurre un error de E/S.
     */
    public ByteArrayOutputStream exportSegurosToPdf(List<SeguroDTO> seguros) throws DocumentException, IOException {
        // Crea un nuevo documento PDF con tamaño de página A4 en orientación horizontal
        Document document = new Document(PageSize.A4.rotate());
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        // Asocia el escritor PDF al documento y al stream de salida
        PdfWriter.getInstance(document, outputStream);

        document.open(); // Abre el documento para empezar a añadir contenido

        // Define la fuente y el estilo para el título
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, BaseColor.BLACK);
        Paragraph title = new Paragraph("Lista de Pólizas de Seguro", titleFont);
        title.setAlignment(Element.ALIGN_CENTER); // Centra el título
        document.add(title); // Añade el título al documento
        document.add(Chunk.NEWLINE); // Añade un salto de línea

        // Crea una tabla PDF con 7 columnas
        PdfPTable table = new PdfPTable(7);
        table.setWidthPercentage(100); // La tabla ocupa el 100% del ancho de la página
        table.setSpacingBefore(10f); // Espacio antes de la tabla
        table.setSpacingAfter(10f); // Espacio después de la tabla

        // Define los anchos relativos de las columnas para una mejor distribución
        float[] columnWidths = {0.8f, 2f, 2f, 1f, 1.5f, 1.5f, 1.5f};
        table.setWidths(columnWidths);

        // Define las cabeceras de la tabla PDF
        String[] headers = {"ID", "Nombre", "Apellido", "Edad", "Modelo", "Accidentes", "Costo"};
        // Estilo para las cabeceras de la tabla
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.WHITE);
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(BaseColor.DARK_GRAY); // Color de fondo para la celda
            cell.setHorizontalAlignment(Element.ALIGN_CENTER); // Alineación horizontal
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // Alineación vertical
            cell.setPadding(5); // Relleno de la celda
            table.addCell(cell); // Añade la celda a la tabla
        }

        // Llena los datos de la tabla PDF
        Font dataFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.BLACK);
        for (SeguroDTO seguro : seguros) {
            // Manejo de valores nulos para objetos (Long, String) y conversión a String para cada celda
            // Para primitivos (int, double), no se necesita != null, solo se usa el valor directo
            table.addCell(new Phrase(seguro.getId() != null ? seguro.getId().toString() : "N/A", dataFont));
            table.addCell(new Phrase(seguro.getNombrePropietario() != null ? seguro.getNombrePropietario() : "N/A", dataFont));
            table.addCell(new Phrase(seguro.getApellidoPropietario() != null ? seguro.getApellidoPropietario() : "N/A", dataFont));
            table.addCell(new Phrase(String.valueOf(seguro.getEdadPropietario()), dataFont)); // Edad (int)
            table.addCell(new Phrase(seguro.getModeloAutomovil() != null ? seguro.getModeloAutomovil() : "N/A", dataFont));
            table.addCell(new Phrase(String.valueOf(seguro.getAccidentesAutomovil()), dataFont)); // Accidentes (int)
            // Formatea el costo total a dos decimales
            table.addCell(new Phrase(String.format("%.2f", seguro.getCostoTotal()), dataFont)); // Costo Total (double)
        }

        document.add(table); // Añade la tabla al documento
        document.close(); // Cierra el documento para finalizar la escritura
        return outputStream;
    }
}