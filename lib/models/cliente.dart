class NuevaOrdenContacto {
  int? id;
  String nombre;
  String apellidoPaterno;
  String? apellidoMaterno;
  String? nombreCompleto;
  String? email;
  String? fotografia;

  NuevaOrdenContacto({
    this.id,
    required this.nombre,
    required this.apellidoPaterno,
    this.apellidoMaterno,
    this.nombreCompleto,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Nombre': nombre,
      'ApellidoPaterno': apellidoPaterno,
      'ApellidoMaterno': apellidoMaterno,
      'NombreCompleto': nombreCompleto,
      'Email': email,
    };
  }

  factory NuevaOrdenContacto.fromJson(Map<String, dynamic> json) {
    return NuevaOrdenContacto(
      id: json['Id'],
      nombre: json['Nombre'],
      apellidoPaterno: json['ApellidoPaterno'],
      apellidoMaterno: json['ApellidoMaterno'],
      nombreCompleto: json['NombreCompleto'],
      email: json['Email'],
    );
  }
}
