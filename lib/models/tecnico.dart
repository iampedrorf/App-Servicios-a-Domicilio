class ServicioTecnicoModel {
  int id;
  String nombre;
  String nombreCompleto;
  String? empleadoId;
  String? fotografia;
  String centroServicio;

  ServicioTecnicoModel({
    required this.id,
    required this.nombre,
    required this.nombreCompleto,
    this.empleadoId,
    this.fotografia,
    required this.centroServicio,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Nombre': nombre,
      'NombreCompleto': nombreCompleto,
      'EmpleadoId': empleadoId,
      'Fotografia': fotografia,
      'CentroServicio': centroServicio,
    };
  }

  factory ServicioTecnicoModel.fromJson(Map<String, dynamic> json) {
    return ServicioTecnicoModel(
      id: json['Id'],
      nombre: json['Nombre'],
      nombreCompleto: json['NombreCompleto'],
      empleadoId: json['EmpleadoId'],
      fotografia: json['Fotografia'],
      centroServicio: json['CentroServicio'],
    );
  }
}
