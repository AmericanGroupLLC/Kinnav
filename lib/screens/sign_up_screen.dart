import 'package:flutter/material.dart';
import '../app_state.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

/// Phone/email + OTP sign-in with an 18+ age gate. Uses the mock AuthService;
/// swap in a real backend later behind the same interface.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = MockAuthService();
  final _contactCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  bool _otpSent = false;
  bool _is18 = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _contactCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await _auth.requestOtp(_contactCtrl.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (ok) {
        _otpSent = true;
      } else {
        _error = 'Enter a valid phone number or email.';
      }
    });
  }

  Future<void> _verify() async {
    if (!_is18) {
      setState(() => _error = 'You must confirm you are 18 or older.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await _auth.verifyOtp(_otpCtrl.text);
    if (!mounted) return;
    if (ok) {
      await appState.signIn(); // routes to profile setup
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
              const Text('Join Safer',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Sign in to connect with guardians near you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 28),
              TextField(
                controller: _contactCtrl,
                enabled: !_otpSent,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Phone number or email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              if (_otpSent) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Verification code',
                    helperText: 'Demo: enter any 4+ digits',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 8),
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
                Text(_error!,
                    style: const TextStyle(color: AppColors.danger)),
              ],
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _busy ? null : (_otpSent ? _verify : _sendOtp),
                child: _busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(_otpSent ? 'Verify & Continue' : 'Send code',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 12),
              const Text(
                'By continuing you agree to our Terms & Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
