class Articulo {
  int id;
  String nombre;
  int familiaId;
  String familia;
  int marcaId;
  double precioLista;
  double precioListaUsado;
  double precioUsado;
  double precioConDescuento;
  double descuento;
  double descuentoPorcentaje;
  String imagenUrl;
  int grupoId;
  double factor;
  double importe;
  String grupo;
  String? imagenUsado;
  int cantidad;

  Articulo({
    required this.id,
    required this.nombre,
    required this.familiaId,
    required this.familia,
    required this.marcaId,
    required this.precioLista,
    required this.precioListaUsado,
    required this.precioUsado,
    required this.precioConDescuento,
    required this.descuento,
    required this.descuentoPorcentaje,
    required this.imagenUrl,
    required this.grupoId,
    required this.factor,
    required this.importe,
    required this.grupo,
    this.imagenUsado,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Nombre': nombre,
      'FamiliaId': familiaId,
      'Familia': familia,
      'MarcaId': marcaId,
      'PrecioLista': precioLista,
      'PrecioListaUsado': precioListaUsado,
      'PrecioUsado': precioUsado,
      'PrecioConDescuento': precioConDescuento,
      'Descuento': descuento,
      'DescuentoPorcentaje': descuentoPorcentaje,
      'ImagenUrl': imagenUrl,
      'GrupoId': grupoId,
      'Factor': factor,
      'Importe': importe,
      'Grupo': grupo,
      'ImagenUsado': imagenUsado,
      'Cantidad': cantidad,
    };
  }

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      id: json['Id'],
      nombre: json['Nombre'],
      familiaId: json['FamiliaId'],
      familia: json['Familia'],
      marcaId: json['MarcaId'],
      precioLista: json['PrecioLista'],
      precioListaUsado: json['PrecioListaUsado'],
      precioUsado: json['PrecioUsado'],
      precioConDescuento: json['PrecioConDescuento'],
      descuento: json['Descuento'],
      descuentoPorcentaje: json['DescuentoPorcentaje'],
      imagenUrl: json['ImagenUrl'],
      grupoId: json['GrupoId'],
      factor: json['Factor'],
      importe: json['Importe'],
      grupo: json['Grupo'],
      imagenUsado: json['ImagenUsado'],
      cantidad: json['Cantidad'],
    );
  }
}
