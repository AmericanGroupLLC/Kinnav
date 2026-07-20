import 'package:flutter/material.dart';

/// A Self Care & Empowerment learning module.
class Module {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> lessons;

  const Module({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.lessons = const [],
  });
}

/// A reward / wellness offer redeemable by members.
class Reward {
  final String title;
  final String partner;
  final String offer;
  final IconData icon;
  final Color color;

  const Reward({
    required this.title,
    required this.partner,
    required this.offer,
    required this.icon,
    required this.color,
  });
}

/// Self Care & Empowerment Modules (from the app menu spec).
const List<Module> kModules = [
  Module(
    title: 'Safety Planning',
    subtitle: 'Understand and prepare',
    icon: Icons.shield_outlined,
    lessons: [
      'Understanding types of abuse',
      'Emotional safety',
      'Physical safety',
      'A future without fear',
    ],
  ),
  Module(
    title: 'Self Defense Techniques',
    subtitle: 'Practical, guided drills',
    icon: Icons.sports_martial_arts,
  ),
  Module(
    title: 'Tech Abuse Awareness',
    subtitle: 'Stay safe online & on device',
    icon: Icons.phonelink_lock_outlined,
  ),
  Module(
    title: 'Assertive Communication',
    subtitle: 'Communication & boundaries',
    icon: Icons.record_voice_over_outlined,
  ),
  Module(
    title: 'Workforce Professionalism',
    subtitle: 'Grow your career confidence',
    icon: Icons.work_outline,
  ),
  Module(
    title: 'Low-cost Self Care',
    subtitle: 'Simple daily activities',
    icon: Icons.spa_outlined,
  ),
  Module(
    title: 'Self-nurturing Strategies',
    subtitle: 'Be kind to yourself',
    icon: Icons.favorite_border,
  ),
  Module(
    title: 'Sleep Strategies',
    subtitle: 'Rest and recover',
    icon: Icons.nightlight_outlined,
  ),
  Module(
    title: 'Reflective Practices',
    subtitle: 'Journaling & mindfulness',
    icon: Icons.self_improvement,
  ),
];

/// Rewards / wellness offers (from the app menu spec).
const List<Reward> kRewards = [
  Reward(
    title: 'Meditation & Mindfulness',
    partner: 'CalmSpace',
    offer: '3 months free',
    icon: Icons.self_improvement,
    color: Color(0xFF7E57C2),
  ),
  Reward(
    title: 'Yoga Classes',
    partner: 'FlowStudio',
    offer: '30% off memberships',
    icon: Icons.accessibility_new,
    color: Color(0xFFAB47BC),
  ),
  Reward(
    title: 'Dance Therapy',
    partner: 'MoveWell',
    offer: 'First class free',
    icon: Icons.music_note_outlined,
    color: Color(0xFFEC407A),
  ),
  Reward(
    title: 'Counseling',
    partner: 'MindCare',
    offer: '2 free sessions',
    icon: Icons.psychology_outlined,
    color: Color(0xFF5C6BC0),
  ),
  Reward(
    title: 'Healthy Cooking & Eating',
    partner: 'FreshPlate',
    offer: '25% off meal kits',
    icon: Icons.restaurant_outlined,
    color: Color(0xFF66BB6A),
  ),
  Reward(
    title: 'Career Development & Coaching',
    partner: 'RiseUp',
    offer: 'Free resume review',
    icon: Icons.trending_up,
    color: Color(0xFF26A69A),
  ),
  Reward(
    title: 'Financial Training',
    partner: 'MoneyWise',
    offer: 'Free budgeting course',
    icon: Icons.savings_outlined,
    color: Color(0xFF42A5F5),
  ),
  Reward(
    title: 'ESL Training',
    partner: 'SpeakEasy',
    offer: '20% off courses',
    icon: Icons.translate,
    color: Color(0xFFFF7043),
  ),
  Reward(
    title: 'Entrepreneurship',
    partner: 'Founders Circle',
    offer: 'Free starter workshop',
    icon: Icons.lightbulb_outline,
    color: Color(0xFFFFB300),
  ),
];
