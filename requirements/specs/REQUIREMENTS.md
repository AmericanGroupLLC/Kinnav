# Safer — Requirements Document

_Source material: `Final Safer Slide Deck.pptx`, `Safer Slide Deck 2023.pptx`, and 26 reference UI screenshots._

## 1. Product Vision

**Safer** is an all-in-one **Women's Safety + Empowerment + Rewards** app.

> _"A new way of women safety and empowerment — an app that helps women in unsafe
> situations, anywhere, anytime."_
> _"It's easier to look forward when you don't have to watch your back."_

The differentiator ("sweet spot") is **all-in-one**: Safety **+** Empowerment/Self-Care **+** Rewards, versus competitors that do only one (bSafe/Noonlight for safety, Unidays/Drop for rewards, InnerHour for wellness).

## 2. Personas & Roles

| Role | Description |
|---|---|
| **User** | Women in unsafe situations (e.g. "Ashleigh", 22, student, runs early mornings, shops at night, bar-hops Fridays). |
| **Guardian** | Vetted women within a 10-mile radius, sourced from NGOs/advocacy groups. Complete a **40-hour advocacy course** (virtual, NGO-trained). Speak to users **until they feel safe — no time limit, no judgment**. **Get paid** for helping. Must be **18+**. |
| **NGO / Nonprofit volunteer** | Create self-empowerment content; earn revenue per-click/impression. |
| **Reward Partner** | Lifestyle/wellness brands providing discounts & classes. |
| **Customers** | Universities/private schools (campus safety), corporates (employee programs). |
| **Community roles** | Community Manager, Campus Ambassador, Rewards Provider, Partner. |

## 3. Functional Requirements

### FR-1 Authentication & Onboarding
- FR-1.1 Sign up / log in (phone or email + verification).
- FR-1.2 **Age gate**: confirm 18+ (required for guardians; users too per deck).
- FR-1.3 First-run **How-to-Use** walkthrough (Press a button → video call → guardians stay → back to safety).
- FR-1.4 Profile setup: name, month/year of birth, gender identity ("I define myself as"), spoken languages, photo.
- FR-1.5 Log out; delete account; request profile edit.

### FR-2 Home / Live Map
- FR-2.1 Show the user's live location on a map.
- FR-2.2 Show **guardians nearby** as branded glyph pins + an avatar row with online status and total count (e.g. "+63").
- FR-2.3 Prominent **CALL GUARDIANS** action.
- FR-2.4 Top bar: menu (drawer) + support chat.
- FR-2.5 First-run coach mark: "You will see yourself and nearby guardians on the map".

### FR-3 Reaching Guardians (Call Flow)
- FR-3.1 Choose contact method: **Voice Call, Video Call, Text Message, Emergency**.
- FR-3.2 Slide-to-activate to start.
- FR-3.3 Emergency escalates immediately (video + police).

### FR-4 Safe Call
- FR-4.1 Connect the user to nearby online guardians (multi-party).
- FR-4.2 **Map view** showing guardians' avatars converging on the user's location, with distance.
- FR-4.3 **Video grid** view; toggle between **map ⇄ video**.
- FR-4.4 **Add police** to the call if needed.
- FR-4.5 Call controls: start/stop video, mute/speaker, hang up.
- FR-4.6 Live call timer.
- FR-4.7 Coach marks: add police / switch map-video / "Back to safety? Thank your guardians and end the call".
- FR-4.8 Notify the user's **Safety Contacts** with live location when a call starts.

### FR-5 Guardians
- FR-5.1 Browse guardians (name, distance, languages, online status).
- FR-5.2 **Become a Guardian**: 18+ eligibility → apply → 40-hour course enrollment/tracking → verification.
- FR-5.3 Guardian reward program (paid for helping).

### FR-6 Self Care & Empowerment Modules
Modules (each with lessons/content):
- Safety Planning (Types of abuse, Emotional safety, Physical safety, Future without fear)
- Self Defense techniques · Workforce Professionalism · Tech Abuse Awareness
- Assertive Communication & Boundaries · Low-cost Self Care · Self-nurturing strategies
- Sleep Strategies · Reflective Practices
- FR-6.1 List modules; open module detail with lessons.
- FR-6.2 Track progress / completion.

### FR-7 Rewards
- FR-7.1 Browse wellness/lifestyle offers: Meditation & Mindfulness, Yoga, Dance Therapy, Counseling, Healthy Cooking, Visual Arts & Theater, Career Development & Coaching, ESL Training, Financial Training, Computer/Software Skills, Entrepreneurship.
- FR-7.2 Redeem an offer; show redeemed state; empty state ("You have no rewards to redeem…").
- FR-7.3 Referral / Invite-a-Friend rewards.

### FR-8 Support Chat
- FR-8.1 In-app chat with helpers; quick replies; "typically replies in under 5m".

### FR-9 Safety Contacts
- FR-9.1 Add/remove personal trusted contacts (name, phone, relation).
- FR-9.2 Notified with live location on a Safe Call.

### FR-10 Menu / About / Legal
- FR-10.1 Menu: Invite a Friend, Become a Guardian, My Profile, My Safety Contacts, Self Care & Empowerment, Rewards, How to Use, Contact Us, Feedback, About Us, Log out, version.
- FR-10.2 About: mission, community roles, team, socials (IG/FB/X/site/email), **Legal Terms**, **Privacy Policy**, tagline.
- FR-10.3 Feedback (rating + notes); Contact Us.

### FR-11 Subscription & Monetization
- FR-11.1 Subscription: **$3.99/month** or **$39.99/year**; waiting-list/early-access CTA.
- FR-11.2 In-app purchases (App Store / Play).
- FR-11.3 Reward-partner usage/advertising/sponsorship revenue hooks.

## 4. Non-Functional Requirements

- **NFR-1 Reliability/Safety**: Safe Call must connect fast and work when the app is backgrounded; emergency path must be robust. Life-safety product — requires legal & safety review.
- **NFR-2 Location**: foreground + **background location**; permissions; battery-aware.
- **NFR-3 Real-time**: multi-party **voice/video** (WebRTC/Twilio/Agora) + presence.
- **NFR-4 Push notifications**: alert guardians when off-app; alert safety contacts.
- **NFR-5 Backend**: auth, users/guardians, calls, geo-queries, content, rewards, payments.
- **NFR-6 Security/Privacy**: encryption in transit/at rest, PII minimization, GDPR/CCPA, real Legal/Privacy docs.
- **NFR-7 Accessibility**: WCAG, large tap targets, screen-reader labels, high contrast.
- **NFR-8 Internationalization**: multi-language (guardians match user languages).
- **NFR-9 Quality**: automated tests, CI/CD, crash reporting, analytics.
- **NFR-10 Platforms**: iOS + Android (Flutter), phones (portrait-first).

## 5. Current Status vs. Requirements (gap summary)

| Area | Built (prototype) | Gap to production |
|---|---|---|
| UI/screens | ✅ All key screens | polish, module detail, subscription |
| Navigation/IA | ✅ Complete | — |
| Auth/onboarding | ❌ none | signup, age gate, profile setup, session |
| Persistence | ❌ in-memory | local store + backend sync |
| Map/location | ⚠️ stylised fake map | real maps + GPS + background location |
| Safe Call | ⚠️ simulated | real WebRTC voice/video + presence |
| Emergency/police | ⚠️ snackbar | real dialing + legal review |
| Guardians | ⚠️ sample data | vetting workflow + backend |
| Rewards | ⚠️ static | redemption + partners + payments |
| Notifications | ❌ none | push (guardians + contacts) |
| Security/privacy | ❌ none | encryption, compliance, legal docs |
| Tests/CI | ⚠️ 1 smoke test | full suite + CI/CD |

See `PLAN.md` for the phased implementation plan.
