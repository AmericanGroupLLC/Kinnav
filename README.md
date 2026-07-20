# Safer 💜

An all-in-one **women's safety, empowerment and rewards** app, built with Flutter
for **iOS and Android**.

> *A new way of women safety and empowerment — an app that helps women in unsafe
> situations, anywhere, anytime.*

## What it does

- **Live guardian map** — see vetted guardians nearby on a stylised map.
- **Call Guardians** — one tap connects you to online guardians.
- **Safe Call** — guardians join a call; switch between a live **map** and a
  **video grid**, add the **police** if needed, and control video/audio.
  Guardians stay with you until you feel safe — no time limit, no judgment.
- **Support chat** — talk to someone now.
- **Self Care & Empowerment modules** — safety planning, self-defense, assertive
  communication, sleep strategies, reflective practices and more.
- **Rewards** — wellness & lifestyle deals (yoga, counseling, dance therapy,
  career/financial/ESL training…).
- **Profile, Guardians, About** — community roles and mission.

## Architecture

```
lib/
├── main.dart                 # app entry + theme
├── theme/app_theme.dart      # brand palette (purple / lavender)
├── models/
│   ├── guardian.dart         # Guardian model + sample data
│   └── content.dart          # modules + rewards data
├── widgets/
│   ├── avatar.dart           # generated initials avatars (no image assets)
│   ├── map_view.dart         # offline stylised map (CustomPainter)
│   └── primary_button.dart   # signature gradient pill
└── screens/
    ├── home_map_screen.dart  # map + CALL GUARDIANS + guardians nearby
    ├── safe_call_screen.dart # map/video toggle, controls, add police
    ├── menu_drawer.dart      # navigation drawer
    ├── chat_screen.dart      # support chat
    ├── guardians_screen.dart # guardians list + become a guardian
    ├── modules_screen.dart   # self care & empowerment
    ├── rewards_screen.dart   # rewards
    ├── profile_screen.dart   # my profile
    └── about_screen.dart     # about us + team
```

The app is intentionally **dependency-light** (Flutter SDK only) and renders its
map and avatars with `CustomPainter` / generated graphics, so it builds and runs
offline in any simulator without API keys.

## Run

```bash
flutter create . --platforms ios,android   # generate native folders (first time)
flutter pub get
flutter run                                 # on a booted simulator/device
```

## Team

- **Shivani** — Founder & Survivor
- **Vishal** — Full Stack Engineer
- **Vanshika** — Marketing & Digital Native

Contact: saferapp3@gmail.com
