import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../app_state.dart';
import '../config/app_config.dart';
import '../services/api_client.dart';
import '../services/auth_api.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

/// Sign-in. Two modes, chosen at build time:
///  • BACKEND=americangroupllc → real email/password against the API gateway
///    (AuthApi, tokens stored securely). See AmericanGroupLLC_Developer_Docs §3.
///  • default (mock/offline)   → phone/email + OTP simulation, usable offline.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _mockAuth = MockAuthService();
  final _contactCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  bool get _useBackend => AppConfig.hasBackend;
  bool _register = false; // create-account vs log-in (backend mode)
  bool _otpSent = false; // mock mode
  bool _is18 = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _contactCtrl.dispose();
    _passwordCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  // ── Real backend (gateway) ──
  Future<void> _submitBackend() async {
    if (!_is18) {
      setState(() => _error = 'You must confirm you are 18 or older.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final email = _contactCtrl.text.trim();
      final pass = _passwordCtrl.text;
      if (_register) {
        await AuthApi.register(email, pass);
      } else {
        await AuthApi.login(email, pass);
      }
      await appState.signIn(); // tokens now in SecureStore; routes to profile setup
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Network error. Check your connection and retry.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ── Mock/offline (OTP) ──
  Future<void> _sendOtp() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await _mockAuth.requestOtp(_contactCtrl.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _otpSent = ok;
      if (!ok) _error = 'Enter a valid phone number or email.';
    });
  }

  Future<void> _verifyOtp() async {
    if (!_is18) {
      setState(() => _error = 'You must confirm you are 18 or older.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await _mockAuth.verifyOtp(_otpCtrl.text);
    if (!mounted) return;
    if (ok) {
      await appState.signIn();
    } else {
      setState(() {
        _busy = false;
        _error = 'Invalid code. Enter the 4-digit code sent to you.';
      });
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
              Text(_useBackend && _register ? 'Create your account' : 'Join Safer',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Sign in to connect with guardians near you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 28),
              TextField(
                controller: _contactCtrl,
                enabled: !(_otpSent && !_useBackend),
                keyboardType: TextInputType.emailAddress,
                decoration: _dec(
                    _useBackend ? 'Email' : 'Phone number or email'),
              ),
              if (_useBackend) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: _dec('Password'),
                ),
              ],
              if (!_useBackend && _otpSent) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _dec('Verification code')
                      .copyWith(helperText: 'Demo: enter any 4+ digits'),
                ),
              ],
              if (_useBackend || _otpSent) ...[
                const SizedBox(height: 4),
                CheckboxListTile(
                  value: _is18,
                  onChanged: (v) => setState(() => _is18 = v ?? false),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primary,
                  title: const Text('I confirm I am 18 years or older'),
                ),
              ],
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
                onPressed: _busy
                    ? null
                    : (_useBackend
                        ? _submitBackend
                        : (_otpSent ? _verifyOtp : _sendOtp)),
                child: _busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(_primaryLabel(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              if (_useBackend)
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() {
                            _register = !_register;
                            _error = null;
                          }),
                  child: Text(_register
                      ? 'Have an account? Log in'
                      : 'New here? Create an account'),
                ),
              const SizedBox(height: 4),
              const Text(
                'By continuing you agree to our Terms & Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => appState.enterDemoMode(),
                  icon: const Icon(Icons.bolt, size: 18),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    side: const BorderSide(color: AppColors.primaryLight),
                  ),
                  label: const Text('Demo mode (dev) — skip to app'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _primaryLabel() {
    if (_useBackend) return _register ? 'Create account' : 'Log in';
    return _otpSent ? 'Verify & Continue' : 'Send code';
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );
}
