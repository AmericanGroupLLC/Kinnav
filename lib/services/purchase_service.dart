import '../app_state.dart';

/// Purchase boundary. Mock grants the plan immediately; swap in `in_app_purchase`
/// (App Store / Play products) in Phase 6 production behind the same interface.
abstract class PurchaseService {
  Future<bool> buy(SubscriptionPlan plan);
  Future<SubscriptionPlan?> restore();
}

class MockPurchaseService implements PurchaseService {
  @override
  Future<bool> buy(SubscriptionPlan plan) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return plan != SubscriptionPlan.none;
  }

  @override
  Future<SubscriptionPlan?> restore() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock: nothing to restore.
    return null;
  }
}
