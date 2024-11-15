import 'dart:convert';
import 'package:app_servicios_a_domicilio/constants.dart';
import 'package:app_servicios_a_domicilio/screens/perfil_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/servicio.dart';
import '../providers/counter_notifications.dart';
import '../providers/push_notifications_provider.dart';
import '../widgets/enermax_text.dart';
import 'detalle_mapa_screen.dart';
import 'notification_detail_screen.dart';

class ListaServicios extends StatefulWidget {
  const ListaServicios({super.key});

  @override
  State<ListaServicios> createState() => _ListaServiciosState();
}

class _ListaServiciosState extends State<ListaServicios> {
  List<NuevaOrdenServicio> servicios = [];
  String filter = 'Activos';
  List<bool> botonesVisibles = [];
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    cargarServicios();
  }

  void cargarServicios() {
    List<dynamic> jsonList = json.decode(ServiciosJson);
    List<NuevaOrdenServicio> parsedServicios =
        jsonList.map((json) => NuevaOrdenServicio.fromJson(json)).toList();
    setState(() {
      servicios = parsedServicios;
      botonesVisibles = List.generate(servicios.length, (index) => true);
    });
  }

  // Método para ocultar los botones y mostrar "Detalles"
  void aceptarServicio(int index) {
    setState(() {
      botonesVisibles[index] = false;
    });
  }

  // Método para eliminar el servicio de la lista
  void rechazarServicio(int index) {
    setState(() {
      servicios.removeAt(index);
      botonesVisibles.removeAt(index);
    });
  }

  List<NuevaOrdenServicio> filtrarServicios() {
    if (filter == 'Activos') {
      return servicios
          .where((servicio) =>
              servicio.fechaCreacion != null &&
              servicio.fechaCreacion!
                  .isAfter(currentDate.subtract(Duration(days: 1))))
          .toList();
    } else {
      return servicios
          .where((servicio) =>
              servicio.fechaCreacion != null &&
              servicio.fechaCreacion!.isBefore(DateTime(
                  currentDate.year, currentDate.month, currentDate.day)))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviciosFiltrados = filtrarServicios();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: EnermaxText(mainAxisAlignment: MainAxisAlignment.center),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Convierte la fecha límite en formato DateTime
              DateTime fechaLimite = DateTime.parse("2024-11-15T09:30:00Z");
              // Datos personalizados para la notificación
              Map<String, dynamic> notificationData = {
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
                  "ImagenUrl":
                      "https://i5.walmartimages.com.mx/gr/images/product-images/img_large/00750112165705L.jpg",
                  "GrupoId": 0,
                  "Factor": 1.0,
                  "Importe": 100.0,
                  "Grupo": "Default Grupo",
                  "ImagenUsado": "default_image_usado.jpg"
                },
                "FechaLimite": fechaLimite.toIso8601String(),
              };

              // Usa el provider para agregar la notificación
              context
                  .read<NotificationCounter>()
                  .addNotification(notificationData);

              // Navegar a la pantalla de detalles de la notificación usando navigatorKey
              navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (context) => NotificationDetailScreen(
                    notificationData: notificationData,
                  ),
                ),
              );
            },
            child: Text('SN'),
          ),
          SizedBox(width: 0.5),
          Consumer<NotificationCounter>(
            builder: (context, counter, child) {
              return PopupMenuButton<int>(
                color: Colors.grey.shade50,
                icon: Stack(
                  children: [
                    Icon(Icons.notifications, color: Colors.white),
                    if (counter.count > 0)
                      Positioned(
                        right: 3,
                        top: 3,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints:
                              BoxConstraints(minWidth: 10, minHeight: 10),
                          child: Text(
                            '${counter.count}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                itemBuilder: (context) =>
                    counter.notifications.map((notification) {
                  return PopupMenuItem<int>(
                    value: notification['id'],
                    child: ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text(notification['Servicio'] ?? 'Sin título'),
                      subtitle: Text(notification['Cliente'] ?? 'Sin cuerpo'),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert),
                        onSelected: (String choice) {
                          if (choice == 'Aceptar') {
                            print('Aceptar seleccionado');
                          } else if (choice == 'Rechazar') {
                            print('Rechazar seleccionado');
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'Aceptar',
                            child: Text('Aceptar'),
                          ),
                          PopupMenuItem<String>(
                            value: 'Rechazar',
                            child: Text('Rechazar'),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onSelected: (value) {
                  // Manejar la selección del ítem aquí
                },
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: PrimaryColor),
              child: Text(
                'Servicios a Domicilio',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
                leading: Icon(Icons.home), title: Text('Home'), onTap: () {}),
            ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {}),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: PrimaryColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => filter = 'Activos'),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: filter == 'Activos'
                                ? Colors.white
                                : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Activos',
                            style: TextStyle(
                              color: filter == 'Activos'
                                  ? PrimaryColor
                                  : Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => setState(() => filter = 'Historial'),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: filter == 'Historial'
                                ? Colors.white
                                : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Historial',
                            style: TextStyle(
                              color: filter == 'Historial'
                                  ? PrimaryColor
                                  : Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: serviciosFiltrados.length,
              itemBuilder: (context, index) {
                var servicio = serviciosFiltrados[index];
                return Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          // Imagen del producto (puede ser una imagen local o de red)
                          Image.network(
                            servicio.articulo
                                .imagenUrl, // Asumiendo que el servicio tiene la URL de la imagen
                            width: 60,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                              width:
                                  10), // Espaciado entre la imagen y el texto
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  servicio.tipoServicio!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Cliente: ${servicio.contacto.nombre}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Tecnico: ${servicio.tecnico!.nombre}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Articulo: ${servicio.articulo.nombre}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Fecha: ${DateFormat('yyyy-MM-dd').format(servicio.fechaCreacion!)}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                // Cambiar color del estado según el código
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4), // Espaciado interno
                                  decoration: BoxDecoration(
                                    color: _getColorFromEstado(
                                            servicio.codigoEstado!)
                                        .withOpacity(0.2), // Fondo con opacidad
                                    borderRadius: BorderRadius.circular(
                                        12), // Esquinas redondeadas
                                  ),
                                  child: Text(
                                    servicio.codigoEstado!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getColorFromEstado(servicio
                                          .codigoEstado!), // El color del texto depende del estado
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (botonesVisibles[index])
                                ElevatedButton(
                                  onPressed: () => aceptarServicio(index),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 7.0),
                                    textStyle: TextStyle(fontSize: 12),
                                    minimumSize: Size(60, 30),
                                  ),
                                  child: Text('Aceptar',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              if (botonesVisibles[index]) SizedBox(width: 10),
                              if (botonesVisibles[index])
                                ElevatedButton(
                                  onPressed: () => rechazarServicio(index),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 7.0),
                                    textStyle: TextStyle(fontSize: 12),
                                    minimumSize: Size(60, 30),
                                  ),
                                  child: Text('Rechazar',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              if (!botonesVisibles[index])
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetalleMapa(servicio: servicio)),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 7.0),
                                    textStyle: TextStyle(fontSize: 12),
                                    minimumSize: Size(60, 30),
                                  ),
                                  child: Text('Detalles',
                                      style: TextStyle(color: Colors.black)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                        color: Colors.grey.shade200, thickness: 1, height: 1),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Color _getColorFromEstado(String estado) {
    switch (estado) {
      case 'Programado':
        return Colors.blue;
      case 'Pendiente':
        return Colors.grey;
      case 'En Servicio':
        return Colors.yellow;
      case 'Completado':
        return Colors.green;
      case 'Rechazado':
        return Colors.red;
      default:
        return Colors.black; // Color por defecto si no se encuentra el estado
    }
  }
}
