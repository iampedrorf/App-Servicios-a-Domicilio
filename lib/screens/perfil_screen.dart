import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/tecnico.dart';
import '../providers/counter_notifications.dart';
import '../widgets/enermax_text.dart';
import 'inbox_screen.dart';

class PerfilScreen extends StatefulWidget {
  final ServicioTecnicoModel tecnico; // Recibe el modelo de técnico
  const PerfilScreen({super.key, required this.tecnico});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool isWorking = false; // Estado del switch (si comenzó a trabajar o no)

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
              return IconButton(
                icon: Stack(
                  children: [
                    Icon(Icons.message_outlined, color: Colors.white),
                    // Aquí puedes agregar un badge si es necesario, usando el stack
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InboxScreen()),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: PrimaryColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.tecnico.fotografia ??
                        "https://static.bellezaparatodos.com/2021/11/R.E.M.-Beauty-Ariana-Grande-Promo.jpg"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.tecnico.nombreCompleto,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.tecnico.centroServicio,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  SwitchListTile(
                    title: Text('¿Ha comenzado a trabajar?',
                        style: TextStyle(color: Colors.white)),
                    value: isWorking,
                    onChanged: (bool value) {
                      setState(() {
                        isWorking = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  buildContactInfo(Icons.email, 'Email', 'james012@gmail.com'),
                  SizedBox(height: 10),
                  buildContactInfo(Icons.phone, 'Mobile', '1234567891'),
                  SizedBox(height: 10),
                  buildContactInfo(
                      Icons.web, 'Behance', 'www.behance.net/james012'),
                  SizedBox(height: 10),
                  buildContactInfo(
                      Icons.facebook, 'Facebook', 'www.facebook.com/james012'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContactInfo(IconData icon, String label, String info) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 5),
            Text(
              info,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
