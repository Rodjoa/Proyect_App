import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Configuración para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración de inicialización
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Inicializar el plugin
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Manejar cuando se toca la notificación
        print('Notificación tocada: ${response.payload}');
      },
    );

    // Crear canal de notificación (requerido para Android 8.0+)
    await _createNotificationChannel();

    _isInitialized = true;
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'daily_channel_id',
      'Daily Notifications',
      description: 'Daily Notification Channel',
      importance: Importance.max,
      playSound: true,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<bool> _areNotificationsEnabled() async {
    final bool? result =
        await notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled();

    return result ?? false;
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    if (!_isInitialized) await initNotification();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'daily_channel_id',
          'Daily Notifications',
          channelDescription: 'Daily Notification Channel',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
