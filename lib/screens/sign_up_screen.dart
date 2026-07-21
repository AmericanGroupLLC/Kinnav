import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_state.dart';
import '../services/auth_service.dart';
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
      setState(() => _error = 'You must confirm you are 18 or older.');
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
    } catch (_) {
      setState(() =>
          _error = 'Could not sign in. Check your connection and credentials.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
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
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_moon_outlined,
                    color: Colors.white, size: 44),
              ),
              const SizedBox(height: 20),
              const Text('Join Safer',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Sign in to connect with guardians near you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted)),
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
                title: const Text('I confirm I am 18 years or older'),
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
                    : const Text('Log in',
                        style: TextStyle(
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
                label: const Text('Use test account'),
              ),
              const SizedBox(height: 8),
              const Text(
                'By continuing you agree to our Terms & Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => appState.enterDemoMode(),
                  icon: const Icon(Icons.fast_forward, size: 18),
                  label: const Text('Demo mode (dev) — skip to app'),
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
