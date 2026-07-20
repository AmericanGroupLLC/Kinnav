import 'package:geolocator/geolocator.dart';

/// A simple lat/lng holder (kept provider-agnostic).
class LatLng {
  final double lat;
  final double lng;
  const LatLng(this.lat, this.lng);
}

/// Location boundary.
abstract class LocationService {
  Future<bool> ensurePermission();
  Future<LatLng> current();
  Stream<LatLng> updates();
}

/// Real GPS via geolocator, with a safe fallback (e.g. simulator/denied) so the
/// map always has coordinates to render.
class GeoLocationService implements LocationService {
  // Mountain View, CA — fallback matching the reference screens.
  static const _fallback = LatLng(37.3861, -122.0839);

  @override
  Future<bool> ensurePermission() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return false;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      return perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<LatLng> current() async {
    try {
      if (!await ensurePermission()) return _fallback;
      final pos = await Geolocator.getCurrentPosition();
      return LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      return _fallback;
    }
  }

  @override
  Stream<LatLng> updates() async* {
    try {
      if (!await ensurePermission()) {
        yield _fallback;
        return;
      }
      yield* Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 20,
        ),
      ).map((p) => LatLng(p.latitude, p.longitude));
    } catch (_) {
      yield _fallback;
    }
  }
}
