import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/links.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';

/// A simple feedback form (Feedback menu item).
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _controller = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Hands the feedback to the user's mail client, addressed to the support
  /// inbox.
  ///
  /// The app has no backend for this, and the previous version only cleared
  /// the form while saying "thank you" — so every piece of feedback anyone
  /// ever wrote was silently discarded. A mailto: is the honest mechanism:
  /// the user still has to press send, so the wording says so rather than
  /// claiming we received anything.
  void _submit() {
    FocusScope.of(context).unfocus();

    final message = _controller.text.trim();
    if (_rating == 0 && message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.feedbackAddRatingNoteFirst)),
      );
      return;
    }

    final stars = _rating > 0 ? '$_rating/5' : 'not rated';
    Links.email(
      AppConfig.supportEmail,
      context,
      subject: 'Kinnav app feedback — $stars',
      body: 'Rating: $stars\n\n'
          '${message.isEmpty ? '(no message)' : message}\n\n'
          '[Sent from the Kinnav app]',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.feedbackEmailOpened),
        backgroundColor: AppColors.primaryDark,
      ),
    );
    setState(() {
      _controller.clear();
      _rating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.feedbackFeedback)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(context.l10n.feedbackHowKinnavExperience,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _rating = i),
                  icon: Icon(
                    i <= _rating ? Icons.star : Icons.star_border,
                    color: AppColors.primary,
                    size: 34,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: context.l10n.feedbackHint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _submit,
              child: Text(context.l10n.feedbackSendFeedback,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
