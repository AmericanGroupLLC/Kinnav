/// The signed-in member's profile.
class UserProfile {
  final String name;
  final int birthMonth; // 1-12
  final int birthYear;
  final String identity; // e.g. "Woman"
  final List<String> languages;
  final bool isGuardian;

  /// Local filesystem path to a chosen avatar image, or null for initials.
  final String? avatarPath;

  const UserProfile({
    required this.name,
    required this.birthMonth,
    required this.birthYear,
    this.identity = 'Woman',
    this.languages = const ['English'],
    this.isGuardian = false,
    this.avatarPath,
  });

  /// Age in whole years, computed from birth year/month against a reference date.
  int ageAsOf(DateTime now) {
    var age = now.year - birthYear;
    if (now.month < birthMonth) age -= 1;
    return age;
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  UserProfile copyWith({
    String? name,
    int? birthMonth,
    int? birthYear,
    String? identity,
    List<String>? languages,
    bool? isGuardian,
    String? avatarPath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      birthMonth: birthMonth ?? this.birthMonth,
      birthYear: birthYear ?? this.birthYear,
      identity: identity ?? this.identity,
      languages: languages ?? this.languages,
      isGuardian: isGuardian ?? this.isGuardian,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'birthMonth': birthMonth,
        'birthYear': birthYear,
        'identity': identity,
        'languages': languages,
        'isGuardian': isGuardian,
        'avatarPath': avatarPath,
      };

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        name: j['name'] as String? ?? '',
        birthMonth: j['birthMonth'] as int? ?? 1,
        birthYear: j['birthYear'] as int? ?? 2000,
        identity: j['identity'] as String? ?? 'Woman',
        languages:
            (j['languages'] as List<dynamic>?)?.cast<String>() ?? const ['English'],
        isGuardian: j['isGuardian'] as bool? ?? false,
        avatarPath: j['avatarPath'] as String?,
      );
}
