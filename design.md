# Design System — Satr (سِتر)

The general visual language for the app, extracted from Figma file
`s9QmhNNydNNXmi0zDY2bmi` (مساعد الجهني) and reconciled with the existing
codebase. Every screen in the app should follow this — the Home and More
screens at the end are **worked examples**, not the scope.

The app is **RTL-first (Arabic)**. Reference frame: 375×812 (iPhone 13 mini).
Always size with `.w / .h / .sp`, never raw pixels (CLAUDE.md). Use
`PositionedDirectional`, `EdgeInsetsDirectional`, and the RTL-aware padding
extensions — never hardcode left/right.

---

## 1. Color Tokens

All colors already exist in `lib/src/config/res/color_manager.dart`
(`AppColors`). Use the constant — never an inline `Color(0x...)`.

| Role | Figma | `AppColors` constant |
|---|---|---|
| Brand primary (buttons, active nav, banners) | `#A66D09` | `AppColors.primary` |
| Primary dark (balance card inner, accents) | `#B47200` | `AppColors.darkGoldenRod` |
| Scaffold background | `#FCFCFC` | `AppColors.whiteScaffoldBackground` |
| Header / section background | `#F7F4F3` | `AppColors.whiteGreyColor` / `scaffoldBackground` |
| Surface (cards, pills) | `#FFFFFF` | `AppColors.white` |
| Field / inactive chip background | `#F6F6F6` | `AppColors.whiteGrey` (≈`#EEEEEE`) |
| Heading text | `#272727` | `AppColors.textBlack` |
| Strong body text | `#3A3A3A` | `AppColors.darkGray` |
| Secondary / meta text | `#525252` | `AppColors.darkGay` |
| Inactive nav label | `#4F4F4F` | `AppColors.unSelectedLabelColor` |
| Border / divider | `#EEEEEE` | `AppColors.border` |
| Error / destructive | `#D92D20` | `AppColors.error` |

If a Figma color has no constant, **add it to `AppColors`** rather than
inlining it.

---

## 2. Typography

- **Family:** `Tajawal` (the app font) for all UI/body text.
  `29LT Kaff` appears only on the balance card — treat as a one-off, do not
  generalize.
- **Weights:** Regular (400), Medium (500), Bold (700).
- **Always** render text through `AppText` (`core/widgets/app_text.dart`) and
  the `TextStyle` extensions (`.bold`, `.semiBold`, `.medium`, `.s16`,
  `.primaryColor`, `.setFontSize(n)`) — never inline `TextStyle`.
- **Always** feed it a `LocaleKeys.*` key — never a hardcoded string.

Type scale observed across screens:

| Use | Size | Weight |
|---|---|---|
| Screen title | 18 | Bold |
| User name / card emphasis | 20 / 12 | Bold |
| Body / row label | 14 | Medium |
| Greeting / nav label | 12–13 | Regular / Medium |
| Meta (city, age, etc.) | 10 | Regular |

---

## 3. Spacing, Radius, Elevation

- **Screen gutter:** 16 horizontal (`.paddingSymmetric(horizontal: 16)`).
- **Spacing between stacked elements:** use `16.szH` / `8.szH` etc., not raw
  `SizedBox`.
- **Radii:**
  - Pill / primary button / list row → `50`
  - Card (person card, content card) → `12`
  - Banner → `10`; large header block → `15`
  - Chip / small toggle → `~18`
- **Shadows:**
  - List-row pill: `0 0 22 3 rgba(0,0,0,0.02)` — barely-there lift
  - Content / person card: `0 3 64 0 rgba(0,0,0,0.06)`
  - Bottom nav top edge: `0 -4 32 0 rgba(0,0,0,0.10)` (≈ existing
    `Offset(0,-1)` blur 12 @ 0.25 in `home_screen.dart`)

---

## 4. Reusable Component Patterns

These are the building blocks. Build each **once** in `core/widgets/` (or
the feature `widgets/` folder) and reuse — never copy-paste a visual
structure (CLAUDE.md Rules 28, 31, 34).

### 4.1 Pill row (list item / menu entry)
White, full-width, ~54h, radius 50, faint shadow. RTL layout:
`leading chevron (start/left) · label (right, 14 Medium) · circular tinted
icon (far end, ~35)`. Whole row tappable → `Go.to(...)`. Build from a typed
list of `(label, icon, onTap)` entries.

### 4.2 Primary / secondary button
Same pill shape, ~54h, radius 50.
- Primary: `AppColors.primary` bg, white text.
- Secondary: white bg, black text.
Centered `AppText`, 12–14 Medium.

### 4.3 Segmented toggle (2 options)
Two rounded chips (~40h, radius ~18). Active = `AppColors.primary` + white
text; inactive = `AppColors.whiteGrey` + black text. Parent owns the
selected value; child takes `onChanged` callback (CLAUDE.md Rule 29).

### 4.4 Content / person card
White, radius 12, card shadow. RTL: image block on the trailing side
(rounded 8), then title (12 Bold), rating row, and icon+label meta lines
(10 Regular, `AppColors.darkGay`). Pass only the fields the card shows
(Rule 31). Render lists with `items.indexedMap(...)`.

### 4.5 Section header block
Background `AppColors.whiteGreyColor`, rounded bottom (15). Centered title
(18 Bold, `AppColors.textBlack`); circular 40px white icon-buttons at the
top corners (RTL — actions lead from the start side).

### 4.6 Promo / hero banner
Full-width image card (radius 10) inside the header, with a centered dot
pager (active dot `AppColors.primary`, inactive muted).

### 4.7 Circular icon chip
~35–40px circle, light tinted fill, centered `IconWidget`
(`core/widgets/icon_widget.dart`) using an SVG from `Assets.*`. Used as the
trailing affordance on rows and as header buttons.

### 4.8 Bottom navigation bar
Already implemented in `home_screen.dart` (5 fixed tabs, active =
`AppColors.primary`, inactive = `AppColors.unSelectedLabelColor`, sliding
underline indicator, badge support). **Reuse it** — do not re-create per
screen. Order (RTL): الرئيسية · الاشعارات · الرسائل · الباقات · المزيد.

---

## 5. Conventions (recap from CLAUDE.md — non-negotiable)

- Strings → `LocaleKeys.*`; add new ones to `assets/translations/lang.json`
  using `"camelCaseKey #$ English Display"` then run `make translations`.
- Navigation → `Go` class only.
- Network-backed lists/state → `AsyncCubit`; pure UI state → `StatefulWidget`
  (Rules 22–27).
- Screen file = scaffold + layout only; every section is its own widget in
  `widgets/` (Rules 28, 35).
- Colors via `AppColors`, text via `AppText` + style extensions, icons via
  `IconWidget` + `Assets.*`.

---

## 6. Worked Examples

### 6.1 Home (`الرئيسية`) · node `57:801`
Header block (avatar + two-line greeting + promo banner with dot pager) →
two action buttons (4.2: primary "البحث عن شريك الحياة", secondary
"المستشارين وخدمات الافراح") → segmented toggle (4.3: انثى / اولياء الامور)
→ vertical list of person cards (4.4). Person list comes from an
`AsyncCubit`. Bottom nav (4.8) with **الرئيسية** active.

### 6.2 More (`المزيد`) · node `69:1163`
Header (4.5: title المزيد, settings/login circular buttons) → balance card
(`AppColors.primary` band + `AppColors.darkGoldenRod` inner card, wallet
icon, white "رصيدي" pill) → list of pill rows (4.1):

| Label | Icon |
|---|---|
| عرض بيانات الملف الشخصي | User |
| باقتي | Question square |
| شركاء النجاح | Chat line |
| العملاء المحظورين | User block |
| تواصل معنا | Call |
| الشكاوي والاقتراحات | Call cancel |
| من نحن | Info circle |
| الشروط والاحكام | File |

Each row → `Go.to(...)`. Bottom nav (4.8) with **المزيد** active.

### Translation keys for the examples

```json
"findLifePartner #$ Find a life partner": "البحث عن شريك الحياة",
"consultantsAndWeddingServices #$ Consultants & wedding services": "المستشارين وخدمات الافراح",
"female #$ Female": "انثى",
"guardians #$ Guardians": "اولياء الامور",
"greeting #$ Hello ,": "مرحبا ,",
"yourBalance #$ Your balance": "رصيدك",
"myBalance #$ My balance": "رصيدي",
"viewProfileData #$ View profile data": "عرض بيانات الملف الشخصي",
"myPackage #$ My package": "باقتي",
"successPartners #$ Success partners": "شركاء النجاح",
"blockedClients #$ Blocked clients": "العملاء المحظورين",
"contactUs #$ Contact us": "تواصل معنا",
"complaintsAndSuggestions #$ Complaints & suggestions": "الشكاوي والاقتراحات",
"aboutUs #$ About us": "من نحن",
"termsAndConditions #$ Terms & conditions": "الشروط والاحكام"
```
(`home`, `notifications`, `chats`, `packages`, `more` already exist.)
