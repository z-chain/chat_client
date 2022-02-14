import '../../index.dart';

class NotificationState {
  final bool enabled;

  final bool granted;

  final AppException? exception;

  NotificationState._(
      {required this.granted, required this.enabled, this.exception});

  factory NotificationState.initial() =>
      NotificationState._(granted: false, enabled: false);

  NotificationState clone(
      {bool? granted, bool? enabled, AppException? exception}) {
    return NotificationState._(
        granted: granted ?? this.granted,
        enabled: enabled ?? this.enabled,
        exception: exception);
  }
}
