import '../models/guardian.dart';

/// Where the guardians shown on the map, the chat picker and the Safe Call
/// screen come from.
///
/// Four screens and two widgets used to reach straight into the `kGuardians`
/// sample list, so pointing the app at a real network meant editing all six
/// and hoping none were missed. They now go through this, and swapping in a
/// backend is one line in [ServiceLocator].
///
/// Reads are synchronous on purpose. Every call site renders inside `build`,
/// and making them async would mean a `FutureBuilder` in each — a large change
/// for no benefit while the data is local. A real implementation fetches in
/// [refresh] and serves the cache here, which is the same shape a map screen
/// wants anyway: draw what you have, update when it arrives.
abstract class GuardianService {
  /// Guardians near the user, nearest first, at most [limit].
  List<Guardian> nearby({int limit});

  /// Only those currently available to take a call.
  List<Guardian> online({int limit});

  /// Every guardian, for the directory screen.
  List<Guardian> all();

  /// Pulls fresh data. A no-op for the sample data; the network call for a
  /// real backend. Safe to call on every screen entry.
  Future<void> refresh();
}

/// Serves the bundled sample guardians.
///
/// This is what ships until a backend exists, and it is why the app is a demo:
/// the people on the map are [kGuardians], not real responders.
class MockGuardianService implements GuardianService {
  const MockGuardianService();

  @override
  List<Guardian> nearby({int limit = 6}) {
    final sorted = [...kGuardians]
      ..sort((a, b) => a.distanceMiles.compareTo(b.distanceMiles));
    return sorted.take(limit).toList();
  }

  @override
  List<Guardian> online({int limit = 4}) =>
      nearby(limit: kGuardians.length).where((g) => g.online).take(limit).toList();

  @override
  List<Guardian> all() => nearby(limit: kGuardians.length);

  @override
  Future<void> refresh() async {}
}
