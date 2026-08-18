import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_state.dart';
import '../services/auth_service.dart';
import '../config/app_config.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';

/// Sign-in against the org's real Supabase backend.
///
/// The primary action calls [SupabaseAuthService.signInWithPassword], which maps
/// to `Supabase.instance.client.auth.signInWithPassword`. A one-tap
/// "Use test account" button signs in with the provisioned QA credentials.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = SupabaseAuthService.instance;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _is18 = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_is18) {
      setState(() => _error = context.l10n.signUpAgeRequired);
      return;
    }
    await _signInWith(_emailCtrl.text, _passwordCtrl.text);
  }

  /// One-tap test account: pre-fills and signs in with the QA credentials.
  Future<void> _useTestAccount() async {
    _emailCtrl.text = SupabaseAuthService.testEmail;
    _passwordCtrl.text = SupabaseAuthService.testPassword;
    setState(() => _is18 = true);
    await _signInWith(
        SupabaseAuthService.testEmail, SupabaseAuthService.testPassword);
  }

  Future<void> _signInWith(String email, String password) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _auth.signInWithPassword(email, password);
      await appState.signIn(); // routes to profile setup / home
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } on TimeoutException {
      // Distinguish "we could not reach the server" from "those credentials
      // were wrong": telling someone to check their password when they are
      // simply offline sends them down the wrong path.
      setState(() => _error = context.l10n.signUpOffline);
    } catch (_) {
      setState(() => _error = context.l10n.signUpFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Runs a real OAuth sign-in (Apple / Google). On success the account is
  /// created/authenticated by Supabase and routing advances into the app; on
  /// failure it surfaces an honest error rather than faking a session. User
  /// cancellation of the native sheet is silent (no error shown).
  Future<void> _oauthSignIn(Future<void> Function() signIn) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await signIn();
      await appState.signIn(); // routes to profile setup / home
    } catch (e) {
      if (mounted && !_isCancellation(e)) {
        setState(() =>
            _error = context.l10n.signUpUnavailable);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// The native SDKs throw when the user backs out of the sheet — that is not an
  /// error, so we don't show a message for it.
  bool _isCancellation(Object e) {
    if (e is AuthException) {
      return e.message.toLowerCase().contains('cancel');
    }
    final s = e.toString().toLowerCase();
    return s.contains('cancel') || s.contains('canceled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 84,
                height: 84,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // White rather than the gradient: the mark is full-colour
                  // and would blend into a purple background.
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: AppColors.lavenderCard, width: 2),
                ),
                child: Image.asset('assets/logo/kinnav_icon.png',
                    width: 48, height: 48),
              ),
              const SizedBox(height: 20),
              Text(context.l10n.signUpTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(context.l10n.signUpSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 28),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: _dec('Email'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: _dec('Password'),
              ),
              const SizedBox(height: 4),
              CheckboxListTile(
                value: _is18,
                onChanged: (v) => setState(() => _is18 = v ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.primary,
                title: Text(context.l10n.signUpAgeConfirm),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: AppColors.danger)),
              ],
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _busy ? null : _login,
                child: _busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(context.l10n.signUpLogIn,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _busy ? null : _useTestAccount,
                icon: const Icon(Icons.bolt, size: 18),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.primaryLight),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                label: Text(context.l10n.signUpTestAccount),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(context.l10n.signUpOr,
                        style: const TextStyle(color: AppColors.textMuted)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _oauthSignIn(_auth.signInWithApple),
                icon: const Icon(Icons.apple, size: 20),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textDark,
                  side: const BorderSide(color: AppColors.primaryLight),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                label: Text(context.l10n.signUpApple,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _oauthSignIn(_auth.signInWithGoogle),
                icon: const Icon(Icons.g_mobiledata, size: 26),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textDark,
                  side: const BorderSide(color: AppColors.primaryLight),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                label: Text(context.l10n.signUpGoogle,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.signUpLegalNote,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              if (AppConfig.showDevShortcuts) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => appState.enterDemoMode(),
                  icon: const Icon(Icons.fast_forward, size: 18),
                  label: Text(context.l10n.onboardingDemoMode),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );
}
