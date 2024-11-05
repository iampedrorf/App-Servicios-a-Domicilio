import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:app_servicios_a_domicilio/screens/servicios_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../constants.dart';
import '../main.dart';
import '../repository/configuration_idp.dart';
import '../repository/permisos.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();

class LoginAuthScreen extends StatefulWidget {
  const LoginAuthScreen({Key? key}) : super(key: key);

  @override
  State<LoginAuthScreen> createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  Permisos _permisos = Permisos();
  bool isBusy = false;
  bool isLoggedIn = false;
  String? errorMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _permisos.permisoUbicacionYGuardar();
    _initAction();
  }

  Future<void> _initAction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedRefreshToken = prefs.getString('refreshToken');
    final storedAccessToken = prefs.getString('accessToken');
    final accessTokenExpiration = prefs.getString('accessTokenExpiration');

    if (storedRefreshToken != null && storedAccessToken != null) {
      if (accessTokenExpiration != null &&
          DateTime.parse(accessTokenExpiration).isBefore(DateTime.now())) {
        print('Se está refrescando el token');
        await refreshToken();
      } else {
        setState(() {
          isLoggedIn = true;
        });
      }
    } else {
      setState(() {
        isLoggedIn = false;
        print('No hay tokens');
      });
    }
  }

  Future<void> _storeTokens(AuthorizationTokenResponse result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', result.accessToken!);
    await prefs.setString('idToken', result.idToken!);
    await prefs.setString('refreshToken', result.refreshToken!);
    await prefs.setString('accessTokenExpiration',
        result.accessTokenExpirationDateTime!.toIso8601String());
    print('Tokens guardados en SharedPreferences');
  }

  Future<void> _login(Function stopLoading) async {
    try {
      print('Entramos al login');
      print('Iniciando autorización');
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          callbackUrl,
          additionalParameters: {
            "include_granted_scopes": "true",
            "access_type": "offline"
          },
          discoveryUrl: disvoveryURL,
          scopes: scopes,
          clientSecret: clientSecret,
        ),
      );
      if (result != null) {
        print('Autorización exitosa');
        print('refreshtoken: ${result.refreshToken}');
        print('AccessToken: ${result.accessToken}');
        print('idToken: ${result.idToken}');
        print('HoraVencimiento: ${result.accessTokenExpirationDateTime}');
        await _storeTokens(result);
        setState(() {
          isLoggedIn = true;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ListaServicios(),
          ),
        );
      } else {
        print('No se recibió token');
      }
    } catch (e) {
      print('Error durante la autorización: $e');
      setState(() {
        errorMessage = e.toString();
        isBusy = false;
        isLoggedIn = false;
      });
    } finally {
      stopLoading();
    }
  }

  Future<void> _validate(Function stopLoading) async {
    if (!isLoading) {
      print('isLoading es falso');
      isLoading = true;
      if (await _checkInternetConnection()) {
        await _login(stopLoading);
      } else {
        isLoading = false;
        _showNoInternetBottomSheet();
        stopLoading();
      }
    } else {
      print('isLoading es true');
      setState(() {
        isLoading = false;
        stopLoading();
      });
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final connection = await InternetAddress.lookup('google.com');
      return connection.isNotEmpty && connection[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void _showNoInternetBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/nowifi.jpeg',
                  height: 40,
                  width: 40,
                ),
                const SizedBox(height: 8),
                const Text(
                  '¡Sin conexión a Internet!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: PrimaryColor,
                  ),
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> _parseIdToken(String idToken) {
    final parts = idToken.split('.');
    assert(parts.length == 3);
    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double defaultLoginSize = size.height - (size.height * 0.2);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: 100,
            right: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: PrimaryColor),
            ),
          ),
          Positioned(
            top: -50,
            right: 280,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: PrimaryColor),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: size.width,
              height: defaultLoginSize,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 200),
                    Image.asset(
                      'assets/logo.png',
                      height: 180,
                      width: 180,
                    ),
                    SizedBox(height: 20),
                    Text(
                      '¡Bienvenido de nuevo!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 15),
                    LoadingBtn(
                      height: 60,
                      borderRadius: 30,
                      animate: true,
                      color: PrimaryColor,
                      width: size.width * 0.8,
                      loader: Container(
                        padding: const EdgeInsets.all(10),
                        width: 40,
                        height: 40,
                        child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: (startLoading, stopLoading, btnState) async {
                        if (btnState == ButtonState.idle) {
                          print('Botón de iniciar sesión presionado');
                          startLoading();
                          await _validate(stopLoading);
                          print('Autenticación completada');
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'v 1.0.2',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
