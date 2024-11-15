import 'package:app_servicios_a_domicilio/constants.dart';
import 'package:app_servicios_a_domicilio/screens/perfil_screen.dart';
import 'package:app_servicios_a_domicilio/screens/servicios_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionBadgeWidget.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

import '../models/tecnico.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;
  late ServicioTecnicoModel tecnico;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0, // Índice inicial
      length: 2, // Número de pestañas
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: [
          const ListaServicios(),
          PerfilScreen(
            tecnico: tecnico,
          ),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Servicios",
        useSafeArea: true,
        labels: const ["Servicios", "Perfil"],
        icons: const [Icons.calendar_month_outlined, Icons.person_2_outlined],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: PrimaryColor,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: PrimaryColor,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
    );
  }
}
