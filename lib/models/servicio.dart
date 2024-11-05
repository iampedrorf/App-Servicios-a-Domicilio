import 'package:app_servicios_a_domicilio/models/tecnico.dart';

class Servicio {
  int id;
  int clienteId;
  String cliente;
  int estado;
  int sucursalId;
  String sucursal;
  DateTime fecha;
  String horario;
  String tipoServicio;
  String telefono;
  String domicilio;
  ServicioTecnicoModel tecnico;
  String? vehiculo;
  String acumulador;
  String? fotografiaacumulador;
  String marca;
  String linea;
  String modelo;
  double precio;
  double descuento;
  bool requiereTerminal;
  bool urgente;
  String canalCaptacion;
  String observacion;
  String creadoPor;
  double longitud;
  double latitud;
  DateTime fechaExpiracion; // Nuevo atributo
  String estatus; // Nuevo atributo (Activo, Rechazado, EnProceso, Terminado)

  Servicio({
    required this.id,
    required this.clienteId,
    required this.cliente,
    required this.estado,
    required this.sucursalId,
    required this.sucursal,
    required this.fecha,
    required this.horario,
    required this.tipoServicio,
    required this.telefono,
    required this.domicilio,
    required this.tecnico,
    this.vehiculo,
    required this.acumulador,
    this.fotografiaacumulador,
    required this.marca,
    required this.linea,
    required this.modelo,
    required this.precio,
    required this.descuento,
    required this.requiereTerminal,
    required this.urgente,
    required this.canalCaptacion,
    required this.observacion,
    required this.creadoPor,
    required this.latitud,
    required this.longitud,
    required this.fechaExpiracion, // Inicialización del nuevo atributo
    required this.estatus, // Inicialización del nuevo atributo
  });

  // Map for insert
  Map<String, dynamic> mapForInsert() {
    return {
      'Id': id,
      'ClienteId': clienteId,
      'Cliente': cliente,
      'Estado': estado,
      'SucursalId': sucursalId,
      'Sucursal': sucursal,
      'Fecha': fecha.toIso8601String(),
      'Horario': horario,
      'TipoServicio': tipoServicio,
      'Telefono': telefono,
      'Domicilio': domicilio,
      'Tecnico': tecnico.toMap(),
      'Vehiculo': vehiculo,
      'Acumulador': acumulador,
      'FotografiaAcumulador': fotografiaacumulador,
      'Marca': marca,
      'Linea': linea,
      'Modelo': modelo,
      'Precio': precio,
      'Descuento': descuento,
      'RequiereTerminal': requiereTerminal,
      'Urgente': urgente,
      'CanalCaptacion': canalCaptacion,
      'Observacion': observacion,
      'CreadoPor': creadoPor,
      'Latitud': latitud,
      'Longitud': longitud,
      //'FechaExpiracion': fechaExpiracion.toIso8601String(),
      'FechaExpiracion': fechaExpiracion,
      'Estatus': estatus, // Agregado
    };
  }

  // Map for update
  Map<String, dynamic> mapForUpdate() {
    return mapForInsert(); // Same as insert for simplicity
  }

  // Crear una instancia from JSON
  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['Id'],
      clienteId: json['ClienteId'],
      cliente: json['Cliente'],
      estado: json['Estado'],
      sucursalId: json['SucursalId'],
      sucursal: json['Sucursal'],
      fecha: DateTime.parse(json['Fecha']),
      horario: json['Horario'],
      tipoServicio: json['TipoServicio'],
      telefono: json['Telefono'],
      domicilio: json['Domicilio'],
      tecnico: ServicioTecnicoModel.fromJson(json['Tecnico']),
      vehiculo: json['Vehiculo'],
      acumulador: json['Acumulador'],
      fotografiaacumulador: json['FotografiaAcumulador'],
      marca: json['Marca'],
      linea: json['Linea'],
      modelo: json['Modelo'],
      precio: json['Precio'],
      descuento: json['Descuento'],
      requiereTerminal: json['RequiereTerminal'],
      urgente: json['Urgente'],
      canalCaptacion: json['CanalCaptacion'],
      observacion: json['Observacion'],
      creadoPor: json['CreadoPor'],
      latitud: json['Latitud'],
      longitud: json['Longitud'],
      fechaExpiracion: DateTime.parse(json['FechaExpiracion']), // Agregado
      estatus: json['Estatus'], // Agregado
    );
  }
}

const String ServiciosJson = ''' 
[
  {
    "Id": 1,
    "ClienteId": 101,
    "Cliente": "Empresa ABC",
    "Estado": 1,
    "SucursalId": 5,
    "Sucursal": "Sucursal Norte",
    "Fecha": "2024-08-01T10:00:00Z",
    "Horario": "10:00 - 12:00",
    "TipoServicio": "Mantenimiento",
    "Telefono": "+524776145764",
    "Domicilio": "Av. Principal 123",
    "Tecnico": {
      "Id": 1,
      "NombreCompleto": "Juan Pérez",
      "Fotografia": "assets/ArianaTecnica.jpg"
    },
    "Vehiculo": "Camión de Servicio",
    "Acumulador": "L-U1-340",
    "FotografiaAcumulador": "assets/L-U1-340PODADORA.png",
    "Marca": "LTH",
    "Linea": "Línea X",
    "Modelo": "Modelo 2024",
    "Precio": 150.0,
    "Descuento": 10.0,
    "RequiereTerminal": true,
    "Urgente": false,
    "CanalCaptacion": "Email",
    "Observacion": "Servicio regular.",
    "CreadoPor": "admin",
    "Latitud": 21.147900, 
    "Longitud": -101.704175,
    "FechaExpiracion": "2024-11-01T10:00:00Z", 
    "Estatus": "Activo" 
  },
  {
    "Id": 2,
    "ClienteId": 102,
    "Cliente": "Empresa XYZ",
    "Estado": 2,
    "SucursalId": 6,
    "Sucursal": "Sucursal Este",
    "Fecha": "2024-08-02T14:00:00Z",
    "Horario": "14:00 - 16:00",
    "TipoServicio": "Reparación",
    "Telefono": "+524776145764",
    "Domicilio": "Calle Secundaria 456",
    "Tecnico": {
      "Id": 2,
      "NombreCompleto": "Ana Martínez",
      "Fotografia": "assets/ArianaTecnica.jpg"
    },
    "Vehiculo": "Van de Servicio",
    "Acumulador": "H-24-600",
    "FotografiaAcumulador": "assets/H-24-600.png",
    "Marca": "HI-TEC",
    "Linea": "Línea Y",
    "Modelo": "Modelo 2023",
    "Precio": 200.0,
    "Descuento": 20.0,
    "RequiereTerminal": false,
    "Urgente": true,
    "CanalCaptacion": "Teléfono",
    "Observacion": "Reparación urgente.",
    "CreadoPor": "admin",
    "Latitud": 21.147900, 
    "Longitud": -101.704175,
    "FechaExpiracion": "2024-11-02T14:00:00Z", 
    "Estatus": "En Proceso" 
  },
  {
    "Id": 3,
    "ClienteId": 103,
    "Cliente": "Cliente DEF",
    "Estado": 3,
    "SucursalId": 7,
    "Sucursal": "Sucursal Sur",
    "Fecha": "2024-08-12T09:00:00Z",
    "Horario": "09:00 - 11:00",
    "TipoServicio": "Instalación",
    "Telefono": "+524776145764",
    "Domicilio": "Avenida 789",
    "Tecnico": {
      "Id": 3,
      "NombreCompleto": "Carlos Gómez",
      "Fotografia": "assets/ArianaTecnica.jpg"
    },
    "Vehiculo": "Furgoneta",
    "Acumulador": "H-27-810",
    "FotografiaAcumulador": "assets/H-27-810.png",
    "Marca": "HI-TEC",
    "Linea": "Línea Z",
    "Modelo": "Modelo 2022",
    "Precio": 300.0,
    "Descuento": 15.0,
    "RequiereTerminal": true,
    "Urgente": false,
    "CanalCaptacion": "Visita",
    "Observacion": "Instalación de nuevo sistema.",
    "CreadoPor": "admin",
    "Latitud": 21.147900, 
    "Longitud": -101.704175,
    "FechaExpiracion": "2024-11-12T09:00:00Z", 
    "Estatus": "Terminado" 
  },
  {
    "Id": 4,
    "ClienteId": 104,
    "Cliente": "Cliente GHI",
    "Estado": 1,
    "SucursalId": 8,
    "Sucursal": "Sucursal Oeste",
    "Fecha": "2024-09-27T11:00:00Z",
    "Horario": "11:00 - 13:00",
    "TipoServicio": "Mantenimiento",
    "Telefono": "+524776145764",
    "Domicilio": "Calle Principal 321",
    "Tecnico": {
      "Id": 4,
      "NombreCompleto": "Laura Fernández",
      "Fotografia": "assets/ArianaTecnica.jpg"
    },
    "Vehiculo": "Camión de Servicio",
    "Acumulador": "L-24F-710",
    "FotografiaAcumulador": "assets/L-24F-710AGM.png",
    "Marca": "AGM",
    "Linea": "Línea A",
    "Modelo": "Modelo 2021",
    "Precio": 180.0,
    "Descuento": 5.0,
    "RequiereTerminal": false,
    "Urgente": false,
    "CanalCaptacion": "Redes Sociales",
    "Observacion": "Mantenimiento preventivo.",
    "CreadoPor": "admin",
    "Latitud": 20.955290, 
    "Longitud": -101.433157,
    "FechaExpiracion": "2024-11-27T11:00:00Z", 
    "Estatus": "Activo" 
  },
  {
    "Id": 5,
    "ClienteId": 105,
    "Cliente": "Cliente JKL",
    "Estado": 2,
    "SucursalId": 9,
    "Sucursal": "Sucursal Centro",
    "Fecha": "2024-09-26T13:00:00Z",
    "Horario": "13:00 - 15:00",
    "TipoServicio": "Reparación",
    "Telefono": "+524776145764",
    "Domicilio": "Boulevard 654",
    "Tecnico": {
      "Id": 5,
      "NombreCompleto": "Pedro Rodríguez",
      "Fotografia": "assets/ArianaTecnica.jpg"
    },
    "Vehiculo": "Van de Servicio",
    "Acumulador": "LTX-22F-600",
    "FotografiaAcumulador": "assets/LTX-22F-600TAXI.png",
    "Marca": "AGM",
    "Linea": "Línea B",
    "Modelo": "Modelo 2020",
    "Precio": 250.0,
    "Descuento": 10.0,
    "RequiereTerminal": true,
    "Urgente": true,
    "CanalCaptacion": "Email",
    "Observacion": "Reparación urgente.",
    "CreadoPor": "admin",
    "Latitud": 21.147900, 
    "Longitud": -101.704175,
    "FechaExpiracion": "2024-10-26T13:00:00Z", 
    "Estatus": "Rechazado" 
  },
  {
    "Id": 6,
    "ClienteId": 103,
    "Cliente": "Cliente DEF",
    "Estado": 3,
    "SucursalId": 7,
    "Sucursal": "Sucursal Sur",
    "Fecha": "2024-08-12T09:00:00Z",
    "Horario": "09:00 - 11:00",
    "TipoServicio": "Instalación",
    "Telefono": "+524776145764",
    "Domicilio": "Avenida 789",
    "Tecnico": {
      "Id": 6,
      "NombreCompleto": "Carlos Gómez",
      "Fotografia": "assets/ArianaTecnica.jpg"
    },
    "Vehiculo": "Furgoneta",
    "Acumulador": "H-27-810",
    "FotografiaAcumulador": "assets/H-27-810.png",
    "Marca": "HI-TEC",
    "Linea": "Línea Z",
    "Modelo": "Modelo 2022",
    "Precio": 300.0,
    "Descuento": 15.0,
    "RequiereTerminal": true,
    "Urgente": false,
    "CanalCaptacion": "Visita",
    "Observacion": "Instalación de nuevo sistema.",
    "CreadoPor": "admin",
    "Latitud": 21.147900, 
    "Longitud": -101.704175,
    "FechaExpiracion": "2024-11-12T09:00:00Z", 
    "Estatus": "Terminado" 
  },
  {
    "Id": 7,
    "ClienteId": 104,
    "Cliente": "Cliente GHI",
    "Estado": 1,
    "SucursalId": 8,
    "Sucursal": "Sucursal Oeste",
    "Fecha": "2024-11-04T11:00:00Z",
    "Horario": "11:00 - 13:00",
    "TipoServicio": "Mantenimiento",
    "Telefono": "+524776145764",
    "Domicilio": "Calle Principal 321",
    "Tecnico": {
      "Id": 7,
      "NombreCompleto": "Laura Fernández",
      "Fotografia": "assets/ArianaTecnica.jpg"
    },
    "Vehiculo": "Camión de Servicio",
    "Acumulador": "L-24F-710",
    "FotografiaAcumulador": "assets/L-24F-710AGM.png",
    "Marca": "AGM",
    "Linea": "Línea A",
    "Modelo": "Modelo 2021",
    "Precio": 180.0,
    "Descuento": 5.0,
    "RequiereTerminal": false,
    "Urgente": false,
    "CanalCaptacion": "Redes Sociales",
    "Observacion": "Mantenimiento preventivo.",
    "CreadoPor": "admin",
    "Latitud": 20.955290, 
    "Longitud": -101.433157,
    "FechaExpiracion": "2024-12-04T11:00:00Z", 
    "Estatus": "Activo" 
  },
  {
    "Id": 8,
    "ClienteId": 105,
    "Cliente": "Cliente JKL",
    "Estado": 2,
    "SucursalId": 9,
    "Sucursal": "Sucursal Centro",
    "Fecha": "2024-11-26T13:00:00Z",
    "Horario": "13:00 - 15:00",
    "TipoServicio": "Reparación",
    "Telefono": "+524776145764",
    "Domicilio": "Boulevard 654",
    "Tecnico": {
      "Id": 8,
      "NombreCompleto": "Pedro Rodríguez",
      "Fotografia": "assets/ArianaTecnica.jpg"
    },
    "Vehiculo": "Van de Servicio",
    "Acumulador": "LTX-22F-600",
    "FotografiaAcumulador": "assets/LTX-22F-600TAXI.png",
    "Marca": "AGM",
    "Linea": "Línea B",
    "Modelo": "Modelo 2020",
    "Precio": 250.0,
    "Descuento": 10.0,
    "RequiereTerminal": true,
    "Urgente": true,
    "CanalCaptacion": "Email",
    "Observacion": "Reparación urgente.",
    "CreadoPor": "admin",
    "Latitud": 21.147900, 
    "Longitud": -101.704175,
    "FechaExpiracion": "2024-11-04T13:00:00Z", 
    "Estatus": "En Proceso" 
  }
]
''';
//21.15076405228794, -101.69781001390459
//21.152355123273168, -101.71049233840212
//Mi casa: 21.08703570473319, -101.61876213324915
//Nova 21.146956601078177, -101.71005660653645

//21.1470194654821, -101.70953214841474
