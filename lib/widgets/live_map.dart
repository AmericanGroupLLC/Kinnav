import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '../config/app_config.dart';
import '../models/guardian.dart';
import '../services/location_service.dart' as loc;
import 'map_view.dart';

/// Renders a real Google Map when a Maps API key is configured
/// (`--dart-define=MAPS_API_KEY=...`); otherwise falls back to the offline
/// painted map so the app always works — including in the field with no key yet.
class LiveMap extends StatelessWidget {
  final loc.LatLng? center;
  final List<Guardian> guardians;

  const LiveMap({super.key, required this.center, this.guardians = kGuardians});

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.hasMaps || center == null) {
      return const MapView();
    }
    final c = gmaps.LatLng(center!.lat, center!.lng);
    final markers = <gmaps.Marker>{
      gmaps.Marker(
        markerId: const gmaps.MarkerId('me'),
        position: c,
        infoWindow: const gmaps.InfoWindow(title: 'You'),
      ),
      for (final g in guardians)
        gmaps.Marker(
          markerId: gmaps.MarkerId(g.name),
          // Spread guardians around the user based on their layout offset.
          position: gmaps.LatLng(
            center!.lat + (g.mapPos.dy - 0.5) * 0.03,
            center!.lng + (g.mapPos.dx - 0.5) * 0.03,
          ),
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
              gmaps.BitmapDescriptor.hueViolet),
          infoWindow: gmaps.InfoWindow(
              title: g.name.split(' ').first,
              snippet: '${g.distanceMiles} mi away'),
        ),
    };
    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(target: c, zoom: 14),
      markers: markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }
}
