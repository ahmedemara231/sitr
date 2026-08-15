Redesign the **two attached mobile screens** using the attached **Design System MD as the single source of truth for the visual language**.

The current screenshots are functional references only. Do **not** simply polish the existing layout. Re-think the visual hierarchy, spacing, card structure, typography, and information grouping so the screens feel significantly more modern, premium, clean, and consistent with the Satr design system.

## General Requirements

* Design for **Arabic RTL first**.
* Reference mobile frame: **375 × 812 px**.
* Keep all existing information and functionality.
* Do not remove any existing data fields.
* Do not invent new business features.
* You may reorganize existing information when it improves readability.
* Use the existing navigation structure.
* The final two screens must clearly look like parts of the same application and design system.
* Avoid generic marketplace UI or overly colorful designs.
* The experience should feel elegant, trustworthy, premium, calm, and suitable for a matchmaking/social-profile application.

## Design System

Use these visual rules consistently:

### Colors

* Primary brand color: **#A66D09**
* Main background: **#FCFCFC**
* Secondary/header background: **#F7F4F3**
* Cards/surfaces: **#FFFFFF**
* Inactive/light surfaces: **#F6F6F6**
* Main heading text: **#272727**
* Strong body text: **#3A3A3A**
* Secondary/meta text: **#525252**
* Border/divider: **#EEEEEE**

Use the primary gold carefully as an accent. Do not make large parts of the screen gold.

### Typography

Use **Tajawal** throughout.

Suggested hierarchy:

* Screen title: 18px Bold
* Profile name / major emphasis: 18–20px Bold
* Card labels / body text: 14px Medium
* Secondary information: 12px Regular/Medium
* Metadata: 10–12px Regular

Create a clear hierarchy between:

1. Profile name
2. Important profile information
3. Secondary metadata
4. Supporting icons

### Spacing & Shape

* Main horizontal page padding: **16px**
* Prefer 8px / 12px / 16px spacing rhythm
* Main card radius: **12px**
* Large header containers may use radius around **15px**
* Chips and badges should be highly rounded
* Use very subtle shadows, not heavy floating cards
* Keep the interface airy and avoid unnecessary separators

---

# SCREEN 1 — Profile List / Home Results

Redesign the first attached screenshot containing the vertical list of profiles.

The current card contains:

* Profile image
* Profile name
* Premium/member badge when available
* City/location
* Age
* Weight
* Height
* Marital/social status
* Some records may contain null or unavailable values

## New Card Direction

Create a much cleaner reusable **Profile Card**.

### Card structure

Use a white card with approximately 12px radius and a very subtle shadow.

Because the interface is RTL:

* Profile image should remain visually anchored on the **right/trailing side**
* Main profile information should fill the remaining area
* Name should be the strongest visual element
* Premium status should appear as a compact elegant badge near the name, not compete with the profile name

Use a clear two-level information hierarchy.

### Top section

Show:

* Profile image
* Profile name
* Premium badge when applicable
* City/location as a secondary line

The image should feel more premium:

* Rounded rectangle
* approximately 72–80px
* 10–12px corner radius
* consistent size on every card

### Metadata section

Instead of placing many disconnected icons randomly, organize profile attributes into a consistent compact structure.

Suggested arrangement:

**Row 1**

* Age
* Height
* Weight

**Row 2**

* Marital status
* Location if necessary

Each metadata item may use:

* a very small icon
* the value
* a subtle label only when necessary

Icons must support scanning rather than dominate the card.

Do not make every piece of data visually equal.

### Null values

Do **not** show text such as:

`null كجم`
or
`null سم`

If a field is unavailable, show an elegant neutral placeholder such as:

`—`

or hide the value while preserving balanced card spacing.

### Premium Badge

Redesign the current "عضو مميز" badge.

It should:

* use the app gold primary color
* have a subtle light background or thin outline
* use a small premium/medal icon
* remain compact
* not overpower the person's name

### List rhythm

Increase visual breathing room between cards.

Cards should feel consistent and easy to scan quickly.

Keep enough information visible without making each card overly tall.

---

# SCREEN 2 — Profile Details

Completely redesign the second attached screenshot.

The current design displays profile attributes as a large two-column grid of individual rounded white containers.

This creates too many separate visual boxes and makes the screen feel repetitive.

Replace this with a more intentional **Profile Details architecture**.

## Header / Identity Section

Add a clear profile header at the top.

It should contain:

* Profile image/avatar
* Profile name
* Premium badge if applicable
* Main high-level information such as:

  * age
  * city/location
  * marital status

Use a subtle light header area using the design-system secondary background.

The header should immediately communicate the person's identity before showing detailed attributes.

---

## Information Sections

Group related attributes semantically instead of presenting every field as an unrelated card.

Suggested sections:

### المعلومات الأساسية

* العمر
* الطول
* الوزن
* اللون / البشرة
* المدينة

### الحالة الاجتماعية والعائلية

* الحالة الاجتماعية
* هل يوجد أطفال
* عدد الأبناء
* حضانة الأطفال

### التعليم والعمل

* المؤهل الدراسي
* الوظيفة الحالية

### تفضيلات الزواج

* هل توجد رغبة بالإنجاب
* نوع حفلة الزواج
* المهر

### معلومات إضافية

* هل تدخن
* هل تصلي

Do not invent fields; use only available profile data.

---

## Detail Row Component

Inside each section, create a reusable detail-row component.

Preferred structure:

* small circular tinted icon container
* field label in subtle gray
* field value with stronger typography

Use white section cards with:

* 12px radius
* subtle border/shadow
* internal spacing around 12–16px

Avoid wrapping every individual property inside a giant pill.

A section may contain multiple rows separated by:

* spacing
  or
* extremely subtle dividers

This should make the page significantly easier to scan.

---

## Two-column usage

Use two columns only for very short related values, such as:

* العمر / الطول
* الوزن / اللون

Do not force every property into a two-column layout.

Longer values such as:

* qualification
* job
* marriage preferences

should use the full width.

This will prevent Arabic text from feeling cramped.

---

## Icons

Keep the existing semantic concept of icons but redesign their presentation.

Use:

* small icons
* light circular backgrounds
* consistent icon size
* consistent visual weight

Avoid emoji-like, oversized, or visually inconsistent icons.

Icons should support the content rather than become the main visual focus.

---

# Bottom Navigation

Preserve the existing bottom navigation structure.

RTL order:

**الرئيسية · الاشعارات · الرسائل · الباقات · المزيد**

For the first screen:

* **الرئيسية** is active.

Use:

* primary gold for active icon and label
* dark gray for inactive items
* a subtle active indicator
* white background
* soft top shadow

Do not redesign it into a completely different navigation pattern.

---

# UX Improvements

Pay special attention to:

* Better Arabic RTL alignment
* Stronger information hierarchy
* More whitespace
* Fewer unnecessary containers
* Consistent icon treatment
* Better handling of long Arabic values
* Better handling of missing/null values
* Clear relationship between list card and detail screen
* Consistent spacing and component reuse
* Premium but minimal visual style

When the user taps a profile card in Screen 1, Screen 2 should feel like the natural expanded version of that exact card.

---

# Important Constraints

DO NOT:

* Change the app branding.
* Change the primary color.
* Use gradients unless extremely subtle and justified.
* Introduce random colors.
* Use excessive shadows.
* use glassmorphism.
* make the design overly decorative.
* remove fields from the current UI.
* change Arabic content to English.
* use LTR layouts.
* redesign the bottom navigation into a different navigation system.
* place every profile attribute inside a separate oversized pill.
* show `null` as a user-facing value.

---

# Expected Figma Make Output

Create polished high-fidelity redesigns for **both attached screens**:

1. **Profile List / Home Results**
2. **Profile Details**

Also create reusable components for:

* Profile Card
* Premium Badge
* Metadata Item
* Detail Section
* Detail Row
* Circular Icon Container

Maintain consistent spacing, typography, color, radius, icon sizing, and RTL behavior across both screens.

The final result should feel substantially more professional than the current screenshots while clearly belonging to the existing Satr application and its supplied design system.
