import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import '../main.dart';
import '../screens/login_auth_screen.dart';

var callbackUrlScheme = 'com.enersishrchecador.app';
final String callbackUrl =
    '$callbackUrlScheme://callback${Platform.isIOS ? "/" : ""}';
var disvoveryURL = '$apiIdp/.well-known/openid-configuration';
var clientSecret = 'F9A18287-2827-47ED-BEB0-BEFCB8A1E860';
var clientId = 'AppChecador';
var scopes = ['openid', 'profile', 'offline_access', 'HrApi.AppHr'];

class ConfigurationIdp extends StatefulWidget {
  const ConfigurationIdp({super.key});

  @override
  State<ConfigurationIdp> createState() => _ConfigurationIdpState();
}

class _ConfigurationIdpState extends State<ConfigurationIdp> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Future<void> logout(BuildContext context) async {
  print('Cerrando sesión');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  final idToken = prefs.getString('idToken');
  if (accessToken != null && idToken != null) {
    print('AccessToken: $accessToken');
    print('idToken: $idToken');
    try {
      await appAuth.endSession(EndSessionRequest(
        idTokenHint: idToken,
        postLogoutRedirectUrl: callbackUrl,
        discoveryUrl: disvoveryURL,
      ));
      print('Sesión cerrada');
      print('AccessToken: $accessToken');
      print('idToken: $idToken');
      Navigator.pushReplacementNamed(context, '/loginAuth');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  } else {
    print('No se encontró AccessToken o idToken');
  }
}

Future<void> refreshToken() async {
  print('Refrescando token');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refreshToken');
  if (refreshToken != null) {
    print('RefreshToken: $refreshToken');
    try {
      final TokenResponse? result = await appAuth.token(TokenRequest(
        clientId,
        callbackUrl,
        refreshToken: refreshToken,
        discoveryUrl: disvoveryURL,
        clientSecret: clientSecret,
      ));
      if (result != null) {
        print('Token refrescado');
        print('Token ${result}');
        await _storeTokenResponse(result);
      } else {
        print('Error al refrescar el token: respuesta nula');
      }
    } catch (e) {
      print('Error al refrescar el token: $e');
    }
  } else {
    print('No se encontró refreshToken');
  }
}

Future<void> _storeTokenResponse(TokenResponse response) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', response.accessToken!);
  await prefs.setString('idToken', response.idToken!);
  if (response.refreshToken != null) {
    await prefs.setString('refreshToken', response.refreshToken!);
  }
}
