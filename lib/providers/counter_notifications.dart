import 'package:flutter/foundation.dart';

class NotificationCounter extends ChangeNotifier {
  int _count = 0;
  List<Map<String, dynamic>> _notifications = [];

  int get count => _count;
  List<Map<String, dynamic>> get notifications => _notifications;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void addNotification(Map<String, dynamic> notificationData) {
    _notifications.add(notificationData);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
