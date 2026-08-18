import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// Shorthand for the generated strings: `context.l10n.safeCallTitle`.
///
/// `AppLocalizations.of` is nullable, but it can only be null when the widget
/// sits outside a `MaterialApp` that registers the delegates — a wiring bug,
/// not a runtime condition to handle. Asserting once here keeps the null-check
/// out of every call site and gives a clearer message than a bare `!`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n {
    final strings = AppLocalizations.of(this);
    assert(
      strings != null,
      'No AppLocalizations found. The widget is not under a MaterialApp with '
      'AppLocalizations.localizationsDelegates — see lib/main.dart.',
    );
    return strings!;
  }
}
