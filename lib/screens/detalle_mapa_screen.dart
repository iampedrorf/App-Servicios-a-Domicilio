import 'package:app_servicios_a_domicilio/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

import '../models/servicio.dart';
import '../widgets/enermax_text.dart';

class DetalleMapa extends StatefulWidget {
  final NuevaOrdenServicio servicio;

  const DetalleMapa({super.key, required this.servicio});

  @override
  State<DetalleMapa> createState() => _DetalleMapaState();
}

class _DetalleMapaState extends State<DetalleMapa> {
  MapBoxNavigationViewController? _controller;
  String? _instruction;
  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _arrived = false;
  MapBoxOptions? _navigationOption;
  late double _currentLatitude;
  late double _currentLongitude;
  late NuevaOrdenServicio servicioRecibido;
  bool _loading = true; // Variable to track loading state
  double _dataContainerHeight = 270.0; // Altura inicial del contenedor
  final ImagePicker _picker = ImagePicker();
  bool _isLoadingNavigation = false;

  @override
  void initState() {
    super.initState();
    servicioRecibido = widget.servicio;
    _initialize();
  }

  Future<void> _initialize() async {
    // Obtén la ubicación actual
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _currentLatitude = position.latitude;
    _currentLongitude = position.longitude;

    // Configura las opciones de navegación
    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption!.initialLatitude = servicioRecibido.latitud;
    _navigationOption!.initialLongitude = servicioRecibido.longitud;
    _navigationOption!.mode = MapBoxNavigationMode.driving;
    _navigationOption!.language = "es"; // Cambia el idioma a español
    _navigationOption!.units = VoiceUnits.metric; // Cambia la unidad a metros
    _navigationOption!.bearing = 0; // Apunta hacia el norte

    // Registra el listener de eventos de ruta
    MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);

    setState(() {
      _loading = false; // Update loading state
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: EnermaxText(mainAxisAlignment: MainAxisAlignment.start),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Skeletonizer(
        enabled: _loading,
        child: _navigationOption == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  // Mapa en la parte superior
                  Positioned.fill(
                    child: MapBoxNavigationView(
                      options: _navigationOption!,
                      onRouteEvent: _onRouteEvent,
                      onCreated:
                          (MapBoxNavigationViewController controller) async {
                        _controller = controller;
                        await _controller?.initialize();
                      },
                    ),
                  ),
                  // Modal que se puede deslizar
                  DraggableScrollableSheet(
                    initialChildSize: 0.5, // Tamaño inicial
                    minChildSize: 0.1, // Tamaño mínimo
                    maxChildSize: 0.5, // Tamaño máximo
                    builder: (context, scrollController) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16), // Espacio alrededor
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                16), // Radio para la esquina superior izquierda
                            topRight: Radius.circular(
                                16), // Radio para la esquina superior derecha
                          ),
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
                                    backgroundImage: NetworkImage(
                                        "URL_DE_IMAGEN_DEL_CONTACTO"),
                                    radius: 24,
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(servicioRecibido.contacto.nombre,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          servicioRecibido.contacto.email ?? '',
                                          style: TextStyle(fontSize: 14)),
                                      Text(
                                          '${servicioRecibido.contacto.apellidoPaterno} ${servicioRecibido.contacto.apellidoMaterno ?? ''}',
                                          style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              Text(
                                  'Servicio: ${servicioRecibido.tipoServicio ?? 'No especificado'}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  'Producto: ${servicioRecibido.articulo ?? 'No especificado'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                              Text(
                                  'Fecha Programada: ${servicioRecibido.fechaProgramacion ?? 'No disponible'}',
                                  style: TextStyle(fontSize: 16)),
                              Text(
                                  'Dirección: ${servicioRecibido.calle} ${servicioRecibido.numeroExterno}',
                                  style: TextStyle(fontSize: 16)),
                              Text(
                                  'Ciudad: ${servicioRecibido.ciudad}, Estado: ${servicioRecibido.estado}',
                                  style: TextStyle(fontSize: 16)),
                              Divider(),
                              if (servicioRecibido.vehiculoMarca != null)
                                Text(
                                    'Vehículo: ${servicioRecibido.vehiculoMarca} ${servicioRecibido.vehiculoModelo} (${servicioRecibido.vehiculoYear})',
                                    style: TextStyle(fontSize: 16)),
                              Divider(),
                              Wrap(
                                spacing: 10, // Espacio entre textos
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Subtotal: \$${servicioRecibido.subtotal.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Descuento: \$${servicioRecibido.descuento.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Total: \$${servicioRecibido.total.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        _isNavigating ? null : _startNavigation,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.navigation,
                                            color: Colors.black),
                                        SizedBox(width: 8),
                                        Text(_isNavigating
                                            ? "Navegando..."
                                            : "Iniciar Navegación"),
                                      ],
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
                ],
              ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> _tomarFoto() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto != null) {
      // Aquí puedes manejar la foto tomada, como guardarla o mostrarla
      print('Foto tomada: ${foto.path}');
    } else {
      print('No se tomó ninguna foto.');
    }
  }

  Future<void> _onRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        _arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        _routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        _routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        _isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        _arrived = true;
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 10));
          await _controller?.finishNavigation();
          setState(() {
            _dataContainerHeight = 270.0; // Restablecer altura del contenedor
          });
        }
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        _routeBuilt = false;
        _isNavigating = false;
        setState(() {
          _dataContainerHeight = 270.0; // Restablecer altura del contenedor
        });
        break;
      default:
        break;
    }
    setState(() {});
  }

  Future<void> _startNavigation() async {
    var wayPoints = <WayPoint>[];
    wayPoints.add(WayPoint(
        name: "Salida",
        latitude: _currentLatitude,
        longitude: _currentLongitude));
    wayPoints.add(WayPoint(
        name: "Destino",
        latitude: servicioRecibido.latitud,
        longitude: servicioRecibido.longitud));

    await _controller?.buildRoute(wayPoints: wayPoints);
    await _controller?.startNavigation();

    // Reduce la altura del contenedor de datos al iniciar la navegación
    setState(() {
      _dataContainerHeight = 100.0; // Nueva altura del contenedor
    });
  }
}
