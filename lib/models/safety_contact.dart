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
        colorValue: j['colorValue'] as int? ?? 0xFF9B59D0,
      );
}
