import 'package:app_servicios_a_domicilio/models/tecnico.dart';
import 'articulo.dart';
import 'cliente.dart';

class NuevaOrdenServicio {
  int id;
  int contactoId;
  NuevaOrdenContacto contacto;
  int? negociacionId;
  String? fechaProgramacion;
  String calle;
  String numeroExterno;
  String? numeroInterno;
  String colonia;
  String ciudad;
  String estado;
  double latitud;
  double longitud;
  String? tipoServicio;
  String? formaPago;
  double subtotal;
  double descuento;
  double total;
  String? vehiculoMarca;
  String? vehiculoModelo;
  int? vehiculoYear;
  String? cupon;
  ServicioTecnicoModel? tecnico;
  int? centroServicioId;
  int? tecnicoId;
  String codigoEstado;
  DateTime fechaCreacion;
  String? fechaInicio;
  String? fechaArribo;
  String? fechaTermino;
  String? motivoCancelacion;
  bool facturado;
  Articulo articulo;
  DateTime? fechaLimite;

  NuevaOrdenServicio(
      {required this.id,
      required this.contactoId,
      required this.contacto,
      this.negociacionId,
      this.fechaProgramacion,
      required this.calle,
      required this.numeroExterno,
      this.numeroInterno,
      required this.colonia,
      required this.ciudad,
      required this.estado,
      required this.latitud,
      required this.longitud,
      this.tipoServicio,
      this.formaPago,
      required this.subtotal,
      required this.descuento,
      required this.total,
      this.vehiculoMarca,
      this.vehiculoModelo,
      this.vehiculoYear,
      this.cupon,
      this.tecnico,
      this.centroServicioId,
      this.tecnicoId,
      required this.codigoEstado,
      required this.fechaCreacion,
      this.fechaInicio,
      this.fechaArribo,
      this.fechaTermino,
      this.motivoCancelacion,
      required this.facturado,
      required this.articulo,
      required this.fechaLimite});

  Map<String, dynamic> mapForInsert() {
    return {
      'Id': id,
      'ContactoId': contactoId,
      'Contacto': contacto.toMap(),
      'NegociacionId': negociacionId,
      'FechaProgramacion': fechaProgramacion,
      'Calle': calle,
      'NumeroExterno': numeroExterno,
      'NumeroInterno': numeroInterno,
      'Colonia': colonia,
      'Ciudad': ciudad,
      'Estado': estado,
      'Latitud': latitud,
      'Longitud': longitud,
      'TipoServicio': tipoServicio,
      'FormaPago': formaPago,
      'Subtotal': subtotal,
      'Descuento': descuento,
      'Total': total,
      'VehiculoMarca': vehiculoMarca,
      'VehiculoModelo': vehiculoModelo,
      'VehiculoYear': vehiculoYear,
      'Cupon': cupon,
      'Tecnico': tecnico?.toMap(),
      'CentroServicioId': centroServicioId,
      'TecnicoId': tecnicoId,
      'CodigoEstado': codigoEstado,
      'FechaCreacion': fechaCreacion.toIso8601String(),
      'FechaInicio': fechaInicio,
      'FechaArribo': fechaArribo,
      'FechaTermino': fechaTermino,
      'MotivoCancelacion': motivoCancelacion,
      'Facturado': facturado,
      'Articulo': articulo,
      'FechaLimite': fechaLimite
    };
  }

  factory NuevaOrdenServicio.fromJson(Map<String, dynamic> json) {
    return NuevaOrdenServicio(
      id: json['Id'],
      contactoId: json['ContactoId'],
      contacto: NuevaOrdenContacto.fromJson(json['Contacto']),
      negociacionId: json['NegociacionId'],
      fechaProgramacion: json['FechaProgramacion'],
      calle: json['Calle'],
      numeroExterno: json['NumeroExterno'],
      numeroInterno: json['NumeroInterno'],
      colonia: json['Colonia'],
      ciudad: json['Ciudad'],
      estado: json['Estado'],
      latitud: json['Latitud'],
      longitud: json['Longitud'],
      tipoServicio: json['TipoServicio'],
      formaPago: json['FormaPago'],
      subtotal: json['Subtotal'],
      descuento: json['Descuento'],
      total: json['Total'],
      vehiculoMarca: json['VehiculoMarca'],
      vehiculoModelo: json['VehiculoModelo'],
      vehiculoYear: json['VehiculoYear'],
      cupon: json['Cupon'],
      tecnico: json['Tecnico'] != null
          ? ServicioTecnicoModel.fromJson(json['Tecnico'])
          : null,
      centroServicioId: json['CentroServicioId'],
      tecnicoId: json['TecnicoId'],
      codigoEstado: json['CodigoEstado'],
      fechaCreacion: DateTime.parse(json['FechaCreacion']),
      fechaInicio: json['FechaInicio'],
      fechaArribo: json['FechaArribo'],
      fechaTermino: json['FechaTermino'],
      motivoCancelacion: json['MotivoCancelacion'],
      facturado: json['Facturado'],
      articulo: Articulo.fromJson(json['Articulo']),
      fechaLimite: DateTime.parse(json['FechaLimite']),
    );
  }
}

const String ServiciosJson = ''' 
[
  {
    "Id": 1,
    "ContactoId": 201,
    "Contacto": {
      "Id": 1,
      "Nombre": "Carlos",
      "ApellidoPaterno": "González",
      "ApellidoMaterno": "Ramírez",
      "NombreCompleto": "Carlos González Ramírez",
      "Email": "carlos.gonzalez@example.com"
    },
    "NegociacionId": 0,
    "FechaProgramacion": "2024-10-25T10:00:00Z",
    "Calle": "Av. Central",
    "NumeroExterno": "456",
    "NumeroInterno": "12",
    "Colonia": "Naranjos",
    "Ciudad": "León Gto",
    "Estado": "CDMX",
    "Latitud": 21.160149,
    "Longitud": -101.644646,
    "TipoServicio": "Reparación",
    "FormaPago": "Tarjeta",
    "Subtotal": 100.0,
    "Descuento": 5.0,
    "Total": 95.0,
    "VehiculoMarca": "Toyota",
    "VehiculoModelo": "Corolla",
    "VehiculoYear": 2020,
    "Cupon": "ABC123",
    "Tecnico": {
      "Id": 1,
      "Nombre": "Juan Pérez",
      "NombreCompleto": "Juan Pérez López",
      "EmpleadoId": "EMP001",
      "Fotografia": "assets/ArianaTecnica.jpg",
      "CentroServicio": "CS Naranjos"
    },
    "CentroServicioId": 0,
    "TecnicoId": 1,
    "CodigoEstado": "Completado",
    "FechaCreacion": "2024-11-13T09:00:00Z",
    "FechaInicio": "2024-10-01T10:00:00Z",
    "FechaArribo": "2024-10-01T12:00:00Z",
    "FechaTermino": "2024-10-01T14:00:00Z",
    "MotivoCancelacion": "",
    "Facturado": false,
"Articulo": {
  "Id": 1,
  "Nombre": "Producto X",
  "Descripcion": "Descripción del Producto X",
  "Precio": 50.0,
  "Cantidad": 2,
  "FamiliaId": 0,
  "Familia": "Default Familia",
  "MarcaId": 0,
  "PrecioLista": 50.0,
  "PrecioListaUsado": 50.0,
  "PrecioUsado": 50.0,
  "PrecioConDescuento": 45.0,
  "Descuento": 5.0,
  "DescuentoPorcentaje": 10.0,
  "ImagenUrl": "https://chedrauimx.vtexassets.com/arquivos/ids/37127740/7501121601044_02.jpg?v=638640426028530000",
  "GrupoId": 0,
  "Factor": 1.0,
  "Importe": 100.0,
  "Grupo": "Default Grupo",
  "ImagenUsado": "default_image_usado.jpg"
},
    "FechaLimite": "2024-11-01T10:00:00Z"
  },
  {
    "Id": 2,
    "ContactoId": 202,
    "Contacto": {
      "Id": 2,
      "Nombre": "María",
      "ApellidoPaterno": "Hernández",
      "ApellidoMaterno": "López",
      "NombreCompleto": "María Hernández López",
      "Email": "maria.hernandez@example.com"
    },
    "NegociacionId": 0,
    "FechaProgramacion": "2024-09-15T14:00:00Z",
    "Calle": "Calle Falsa",
    "NumeroExterno": "789",
    "NumeroInterno": "A",
    "Colonia": "Jardines",
    "Ciudad": "Guadalajara",
    "Estado": "Jalisco",
    "Latitud": 20.659699,
    "Longitud": -103.349609,
    "TipoServicio": "Instalación",
    "FormaPago": "Efectivo",
    "Subtotal": 200.0,
    "Descuento": 20.0,
    "Total": 180.0,
    "VehiculoMarca": "Nissan",
    "VehiculoModelo": "Versa",
    "VehiculoYear": 2019,
    "Cupon": "XYZ789",
    "Tecnico": {
      "Id": 2,
      "Nombre": "Pedro López",
      "NombreCompleto": "Pedro López González",
      "EmpleadoId": "EMP002",
      "Fotografia": "assets/tecnico2.jpg",
      "CentroServicio": "Centro Guadalajara"
    },
    "CentroServicioId": 0,
    "TecnicoId": 2,
    "CodigoEstado": "En Servicio",
    "FechaCreacion": "2024-11-13T08:00:00Z",
    "FechaInicio": "2024-11-11T09:00:00Z",
    "FechaArribo": "2024-11-11T11:00:00Z",
    "FechaTermino": "2024-11-11T13:00:00Z",
    "MotivoCancelacion": "No se presentó el técnico.",
    "Facturado": false,
"Articulo": {
  "Id": 2,
  "Nombre": "Producto X",
  "Descripcion": "Descripción del Producto X",
  "Precio": 50.0,
  "Cantidad": 2,
  "FamiliaId": 0,
  "Familia": "Default Familia",
  "MarcaId": 0,
  "PrecioLista": 50.0,
  "PrecioListaUsado": 50.0,
  "PrecioUsado": 50.0,
  "PrecioConDescuento": 45.0,
  "Descuento": 5.0,
  "DescuentoPorcentaje": 10.0,
  "ImagenUrl": "https://i5.walmartimages.com.mx/gr/images/product-images/img_large/00750112165705L.jpg",
  "GrupoId": 0,
  "Factor": 1.0,
  "Importe": 100.0,
  "Grupo": "Default Grupo",
  "ImagenUsado": "default_image_usado.jpg"
},
    "FechaLimite": "2024-11-15T15:00:00Z"
  }
]
''';
