import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/notification_detail_screen.dart';
import 'counter_notifications.dart';

class PushNotificationProvider {
  final NotificationCounter notificationCounter;
  bool _isNotificationHandled = false; // Nueva variable para evitar duplicados

  PushNotificationProvider(this.notificationCounter);

  void initNotifications(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Solicitar permisos para recibir notificaciones
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? fcmToken = await messaging.getToken();
      print("Token de FCM: $fcmToken");
    }

    // Cuando llega una notificación en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (_isNotificationHandled)
        return; // Evitar manejar la misma notificación
      _isNotificationHandled = true;

      notificationCounter.increment();
      notificationCounter.addNotification(message.data);

      if (message.notification != null) {
        print('Título: ${message.notification!.title}');
        print('Cuerpo: ${message.notification!.body}');
      }

      // Navegar a otra pantalla con los datos de la notificación
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => NotificationDetailScreen(
            notificationData: message.data,
          ),
        ),
      );

      // Restablecer después de un pequeño retraso para permitir futuras notificaciones
      Future.delayed(Duration(seconds: 2), () {
        _isNotificationHandled = false;
      });
    });

    // Cuando el usuario abre la aplicación desde una notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (_isNotificationHandled) return;
      _isNotificationHandled = true;

      notificationCounter.increment();
      notificationCounter.addNotification(message.data);

      // Navegar a otra pantalla con los datos de la notificación
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => NotificationDetailScreen(
            notificationData: message.data,
          ),
        ),
      );

      Future.delayed(Duration(seconds: 2), () {
        _isNotificationHandled = false;
      });
    });

    // Cuando la app se abre desde una notificación (cerrada o en segundo plano)
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      if (!_isNotificationHandled) {
        _isNotificationHandled = true;
        notificationCounter.increment();
        notificationCounter.addNotification(initialMessage.data);

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => NotificationDetailScreen(
              notificationData: initialMessage.data,
            ),
          ),
        );

        Future.delayed(Duration(seconds: 2), () {
          _isNotificationHandled = false;
        });
      }
    }
  }
}
