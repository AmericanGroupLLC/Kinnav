import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/guardian.dart';
import 'guardian_service.dart';

/// Guardians from the Supabase project the app already authenticates against.
///
/// No new dependency: `supabase_flutter` is already here and initialised in
/// `main()`, so this is the shortest path off sample data.
///
/// Expected table — create it, then build with
/// `--dart-define=BACKEND=americangroupllc`:
///
/// ```sql
/// create table public.guardians (
///   id           uuid primary key default gen_random_uuid(),
///   name         text        not null,
///   languages    text[]      not null default '{English}',
///   is_online    boolean     not null default false,
///   lat          double precision,
///   lng          double precision,
///   avatar_color integer,            -- 0xAARRGGBB; a colour is derived if null
///   updated_at   timestamptz not null default now()
/// );
/// alter table public.guardians enable row level security;
/// -- Signed-in users may read the roster; only the service role writes it.
/// create policy "read guardians" on public.guardians
///   for select to authenticated using (true);
/// ```
///
/// Distance is computed here rather than in the database so the roster can be
/// cached and re-sorted as the user moves, without a round trip per step.
class SupabaseGuardianService implements GuardianService {
  SupabaseGuardianService({this.fallback = kGuardians});

  /// Shown until a fetch succeeds, so the map is never empty on a cold start.
  final List<Guardian> fallback;
  List<Guardian>? _cache;

  /// The user's last known position, used to sort and label distances.
  double? _originLat;
  double? _originLng;

  /// True while showing bundled sample data because the fetch has not
  /// succeeded — the UI says so rather than implying these are real people.
  bool get usingFallback => _cache == null;

  void setOrigin(double lat, double lng) {
    _originLat = lat;
    _originLng = lng;
    if (_cache != null) _cache = _sorted(_cache!);
  }

  List<Guardian> get _people => _cache ?? fallback;

  @override
  List<Guardian> all() => _people;

  @override
  List<Guardian> nearby({int limit = 6}) => _people.take(limit).toList();

  @override
  List<Guardian> online({int limit = 4}) =>
      _people.where((g) => g.online).take(limit).toList();

  @override
  Future<void> refresh() async {
    try {
      final rows = await Supabase.instance.client
          .from('guardians')
          .select('name, languages, is_online, lat, lng, avatar_color')
          .limit(200);

      final parsed = <Guardian>[];
      for (final row in rows) {
        final g = _fromRow(row);
        if (g != null) parsed.add(g);
      }
      // An empty roster is a real answer — an empty map is more honest than
      // silently showing sample people — but a failed fetch is not, and that
      // arrives as an exception below.
      _cache = _sorted(parsed);
    } catch (_) {
      // Offline, table missing, or RLS denied it. Keep whatever we had; the
      // map still draws, and usingFallback stays true so the UI can say so.
    }
  }

  Guardian? _fromRow(Map<String, dynamic> row) {
    final name = (row['name'] as String?)?.trim();
    if (name == null || name.isEmpty) return null;

    final lat = (row['lat'] as num?)?.toDouble();
    final lng = (row['lng'] as num?)?.toDouble();
    final colorValue = (row['avatar_color'] as num?)?.toInt();

    return Guardian(
      name: name,
      distanceMiles: _milesTo(lat, lng),
      languages: (row['languages'] as List?)?.cast<String>() ?? const ['English'],
      online: row['is_online'] as bool? ?? false,
      color: Color(colorValue ?? _colorFor(name)),
      mapPos: _mapPos(name, lat, lng),
    );
  }

  List<Guardian> _sorted(List<Guardian> list) {
    final copy = [...list]
      ..sort((a, b) => a.distanceMiles.compareTo(b.distanceMiles));
    return copy;
  }

  /// Great-circle distance in miles. Returns 0 when either end is unknown, so
  /// a guardian without coordinates sorts first rather than disappearing.
  double _milesTo(double? lat, double? lng) {
    final oLat = _originLat, oLng = _originLng;
    if (lat == null || lng == null || oLat == null || oLng == null) return 0;
    const earthMiles = 3958.8;
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(lat - oLat);
    final dLng = rad(lng - oLng);
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(oLat)) * math.cos(rad(lat)) * math.pow(math.sin(dLng / 2), 2);
    return earthMiles * 2 * math.asin(math.min(1, math.sqrt(a)));
  }

  /// Where the pin sits on the stylised offline map, 0..1 in both axes.
  /// Derived from the name when there are no coordinates so pins stay put
  /// between rebuilds instead of jumping around.
  Offset _mapPos(String name, double? lat, double? lng) {
    if (lat == null || lng == null) {
      final h = name.hashCode.abs();
      return Offset(0.15 + (h % 70) / 100, 0.15 + ((h ~/ 70) % 70) / 100);
    }
    final oLat = _originLat ?? lat, oLng = _originLng ?? lng;
    // ~0.1 of the map per 0.01 degree, clamped so nobody lands off-canvas.
    return Offset(
      (0.5 + (lng - oLng) * 10).clamp(0.08, 0.92),
      (0.5 - (lat - oLat) * 10).clamp(0.08, 0.92),
    );
  }

  /// Stable avatar tint when the row does not carry one.
  int _colorFor(String name) {
    const palette = [
      0xFF7E57C2, 0xFF5C6BC0, 0xFFAB47BC, 0xFFEC407A,
      0xFF26A69A, 0xFFFF7043, 0xFF66BB6A, 0xFF42A5F5,
    ];
    return palette[name.hashCode.abs() % palette.length];
  }
}
