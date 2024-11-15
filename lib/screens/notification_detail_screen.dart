import 'dart:math';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:slide_countdown/slide_countdown.dart';

class NotificationDetailScreen extends StatefulWidget {
  final Map<String, dynamic> notificationData;

  NotificationDetailScreen({required this.notificationData});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  late DateTime now;
  late DateTime fechaLimite;

  @override
  void initState() {
    super.initState();
    now = DateTime.now().toUtc().subtract(Duration(hours: 6));
    fechaLimite =
        DateTime.parse(widget.notificationData['FechaLimite']).toUtc();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "Datos recibidos en NotificationDetailScreen: ${widget.notificationData}");

    print("Fecha límite recibida: $fechaLimite");
    print("Fecha actual recibida (UTC): $now");

    // Calcula la duración en minutos entre ahora y la fecha límite
    final duracion = fechaLimite.difference(now);
    final duracionMinutos = duracion.inSeconds;

    print("Duración en minutos: $duracionMinutos");

    // Ajusta la duración si es negativa
    final adjustedDuration = duracionMinutos > 0 ? duracionMinutos : 0;

    print("Duración ajustada en minutos: $adjustedDuration");

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Notificación'),
      ),
      body: DraggableScrollableSheet(
        initialChildSize: 0.69,
        minChildSize: 0.69,
        maxChildSize: 0.69,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: Offset(0, -8),
                ),
              ],
            ),
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          widget.notificationData['Contacto']['ImagenUrl']
                                      ?.isNotEmpty ??
                                  false
                              ? widget.notificationData['Contacto']['ImagenUrl']
                              : 'assets/perfil.jpg',
                        ),
                        radius: 32,
                        backgroundColor: Colors.grey[300],
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.notificationData['Contacto']['Nombre'] ??
                                'No disponible',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          Text(
                            widget.notificationData['Contacto']['Email'] ?? '',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                          Text(
                            '${widget.notificationData['Contacto']['ApellidoPaterno'] ?? ''} ${widget.notificationData['Contacto']['ApellidoMaterno'] ?? ''}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey[400], thickness: 2),
                  Text(
                    'Servicio: ${widget.notificationData['TipoServicio'] ?? 'No especificado'}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Producto: ${widget.notificationData['Articulo']['Nombre'] ?? 'No especificado'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fecha Programada: ${widget.notificationData['FechaProgramacion'] ?? 'No disponible'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dirección: ${widget.notificationData['Calle']} ${widget.notificationData['NumeroExterno']}, ${widget.notificationData['Colonia']}, ${widget.notificationData['Ciudad']}, ${widget.notificationData['Estado']}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Divider(color: Colors.grey[400], thickness: 2),
                  if (widget.notificationData['VehiculoMarca'] != null)
                    Text(
                      'Vehículo: ${widget.notificationData['VehiculoMarca']} ${widget.notificationData['VehiculoModelo']} (${widget.notificationData['VehiculoYear']})',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.left,
                    ),
                  Divider(color: Colors.grey[400], thickness: 2),
                  Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Text(
                        "Subtotal: \$${widget.notificationData['Subtotal'].toStringAsFixed(2)}",
                        style:
                            TextStyle(fontSize: 16, color: Colors.green[800]),
                      ),
                      Text(
                        "Descuento: \$${widget.notificationData['Descuento'].toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, color: Colors.red[800]),
                      ),
                      Text(
                        "Total: \$${widget.notificationData['Total'].toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: CircularCountDownTimer(
                      duration: adjustedDuration,
                      initialDuration: 0,
                      controller: CountDownController(),
                      width: 80,
                      height: 80,
                      ringColor: Colors.grey[300]!,
                      fillColor: Color(0xFF2196f3),
                      backgroundColor: Color(0xFF003785),
                      strokeWidth: 10.0,
                      strokeCap: StrokeCap.round,
                      textStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textFormat: CountdownTextFormat.MM_SS,
                      isReverse: true,
                      isTimerTextShown: true,
                      onComplete: () {
                        // Acción al completar el temporizador
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Acción para "Aceptar"
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 12)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                        ),
                        child: Text(
                          "Aceptar",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Acción para "Rechazar"
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 12)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                        ),
                        child: Text(
                          "Rechazar",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
