# Kinnav — Requirements & Source Material

Single home for everything that defines the Kinnav app: written specs, the pitch
decks, the backend integration guide, and the annotated app-flow screens.

```
requirements/
├── specs/          Authored specs (source of truth for scope & delivery)
│   ├── REQUIREMENTS.md   Functional (FR) + non-functional (NFR) requirements
│   ├── DESIGN.md         Technical & product design (architecture, how it's built)
│   ├── PLAN.md           7-phase implementation plan + status
│   └── PRODUCTION.md     Field-pilot / go-live runbook + legal-safety gate
├── business/       Pitch decks (vision, personas, model, market)
│   ├── safer-pitch-deck-final.pptx
│   └── safer-pitch-deck-2023.pptx
├── backend/        Org backend integration reference
│   └── americangroupllc-backend-developer-guide.pdf
└── design-flow/    Reference UI screens, ordered by user journey (see map below)
```

## App-flow screen map

Screens are numbered in journey order. "Source" is the original WhatsApp export
filename (kept for traceability).

| File | Screen / what it documents | Source |
|------|----------------------------|--------|
| 01-home-map-guardians-nearby | Home map, guardians-nearby row, CALL GUARDIANS | 9.18.42 AM |
| 02-home-map-guardians-nearby-alt | Home map (variant) | 9.18.42 (1) |
| 03-home-map-region-view | Home map, wider region, guardian pins | 9.18.42 (2) |
| 04-home-coachmark-see-guardians | Coach mark: "you'll see yourself & nearby guardians" | 9.18.42 (3) |
| 05-home-become-guardian-18plus | Prompt: "18+ and wish to become a guardian?" | 9.18.42 (8) |
| 06-home-guardian-map-pins | Branded guardian glyph pins on map | 9.18.42 (9) |
| 07-safecall-map-guardians | Safe Call, guardians converging on map | 9.18.42 (4) |
| 08-safecall-add-police | Safe Call, "add the police to the call" | 9.18.42 (6) |
| 09-safecall-video-grid | Safe Call, video grid + map/video toggle | 9.18.42 (5) |
| 10-safecall-end-thank-guardians | "Back to safety? Thank guardians & end call" | 9.18.42 (7) |
| 11-howto-1-press-a-button | How-it-works step 1: press a button (call types) | 9.19.03 (2) |
| 12-howto-1-press-a-button-alt | Step 1 variant | 9.19.03 (3) |
| 13-howto-2-get-video-call | How-it-works step 2: get a video call | 9.19.03 AM |
| 14-howto-2-get-video-call-alt | Step 2 variant | 9.19.03 (1) |
| 15-support-chat | Support chat ("Hi there! I'm here to help") | 9.18.42 (10) |
| 16-menu-full | Full navigation menu / drawer | 9.18.42 (17) |
| 17-menu-and-rewards-empty | Menu + rewards empty state | 9.18.42 (11) |
| 18-menu-and-rewards-empty-alt | Menu + rewards (variant, shows Version) | 9.18.42 (19) |
| 19-rewards-empty-state | Rewards empty state illustration | 9.18.42 (18) |
| 20-profile | My Profile screen | 9.18.42 (20) |
| 21-about-community-manager | About: Becoming a Community Manager | 9.18.42 (16) |
| 22-about-campus-ambassador | About: Becoming a Campus Ambassador | 9.18.42 (15) |
| 23-about-becoming-partner | About: Becoming a Partner | 9.18.42 (14) |
| 24-about-spreading-word | About: Spreading the word + socials | 9.18.42 (13) |
| 25-about-socials-legal | About: socials, Legal Terms, Privacy Policy, tagline | 9.18.42 (12) |

## Related

- Brand assets (logo, app icon): `../assets/logo/`
- Implementation: `../lib/`
