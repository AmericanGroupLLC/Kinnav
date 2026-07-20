/// A simple lat/lng holder to avoid a dependency until real maps land (Phase 2).
class LatLng {
  final double lat;
  final double lng;
  const LatLng(this.lat, this.lng);
}

/// Location boundary. Mock returns a fixed location; swap in `geolocator`
/// (foreground + background) in Phase 2.
abstract class LocationService {
  Future<bool> ensurePermission();
  Future<LatLng> current();
  Stream<LatLng> updates();
}

class MockLocationService implements LocationService {
  // Mountain View, CA — matches the reference screens.
  static const _base = LatLng(37.3861, -122.0839);

  @override
  Future<bool> ensurePermission() async => true;

  @override
  Future<LatLng> current() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _base;
  }

  @override
  Stream<LatLng> updates() async* {
    yield _base;
  }
}
