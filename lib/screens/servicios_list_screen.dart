import 'dart:convert';
import 'package:app_servicios_a_domicilio/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Importa la librería intl
import '../models/servicio.dart';
import '../providers/counter_notifications.dart';
import '../widgets/enermax_text.dart';
import 'detalle_mapa_screen.dart';

class ListaServicios extends StatefulWidget {
  const ListaServicios({super.key});

  @override
  State<ListaServicios> createState() => _ListaServiciosState();
}

class _ListaServiciosState extends State<ListaServicios> {
  List<Servicio> servicios = [];
  String filter = 'Activos';

  @override
  void initState() {
    super.initState();
    cargarServicios();
  }

  void cargarServicios() {
    List<dynamic> jsonList = json.decode(ServiciosJson);
    List<Servicio> parsedServicios =
        jsonList.map((json) => Servicio.fromJson(json)).toList();
    setState(() {
      servicios = parsedServicios;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: EnermaxText(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        actions: [
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
                          constraints: BoxConstraints(
                            minWidth: 10,
                            minHeight: 10,
                          ),
                          child: Text(
                            '${counter.count}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                itemBuilder: (context) {
                  List<PopupMenuEntry<int>> items = [];
                  for (var i = 0; i < counter.notifications.length; i++) {
                    var notification = counter.notifications[i];
                    items.add(
                      PopupMenuItem<int>(
                        value: notification['id'],
                        child: ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text(notification['Servicio'] ?? 'Sin título'),
                          subtitle:
                              Text(notification['Cliente'] ?? 'Sin cuerpo'),
                          trailing: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert),
                            onSelected: (String choice) {
                              // Manejar la selección de opciones aquí
                              if (choice == 'Aceptar') {
                                print('Aceptar seleccionado');
                                // Añadir lógica para aceptar
                              } else if (choice == 'Rechazar') {
                                print('Rechazar seleccionado');
                                // Añadir lógica para rechazar
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'Aceptar',
                                  child: Text('Aceptar'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Rechazar',
                                  child: Text('Rechazar'),
                                ),
                              ];
                            },
                          ),
                        ),
                      ),
                    );

                    if (i < counter.notifications.length - 1) {
                      items.add(PopupMenuDivider());
                    }
                  }
                  return items;
                },
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
              decoration: BoxDecoration(
                color: PrimaryColor,
              ),
              child: Text(
                'Servicios a Domicilio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {},
            ),
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
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
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
                        onTap: () {
                          setState(() {
                            filter = 'Activos';
                          });
                        },
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
                        onTap: () {
                          setState(() {
                            filter = 'Historial';
                          });
                        },
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
              itemCount: servicios
                  .where((servicio) => filter == 'Activos'
                      ? servicio.fecha
                          .isAfter(DateTime.now().subtract(Duration(days: 1)))
                      : servicio.fecha.isBefore(DateTime.now()))
                  .length,
              itemBuilder: (context, index) {
                var servicio = servicios
                    .where((servicio) => filter == 'Activos'
                        ? servicio.fecha
                            .isAfter(DateTime.now().subtract(Duration(days: 1)))
                        : servicio.fecha.isBefore(DateTime.now()))
                    .toList()[index];
                return Column(
                  children: [
                    ListTile(
                      leading: Image.asset(
                        servicio.fotografiaacumulador ??
                            'assets/l-24mdc-140.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        servicio.tipoServicio,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(servicio.acumulador),
                          Text(servicio.horario),
                        ],
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            // Asegurarse de que el botón no cause desbordamiento
                            child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetalleMapa(servicio: servicio),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 7.0),
                                textStyle: TextStyle(fontSize: 12),
                                minimumSize: Size(60, 30),
                              ),
                              child: Text(
                                'Ruta',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('yyyy-MM-dd').format(servicio.fecha),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade200,
                      thickness: 1,
                      height: 1,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
