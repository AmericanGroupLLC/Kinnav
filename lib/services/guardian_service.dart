import '../models/guardian.dart';

/// Guardian directory / presence boundary. Mock returns bundled sample data;
/// swap in real-time geo-queries (Phase 3) behind the same interface.
abstract class GuardianService {
  Future<List<Guardian>> nearby({int limit = 8});
  Future<int> nearbyCount();
}

class MockGuardianService implements GuardianService {
  @override
  Future<List<Guardian>> nearby({int limit = 8}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return kGuardians.take(limit).toList();
  }

  @override
  Future<int> nearbyCount() async => 69; // reflects the "+63" beyond the row
}
