// lib/models/poliza_model.dart
class Poliza {
  final String propietario;
  final double valorSeguroAuto;
  final String modeloAuto;
  final String edadPropietario; // CAMBIAR de int a String
  final int accidentes;
  // final double costoTotal; // Este campo no es necesario para el request, el backend lo calcula

  Poliza({
    required this.propietario,
    required this.valorSeguroAuto,
    required this.modeloAuto,
    required this.edadPropietario, // CAMBIAR
    required this.accidentes,
    // this.costoTotal = 0, // No es necesario en el constructor para el request
  });

  Map<String, dynamic> toJson() => {
    "propietario": propietario,
    "valorSeguroAuto": valorSeguroAuto,
    "modeloAuto": modeloAuto,
    "edadPropietario": edadPropietario, // CAMBIAR
    "accidentes": accidentes,
    // "costoTotal": costoTotal, // No enviar al backend, el backend lo calcula
  };

  // El factory constructor fromJson puede que ya no sea necesario para el ViewModel de creación
  // ya que la respuesta es un SeguroDto. Sin embargo, si lo usas en otro lugar, mantenlo.
  factory Poliza.fromJson(Map<String, dynamic> json) {
    return Poliza(
      propietario: json["propietario"],
      valorSeguroAuto: json["valorSeguroAuto"].toDouble(),
      modeloAuto: json["modeloAuto"],
      edadPropietario: json["edadPropietario"] as String, // CAMBIAR
      accidentes: json["accidentes"],
      // costoTotal: json["costoTotal"].toDouble(), // Ya no viene aquí
    );
  }
}