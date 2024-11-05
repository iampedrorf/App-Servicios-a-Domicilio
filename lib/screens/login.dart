import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:loading_btn/loading_btn.dart';

import '../constants.dart';
import '../main.dart';
import '../repository/permisos.dart';
import 'home_page_screen.dart';

late SharedPreferences loginData;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool mostrarCargando = false;
  Permisos _permisos = Permisos();
  bool showPassword = false;

  late bool isNewUser;
  late String password = '';

  bool keyboardVisible = false;
  bool logueado = false;

  @override
  void initState() {
    //api = 'https://enersisuat.azurewebsites.net/api';
    _permisos.permisoUbicacionYGuardar();
    super.initState();
    //checkIfGrupo();
    tryLogUser();
  }

  void setear() {
    print('entra a setear');
    setState(() {});
  }

  void checkTokenExpiration() {
    int? tokenTimeInMillis = loginData.getInt('tokenTime');
    if (tokenTimeInMillis != null) {
      DateTime tokenTime =
          DateTime.fromMillisecondsSinceEpoch(tokenTimeInMillis);
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(tokenTime);

      // Establecer el tiempo de expiración del token (en este caso, 2 minutos)
      const Duration tokenExpiration = Duration(minutes: 2);

      if (difference > tokenExpiration) {
        // El token ha expirado, renovar token
        print('Token expirado, intentando renovar...');
        getToken();
      }
    }
  }

  Future<bool> tryLogUser() async {
    loginData = await SharedPreferences.getInstance();
    if (loginData.getString('username') == null ||
        loginData.getString('password') == null ||
        loginData.getString('token') == null) {
      return false;
    }
    user = loginData.getString('username')!;
    password = loginData.getString('password')!;
    DateTime tokenTime = DateTime.now();
    var uri = Uri.parse("$api/Auth/Authenticate");
    print('en get token que usuario tenemos? $user');
    if (await internet()) {
      try {
        var res = await http.post(
          uri,
          body: {"username": user, "password": password},
        );

        if (res.statusCode == 200) {
          final body = jsonDecode(res.body);
          final token = body['access_token'];
          loginData.setString('usuario', user);
          loginData.setString('token', token);
          loginData.setInt('tokenTime', tokenTime.millisecondsSinceEpoch);
          print('Datos de usuario y token guardados en SharedPreferences');
          logueado = true;
          checkTokenExpiration();
          return true;
        } else {
          print('Error al tartar de loguear: ${res.statusCode}');
        }
      } catch (e) {
        print('Error al obtener token: $e');
      }
    }
    logueado = false;
    return false;
  }

  void getToken() async {
    user = loginData.getString('username')!;
    password = loginData.getString('password')!;
    DateTime tokenTime = DateTime.now();
    var uri = Uri.parse("$api/Auth/Authenticate");
    print('en get token que usuario tenemos? $user');
    if (await internet()) {
      try {
        var res = await http.post(
          uri,
          body: {"username": user, "password": password},
        );

        if (res.statusCode == 200) {
          final body = jsonDecode(res.body);
          final token = body['access_token'];
          loginData.setString('token', token);
          loginData.setInt('tokenTime', tokenTime.millisecondsSinceEpoch);
          print('Datos de usuario y token guardados en SharedPreferences');
        } else if (res.statusCode == 401) {
          print('Token expirado, intentando renovar...');
          // Intentar obtener el token nuevamente después de renovar
          getToken();
        } else {
          print('Error al obtener token: ${res.statusCode}');
        }
      } catch (e) {
        print('Error al obtener token: $e');
      }
    } else {
      print('No hay conexión a Internet');
      // Utilizar las credenciales almacenadas en SharedPreferences
      user = loginData.getString('username')!;
      password = loginData.getString('password')!;
      getToken();
    }
  }

  Future<bool> internet() async {
    try {
      final connection = await InternetAddress.lookup('google.com');
      if (connection.isNotEmpty && connection[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<void> validate() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showNoInternetBottomSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete todos los campos'),
          backgroundColor: Colors.red,
          elevation: 10,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      showNoInternetBottomSheet();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  void showNoInternetBottomSheet() {
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

  void login() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      mostrarCargando = true;
      user = usernameController.text;
      var uri = Uri.parse("$api/Auth/Authenticate");
      print(api);
      print('uri? $uri');
      var res = await http.post(uri,
          body: ({
            'username': usernameController.text,
            'password': passwordController.text,
          }));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        loginData.setBool('login', false);
        loginData.setString('username', usernameController.text);
        loginData.setString('password', passwordController.text);
        loginData.setString('token', body['access_token']);
        print('logueado $user, ${body['access_token']}');
        print('Datos de usuario y token guardados en SharedPreferences');
      } else {
        print('statussss ${res.statusCode}');
        setState(() {
          isLoading = false;
          mostrarCargando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('El usuario o contraseña son incorrectos'),
          backgroundColor: Colors.red,
          elevation: 10,
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset = MediaQuery.of(context).viewInsets.bottom;
    double defaultLoginSize = size.height - (size.height * 0.2);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
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
                borderRadius: BorderRadius.circular(100), color: PrimaryColor),
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
                  SizedBox(height: 125),
                  Image.asset(
                    'assets/logo.png',
                    height: 200,
                    width: 350,
                  ),
                  Text(
                    '¡Bienvenido de nuevo!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: PrimaryColor.withAlpha(50)),
                    child: TextField(
                      controller: usernameController,
                      cursorColor: PrimaryColor,
                      decoration: InputDecoration(
                        icon: Icon(Icons.mail_outline_rounded,
                            color: PrimaryColor),
                        hintText: 'Usuario',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: PrimaryColor.withAlpha(50)),
                      child: TextField(
                        controller: passwordController,
                        cursorColor: PrimaryColor,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock_outline_rounded,
                                color: PrimaryColor),
                            hintText: 'Contraseña',
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              color: PrimaryColor,
                              icon: Icon(showPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            )),
                      )),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onTap: (startLoading, stopLoading, btnState) async {
                      if (btnState == ButtonState.idle) {
                        startLoading();
                        await validate();
                        setState(() {});
                        await Future.delayed(const Duration(seconds: 5));
                        stopLoading();
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  Text(
                    'v 1.0.0',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}

void showNoInternetBottomSheet(BuildContext context) {
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
