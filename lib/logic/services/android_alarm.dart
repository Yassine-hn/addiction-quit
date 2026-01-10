import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

@pragma('vm:entry-point')
void printHello() {
  final now = DateTime.now();
  final isolateId = Isolate.current.hashCode;
  print("[$now] Hello from alarm isolate=$isolateId");
}

Future<void> initAndroidAlarm() async {
  await AndroidAlarmManager.initialize();

  const int alarmId = 0;
  await AndroidAlarmManager.periodic(
    const Duration(minutes: 1),
    alarmId,
    printHello,
    wakeup: true,
    rescheduleOnReboot: true,
  );
}
