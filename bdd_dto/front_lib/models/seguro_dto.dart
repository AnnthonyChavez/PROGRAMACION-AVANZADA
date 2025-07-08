// lib/models/seguro_dto.dart
class SeguroDto {
  final int? id; // ID puede ser null si es un nuevo objeto antes de guardar
  final String? nombrePropietario; // <--- ¿Es String? aquí?
  final String? apellidoPropietario; // <--- ¿Es String? aquí?
  final int? edadPropietario; // <--- ¿Es int? aquí?
  final String? modeloAutomovil; // <--- ¿Es String? aquí?
  final int? accidentesAutomovil; // <--- ¿Es int? aquí?
  final double costoTotal; // Este no debería ser null si el cálculo funciona

  SeguroDto({
    this.id,
    this.nombrePropietario,
    this.apellidoPropietario,
    this.edadPropietario,
    this.modeloAutomovil,
    this.accidentesAutomovil,
    required this.costoTotal, // Asegúrate de que costoTotal sea required y no null
  });

  factory SeguroDto.fromJson(Map<String, dynamic> json) {
    return SeguroDto(
      id: json['id'],
      nombrePropietario: json['nombrePropietario'],
      apellidoPropietario: json['apellidoPropietario'],
      // Asegúrate de castear correctamente los números
      edadPropietario: json['edadPropietario'],
      modeloAutomovil: json['modeloAutomovil'],
      accidentesAutomovil: json['accidentesAutomovil'],
      costoTotal: (json['costoTotal'] as num?)?.toDouble() ?? 0.0, // Maneja null para costoTotal por si acaso
    );
  }
}