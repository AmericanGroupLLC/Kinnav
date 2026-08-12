import 'package:flutter/material.dart';

/// A personal trusted contact notified with the user's live location on a Safe Call.
class SafetyContact {
  final String name;
  final String phone;
  final String relation;
  final int colorValue;

  const SafetyContact({
    required this.name,
    required this.phone,
    required this.relation,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  String get initial =>
      name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'relation': relation,
        'colorValue': colorValue,
      };

  factory SafetyContact.fromJson(Map<String, dynamic> j) => SafetyContact(
        name: j['name'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        relation: j['relation'] as String? ?? 'Contact',
        // Mirrors AppColors.primary; the models layer stays free of theme
        // imports, so the brand purple is repeated as a literal here.
        colorValue: j['colorValue'] as int? ?? 0xFFBF6EEE,
      );
}
