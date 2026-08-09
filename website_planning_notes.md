# Kinnav Website Planning Notes

> **SUPERSEDED IN PART — 2026-08-08.** This file records the original brief and is
> kept as history. Two things in it no longer hold:
>
> 1. **The product is now "Kinnav"**, not "Safer" (domain `kinnav.com`).
> 2. **The fundraising/nonprofit direction is cancelled.** Kinnav is a product of
>    American Group LLC, a private company — no EmbeddedOS Foundation
>    attribution, no 501(c)(3) status, no donation solicitation. The
>    `/grant-funding` page was removed and replaced by `/waitlist`. Any
>    donation, grant, tax-deductibility, or EmbeddedOS reference below is
>    historical only and must not be reimplemented.
>
> Current state: `PRODUCTION_DEPLOYMENT_GUIDE.md` and `website/README.md`.

## Repository findings

- Repository: `AmericanGroupLLC/Kinnav`
- Current product is a Flutter mobile app for iOS and Android.
- Core positioning from README: an all-in-one women's safety, empowerment, and rewards app.
- Existing app includes live guardian map, guardian call flow, safe call, support chat, empowerment modules, rewards, profile/about/legal areas.
- Existing brand identity uses a purple/lavender color system and shield + crescent logo.
- Requirements and pitch materials are located under `requirements/`, including two pitch decks and many reference UI screenshots.
- The product appears to be a prototype with major production gaps: auth, real maps/GPS, WebRTC, backend, notifications, compliance, and security hardening.

## Content and positioning findings

- Product vision statement: an app that helps women in unsafe situations anywhere, anytime.
- Product differentiation: safety + empowerment + rewards in one experience.
- Important stakeholder groups: users, guardians, NGOs/nonprofits, reward partners, universities/private schools, corporates.
- Guardian model: vetted women within a 10-mile radius, 18+, trained through a 40-hour advocacy course, paid for helping, stay on the call until the user feels safe.
- Monetization mentions: subscription, partner rewards, sponsorship/advertising, institutional adoption.

## Visual findings from viewed assets

### Logo
Source: `assets/logo/kinnav_icon.png`
- Rounded purple app icon.
- White shield centered in the icon.
- Purple crescent moon inside the shield.
- Visual message: protection, safety, nighttime reassurance, calm trust.

### Home map screen
Source: `requirements/design-flow/01-home-map-guardians-nearby.jpeg`
- Mobile UI foregrounds a large map.
- A central guardian/user pin appears on the map.
- Primary CTA is a large glowing purple `CALL GUARDIANS` button.
- Guardian avatars are shown in a horizontal row beneath the CTA.
- UX emphasis is immediate access, clarity, and nearby support.

### Safe call video grid
Source: `requirements/design-flow/09-safecall-video-grid.jpeg`
- Multi-person video interface with a strong human support emphasis.
- Copy bubble references switching between map and video.
- Interface shows practical emergency-call behavior, not just content browsing.
- This screen is valuable for marketing the app's real-world intervention model.

### Menu screen
Source: `requirements/design-flow/16-menu-full.jpeg`
- Soft lavender/white aesthetic.
- Navigation includes invite a friend, become a guardian, my profile, rewards, how to use, and contact.
- The UI suggests the product has both safety utility and community ecosystem elements.

### About/community screen
Source: `requirements/design-flow/21-about-community-manager.jpeg`
- Community language includes becoming a community manager and championing change.
- This supports a broader movement/community framing for the website, not just an app listing.

## Website direction implications

- Website should not be a generic app landing page only; it should also function as:
  - a grant/donation fundraising site,
  - a mission and impact site,
  - a partner/institution pitch site,
  - a product prototype showcase,
  - a support page for the future app ecosystem.
- Strong sections likely needed:
  - mission and safeguarding women narrative,
  - how the guardian model works,
  - prototype/app flow showcase,
  - why funding is needed now,
  - grant-ready impact framing,
  - support for EmbeddedOS as development partner,
  - donation CTA and contact/partnership CTA.
- Design language should inherit the mobile app brand: purple gradients, soft lavender surfaces, trust/safety cues, premium nonprofit-tech presentation.

## Constraints and special requests from user

- Domain: `kinnav.com`
- Website code should be pushed into the same GitHub repository as a separate folder.
- User wants review of all pages/images and expectation/design-flow analysis.
- User wants pitch/niche approach for grants and fundraising.
- User states app source was developed by `https://www.embeddedos.org/` and fundraising should support EmbeddedOS to build the full mobile application.

## Risks / considerations

- Donation/grant messaging must avoid making unverifiable impact claims.
- Need to separate current prototype state from future production roadmap clearly.
- Should avoid implying the safety system is already fully live in production if core backend/call infrastructure is still prototype-stage.
- Need likely pages for Privacy Policy and Terms if website is public-facing.
- Need explicit support contact email preference if used: `support@safecodeg.com` from workspace knowledge.

## Next likely actions

1. Read relevant web development and image generation skills.
2. Initialize a static website project scaffold.
3. Research comparable women-safety and donation/grant site patterns.
4. Build website in a subfolder of the repository.
5. Commit and push to GitHub.
