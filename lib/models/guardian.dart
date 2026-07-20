import 'package:flutter/material.dart';

/// A vetted woman on the Safer network who can respond to a Safe Call.
class Guardian {
  final String name;
  final double distanceMiles;
  final List<String> languages;
  final bool online;
  final Color color; // used for the generated avatar
  final Offset mapPos; // normalized 0..1 position on the stylised map

  const Guardian({
    required this.name,
    required this.distanceMiles,
    required this.languages,
    required this.online,
    required this.color,
    required this.mapPos,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}

/// Sample guardians used across the map, guardians list and Safe Call.
const List<Guardian> kGuardians = [
  Guardian(
    name: 'Charlotte Reyes',
    distanceMiles: 0.4,
    languages: ['English', 'Spanish'],
    online: true,
    color: Color(0xFF7E57C2),
    mapPos: Offset(0.74, 0.30),
  ),
  Guardian(
    name: 'Sophia Nguyen',
    distanceMiles: 0.9,
    languages: ['English', 'Vietnamese'],
    online: true,
    color: Color(0xFF5C6BC0),
    mapPos: Offset(0.80, 0.66),
  ),
  Guardian(
    name: 'Camila Torres',
    distanceMiles: 1.0,
    languages: ['English', 'Spanish', 'Portuguese'],
    online: true,
    color: Color(0xFFAB47BC),
    mapPos: Offset(0.18, 0.58),
  ),
  Guardian(
    name: 'Naama Levi',
    distanceMiles: 2.3,
    languages: ['English', 'Hebrew'],
    online: true,
    color: Color(0xFFEC407A),
    mapPos: Offset(0.42, 0.24),
  ),
  Guardian(
    name: 'Jane Okafor',
    distanceMiles: 3.1,
    languages: ['English'],
    online: false,
    color: Color(0xFF26A69A),
    mapPos: Offset(0.30, 0.78),
  ),
  Guardian(
    name: 'Leah Cohen',
    distanceMiles: 4.6,
    languages: ['English', 'French'],
    online: true,
    color: Color(0xFFFF7043),
    mapPos: Offset(0.63, 0.82),
  ),
  Guardian(
    name: 'Priya Sharma',
    distanceMiles: 5.2,
    languages: ['English', 'Hindi'],
    online: false,
    color: Color(0xFF66BB6A),
    mapPos: Offset(0.55, 0.46),
  ),
  Guardian(
    name: 'Mia Rossi',
    distanceMiles: 6.8,
    languages: ['English', 'Italian'],
    online: true,
    color: Color(0xFF42A5F5),
    mapPos: Offset(0.86, 0.44),
  ),
];
