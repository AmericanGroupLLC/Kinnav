import 'package:flutter/foundation.dart';
import 'models/safety_contact.dart';
import 'models/user_profile.dart';
import 'services/storage.dart';

enum SubscriptionPlan { none, monthly, annual }

/// Single source of truth for session + user data, persisted to local storage.
/// A backend can later sync against the same shape.
class AppState extends ChangeNotifier {
  AppState(this._storage) {
    _load();
  }

  final Storage _storage;

  // Keys
  static const _kOnboarded = 'onboarded';
  static const _kSignedIn = 'signedIn';
  static const _kProfile = 'profile';
  static const _kContacts = 'safetyContacts';
  static const _kRedeemed = 'redeemedRewards';
  static const _kCompleted = 'completedModules';
  static const _kPlan = 'subscriptionPlan';

  // State
  bool _onboarded = false;
  bool _signedIn = false;
  UserProfile? _profile;
  List<SafetyContact> _contacts = [];
  Set<String> _redeemedRewards = {};
  Set<String> _completedModules = {};
  SubscriptionPlan _plan = SubscriptionPlan.none;

  // Getters
  bool get onboarded => _onboarded;
  bool get signedIn => _signedIn;
  bool get hasProfile => _profile != null;
  UserProfile? get profile => _profile;
  List<SafetyContact> get contacts => List.unmodifiable(_contacts);
  Set<String> get redeemedRewards => Set.unmodifiable(_redeemedRewards);
  Set<String> get completedModules => Set.unmodifiable(_completedModules);
  SubscriptionPlan get plan => _plan;
  bool get isSubscribed => _plan != SubscriptionPlan.none;

  void _load() {
    _onboarded = _storage.getBool(_kOnboarded);
    _signedIn = _storage.getBool(_kSignedIn);
    final p = _storage.getJson(_kProfile);
    if (p != null) _profile = UserProfile.fromJson(p);
    final c = _storage.getJsonList(_kContacts);
    if (c != null) {
      _contacts = c
          .map((e) => SafetyContact.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      _contacts = _defaultContacts();
    }
    _redeemedRewards = _storage.getStringSet(_kRedeemed);
    _completedModules = _storage.getStringSet(_kCompleted);
    final planName = _storage.getString(_kPlan);
    _plan = SubscriptionPlan.values.firstWhere(
      (e) => e.name == planName,
      orElse: () => SubscriptionPlan.none,
    );
  }

  List<SafetyContact> _defaultContacts() => const [
        SafetyContact(
            name: 'Mom',
            phone: '+1 (555) 010-2233',
            relation: 'Family',
            colorValue: 0xFFAB47BC),
        SafetyContact(
            name: 'Emma',
            phone: '+1 (555) 887-6655',
            relation: 'Best friend',
            colorValue: 0xFF5C6BC0),
      ];

  // Mutations
  Future<void> completeOnboarding() async {
    _onboarded = true;
    await _storage.setBool(_kOnboarded, true);
    notifyListeners();
  }

  Future<void> signIn() async {
    _signedIn = true;
    await _storage.setBool(_kSignedIn, true);
    notifyListeners();
  }

  Future<void> setProfile(UserProfile profile) async {
    _profile = profile;
    await _storage.setJson(_kProfile, profile.toJson());
    notifyListeners();
  }

  Future<void> setIsGuardian(bool value) async {
    if (_profile == null) return;
    _profile = _profile!.copyWith(isGuardian: value);
    await _storage.setJson(_kProfile, _profile!.toJson());
    notifyListeners();
  }

  Future<void> addContact(SafetyContact c) async {
    _contacts = [..._contacts, c];
    await _persistContacts();
    notifyListeners();
  }

  Future<void> removeContactAt(int index) async {
    _contacts = [..._contacts]..removeAt(index);
    await _persistContacts();
    notifyListeners();
  }

  Future<void> _persistContacts() =>
      _storage.setJsonList(_kContacts, _contacts.map((e) => e.toJson()).toList());

  bool isRedeemed(String rewardTitle) => _redeemedRewards.contains(rewardTitle);

  Future<void> redeemReward(String rewardTitle) async {
    _redeemedRewards = {..._redeemedRewards, rewardTitle};
    await _storage.setStringSet(_kRedeemed, _redeemedRewards);
    notifyListeners();
  }

  bool isModuleComplete(String moduleTitle) =>
      _completedModules.contains(moduleTitle);

  Future<void> toggleModuleComplete(String moduleTitle) async {
    final next = {..._completedModules};
    if (!next.add(moduleTitle)) next.remove(moduleTitle);
    _completedModules = next;
    await _storage.setStringSet(_kCompleted, _completedModules);
    notifyListeners();
  }

  Future<void> setPlan(SubscriptionPlan plan) async {
    _plan = plan;
    await _storage.setString(_kPlan, plan.name);
    notifyListeners();
  }

  Future<void> logOut() async {
    _signedIn = false;
    await _storage.setBool(_kSignedIn, false);
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await _storage.clear();
    _onboarded = false;
    _signedIn = false;
    _profile = null;
    _contacts = _defaultContacts();
    _redeemedRewards = {};
    _completedModules = {};
    _plan = SubscriptionPlan.none;
    notifyListeners();
  }
}

/// Global accessor (kept simple; a DI/provider setup can replace this later).
late AppState appState;
