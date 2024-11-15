import 'dart:ui';
import 'package:app_servicios_a_domicilio/providers/counter_notifications.dart';
import 'package:app_servicios_a_domicilio/providers/push_notifications_provider.dart';
import 'package:app_servicios_a_domicilio/repository/configuration_idp.dart';
import 'package:app_servicios_a_domicilio/screens/home_page_screen.dart';
import 'package:app_servicios_a_domicilio/screens/login.dart';
import 'package:app_servicios_a_domicilio/screens/login_auth_screen.dart';
import 'package:app_servicios_a_domicilio/screens/servicios_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

var api = "vacio";
var apiIdp = "https://accounts.enersis10.com"; //idp
Position? ubicacionInicial;
late String user = 'vacio';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void logout(context) async {
  final login = await SharedPreferences.getInstance();
  login.clear();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => const LoginAuthScreen(),
    ),
    (route) => false,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationCounter()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Aquí, aún no tenemos acceso al `context` para navegar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationCounter = NotificationCounter();
      final pushProvider = PushNotificationProvider(notificationCounter);
      pushProvider
          .initNotifications(context); // Ahora tenemos acceso al `context`
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/LogoAnimation.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        // Iniciar la reproducción una vez que el video esté inicializado
        _controller.play();
      });
    });

    // Repetir el video
    _controller.setLooping(false);

    // Espera a que el video se complete antes de navegar
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _checkTokenAndNavigate();
      }
    });
  }

  Future<void> _checkTokenAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedAccessToken = prefs.getString('accessToken');
    final accessTokenExpiration = prefs.getString('accessTokenExpiration');

    // Verifica si el token es válido y redirige en consecuencia
    if (storedAccessToken != null &&
        accessTokenExpiration != null &&
        DateTime.parse(accessTokenExpiration).isAfter(DateTime.now())) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ListaServicios()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginAuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Center(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Si el video está listo, muestra el reproductor de video
                  return Transform.scale(
                    scale:
                        1.5, // Ajusta este valor para cambiar el nivel de zoom
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  // Mientras el video se está inicializando, muestra un indicador de carga
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
