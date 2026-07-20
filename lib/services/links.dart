import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helpers for launching external actions (dial, sms, email, web).
class Links {
  Links._();

  static Future<void> _launch(Uri uri, BuildContext context) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) _fallback(context, uri.toString());
    } catch (_) {
      if (context.mounted) _fallback(context, uri.toString());
    }
  }

  static void _fallback(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(value)),
    );
  }

  static Future<void> dial(String number, BuildContext context) =>
      _launch(Uri(scheme: 'tel', path: number), context);

  static Future<void> sms(String number, BuildContext context,
          {String? body}) =>
      _launch(
        Uri(
            scheme: 'sms',
            path: number,
            queryParameters: body == null ? null : {'body': body}),
        context,
      );

  static Future<void> email(String address, BuildContext context,
          {String? subject}) =>
      _launch(
        Uri(
            scheme: 'mailto',
            path: address,
            queryParameters: subject == null ? null : {'subject': subject}),
        context,
      );

  static Future<void> web(String url, BuildContext context) =>
      _launch(Uri.parse(url), context);
}
