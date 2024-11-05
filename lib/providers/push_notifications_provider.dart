import 'dart:io'; // Importa dart:io para detectar la plataforma

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'counter_notifications.dart';

class PushNotificationProvider {
  final NotificationCounter notificationCounter;
  bool _isNotificationHandled = false; // Nueva variable para evitar duplicados

  PushNotificationProvider(this.notificationCounter);

  void initNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

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

      Future.delayed(Duration(seconds: 2), () {
        _isNotificationHandled = false; // Reset después de un tiempo
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (_isNotificationHandled)
        return; // Evitar manejar la misma notificación
      _isNotificationHandled = true;

      notificationCounter.increment();
      notificationCounter.addNotification(message.data);

      Future.delayed(Duration(seconds: 2), () {
        _isNotificationHandled = false; // Reset después de un tiempo
      });
    });

    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      if (!_isNotificationHandled) {
        _isNotificationHandled = true;
        notificationCounter.increment();
        notificationCounter.addNotification(initialMessage.data);

        Future.delayed(Duration(seconds: 2), () {
          _isNotificationHandled = false; // Reset después de un tiempo
        });
      }
    }
  }
}
