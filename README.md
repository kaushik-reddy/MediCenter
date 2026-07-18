# MediCenter

A medication & health management app, built pixel-for-pixel from the reference
designs in [`image-references/`](image-references). Two front-ends are built in
parallel so nothing drifts between platforms:

- **`web/`** — React + TypeScript + Vite + Tailwind CSS (mobile-focused, iPhone Air).
- **`ios/`** — SwiftUI, iOS 26, Swift Charts.

Data is kept **local** for now (no backend yet). Azure + Gmail sign-in come later.

## Navigation model

Fixed bottom navigation (identical on both platforms):

| Home | Medications | **➕** | Calendar | History |
|------|-------------|-------|----------|---------|

The center **➕** opens the Add Medication flow. **Every other screen**
(Profile, Reminders, Notifications, Inventory, Analytics, Health Insights,
Reports, Doctor Visits, Interaction Checker, Caregiver, Emergency Contacts,
Travel Mode, Settings, …) lives under the **top-left hamburger drawer**, which
is collapsible.

Both **light and dark themes** are wired from the start using a shared token set
(`web/src/index.css` ↔ `ios/MediCenter/Theme/Theme.swift`).

## Run the web app

```pwsh
cd web
npm install
npm run dev
```

Open http://localhost:5173. Use a mobile viewport (or the browser device
toolbar) for the intended iPhone-Air layout.

## Run the iOS app

Requires macOS + Xcode 26 (iOS 26 SDK).

```bash
cd ios
open MediCenter.xcodeproj
```

Select an iPhone simulator and press **Run**. The project uses Xcode's
file-system–synchronized folders, so new Swift files added under
`ios/MediCenter/` are picked up automatically.

## Build status

Foundation complete on both platforms: design tokens, app shell (bottom nav +
hamburger drawer + top bar), theming, and navigable placeholder screens.
Real screens are being built one at a time, in the order requested.

## Deployment

### Vercel (web)

This repo is a monorepo — the web app lives in **`web/`**. In the Vercel project:

1. **Settings → General → Root Directory** → set to `web`.
2. Framework preset auto-detects **Vite** (build `npm run build`, output `dist`).
   SPA routing + cache headers are handled by [`web/vercel.json`](web/vercel.json).
3. **Settings → Environment Variables** — add:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`

   (see [`web/.env.example`](web/.env.example)). Every push to `main` auto-deploys.

### Supabase (database)

Run [`supabase/schema.sql`](supabase/schema.sql) once in the Supabase dashboard:
**Database → SQL Editor → New query → paste → Run**. It creates the
`profiles`, `medications`, `dose_logs`, and `notifications` tables with
Row Level Security and an auto-profile trigger on sign-up.

