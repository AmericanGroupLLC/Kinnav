import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/call_record.dart';
import 'models/safety_contact.dart';
import 'models/user_profile.dart';
import 'services/auth_service.dart';
import 'services/secure_store.dart';
import 'services/storage.dart';

enum SubscriptionPlan { none, monthly, annual }

/// Single source of truth for session + user data, persisted to local storage.
/// A backend can later sync against the same shape.
class AppState extends ChangeNotifier {
  AppState(this._storage) {
    _load();
    // Routing gates on [signedIn]. That local flag can diverge from the real
    // auth state (e.g. the Supabase session expired since last launch), so we
    // reconcile it against [SupabaseAuthService.isSignedIn] at startup and
    // whenever Supabase reports an auth change.
    _reconcileSignedIn();
    _watchAuth();
  }

  final Storage _storage;
  StreamSubscription<AuthState>? _authSub;

  // Keys
  static const _kOnboarded = 'onboarded';
  static const _kSignedIn = 'signedIn';
  static const _kProfile = 'profile';
  static const _kContacts = 'safetyContacts';
  static const _kRedeemed = 'redeemedRewards';
  static const _kCompleted = 'completedModules';
  static const _kPlan = 'subscriptionPlan';
  static const _kCallHistory = 'callHistory';
  static const _kGuardianStep = 'guardianCourseStep';
  static const _kGuardianAvailable = 'guardianAvailable';

  // State
  bool _onboarded = false;
  bool _signedIn = false;
  UserProfile? _profile;
  List<SafetyContact> _contacts = [];
  Set<String> _redeemedRewards = {};
  Set<String> _completedModules = {};
  SubscriptionPlan _plan = SubscriptionPlan.none;
  List<CallRecord> _callHistory = [];
  int _guardianCourseStep = 0; // 0..totalGuardianCourseSteps (Phase 5)
  bool _guardianAvailable = false;

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
  List<CallRecord> get callHistory => List.unmodifiable(_callHistory);
  int get guardianCourseStep => _guardianCourseStep;
  bool get guardianAvailable => _guardianAvailable;
  static const int totalGuardianCourseSteps = 8; // ~5h/module ≈ 40h course

  int get guardianCourseHoursDone =>
      _guardianCourseStep * (40 ~/ totalGuardianCourseSteps);

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
    final h = _storage.getJsonList(_kCallHistory);
    if (h != null) {
      _callHistory = h
          .map((e) => CallRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    _guardianCourseStep = int.tryParse(
            _storage.getString(_kGuardianStep) ?? '') ??
        0;
    _guardianAvailable = _storage.getBool(_kGuardianAvailable);
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

  /// Subscribes to Supabase auth events so a dropped/expired/refreshed session
  /// immediately flips routing to match. No-op when Supabase isn't initialized
  /// (offline/sandbox runs).
  void _watchAuth() {
    try {
      _authSub = Supabase.instance.client.auth.onAuthStateChange
          .listen((_) => _reconcileSignedIn());
    } catch (_) {
      // Supabase unavailable — nothing to watch; the local flag is authoritative.
    }
  }

  /// Aligns the local [signedIn] flag with the authoritative auth state. If the
  /// app thinks it is signed in but there is no valid Supabase session and no
  /// valid local fallback, sign out and route back to login.
  void _reconcileSignedIn() {
    if (_signedIn && !SupabaseAuthService.instance.isSignedIn) {
      _signedIn = false;
      unawaited(_storage.setBool(_kSignedIn, false));
      unawaited(SupabaseAuthService.instance.signOut());
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

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

  /// Dev/testing shortcut: seeds a demo session (onboarded + signed in + a
  /// sample profile) and jumps straight to Home. Exposed only in debug builds.
  Future<void> enterDemoMode() async {
    _onboarded = true;
    _signedIn = true;
    _profile ??= const UserProfile(
      name: 'Demo User',
      birthMonth: 8,
      birthYear: 1995,
      identity: 'Woman',
      languages: ['English', 'Hindi'],
    );
    await _storage.setBool(_kOnboarded, true);
    await _storage.setBool(_kSignedIn, true);
    await _storage.setJson(_kProfile, _profile!.toJson());
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

  Future<void> addCallRecord(CallRecord record) async {
    _callHistory = [record, ..._callHistory];
    await _storage.setJsonList(
        _kCallHistory, _callHistory.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> advanceGuardianCourse() async {
    if (_guardianCourseStep >= totalGuardianCourseSteps) return;
    _guardianCourseStep++;
    await _storage.setString(_kGuardianStep, _guardianCourseStep.toString());
    if (_guardianCourseStep >= totalGuardianCourseSteps) {
      await setIsGuardian(true); // course complete → verified guardian
    }
    notifyListeners();
  }

  bool get isGuardianCourseComplete =>
      _guardianCourseStep >= totalGuardianCourseSteps;

  Future<void> setGuardianAvailable(bool value) async {
    _guardianAvailable = value;
    await _storage.setBool(_kGuardianAvailable, value);
    notifyListeners();
  }

  Future<void> logOut() async {
    _signedIn = false;
    await _storage.setBool(_kSignedIn, false);
    // Clear both the Supabase session and the local (offline) fallback session.
    await SupabaseAuthService.instance.signOut();
    await SecureStore.instance.clear(); // drop any legacy JWTs
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await SupabaseAuthService.instance.signOut();
    await _storage.clear();
    await SecureStore.instance.clear();
    _onboarded = false;
    _signedIn = false;
    _profile = null;
    _contacts = _defaultContacts();
    _redeemedRewards = {};
    _completedModules = {};
    _plan = SubscriptionPlan.none;
    _callHistory = [];
    _guardianCourseStep = 0;
    _guardianAvailable = false;
    notifyListeners();
  }
}

/// Global accessor (kept simple; a DI/provider setup can replace this later).
late AppState appState;
