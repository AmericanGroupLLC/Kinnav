import 'package:flutter/foundation.dart';

/// Analytics / crash-reporting boundary. No-op by default; swap in Firebase
/// Analytics + Crashlytics (or Sentry) in production. Never log PII or precise
/// location here.
abstract class AnalyticsService {
  void logEvent(String name, {Map<String, Object?> params});
  void recordError(Object error, StackTrace? stack);
}

class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  void logEvent(String name, {Map<String, Object?> params = const {}}) {
    if (kDebugMode) debugPrint('[analytics] $name $params');
  }

  @override
  void recordError(Object error, StackTrace? stack) {
    if (kDebugMode) debugPrint('[analytics] error: $error');
  }
}

/// Global analytics accessor (replace the instance at startup for prod).
AnalyticsService analytics = const NoopAnalyticsService();
