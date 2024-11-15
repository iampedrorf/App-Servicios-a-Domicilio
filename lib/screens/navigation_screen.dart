import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/servicio.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

class PantallaNavegacion extends StatelessWidget {
  final NuevaOrdenServicio servicio;

  const PantallaNavegacion({super.key, required this.servicio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navegación"),
        backgroundColor: PrimaryColor,
      ),
      body: MapBoxNavigationView(
        options: MapBoxOptions(
          initialLatitude: servicio.latitud,
          initialLongitude: servicio.longitud,
          mode: MapBoxNavigationMode.driving,
          language: "es",
          units: VoiceUnits.metric,
          bearing: 0,
        ),
        onRouteEvent: (e) {},
        onCreated: (MapBoxNavigationViewController controller) async {
          await controller.initialize();
          var wayPoints = <WayPoint>[];
          wayPoints.add(WayPoint(
              name: "Salida",
              latitude: servicio.latitud,
              longitude: servicio.longitud));

          await controller.buildRoute(wayPoints: wayPoints);
          await controller.startNavigation();
        },
      ),
    );
  }
}
