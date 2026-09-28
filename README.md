# PRISM AUTO

Flutter project for PRISM AUTO — the self-serve AI repurposing module —
built from `PRISM_AUTO_Product_and_Frontend_Spec.docx`. Screens only, mock
data only, no API calls, per Section 5 of the spec. A separate API contract
will follow once these screens are reviewed.

## What's here

Every screen and building block from Section 6 of the spec:

- **Theme tokens** (`lib/core/theme/`) — `AppColors`, `AppTextStyles`,
  `AppSpacing`, `AppTheme`, written to match Section 2 of the spec exactly
  (hex values, font roles, zero radius, spacing scale). The spec says these
  should be copied byte-for-byte from `prism_appbloc`'s real source — I
  don't have that repo, so these are recreated from the spec's written
  description. **Before you build on this, swap in the real files from
  prism_appbloc** so the two projects can't drift (see Build Notes below).
- **Shared widgets** (`lib/widgets/common/`) — `PrismButton`, `PrismCard`,
  `PrismBadge`, `PrismInput`, `PrismLoader`, `PrismError`, `StatCard`,
  `PrismLabel`, `PrismSidebar` / `PrismBottomNav`, plus `DashedBorderBox`
  (a `CustomPainter` for the Upload drop zone, since Flutter has no native
  dashed border). Same caveat as above — replace with the real
  `widgets/common/` from prism_appbloc if you have it.
- **Models, mock repository, BLoCs** (`lib/models/`, `lib/repositories/`,
  `lib/blocs/`) — `UploadBloc`, `ProcessingBloc`, `ResultsBloc`,
  `EditorBloc`, `LibraryBloc`, matching the events/states named in the
  spec. `MockAutoRepository` simulates upload progress and processing
  steps with `Future.delayed`/`Stream`.
- **All 8 screens** (`lib/screens/`) — Upload, Processing, Results (clip
  gallery), Clip Editor, Captions & Posts, Export, Library, Plans &
  Billing — plus `AutoShell` (sidebar desktop / bottom nav mobile,
  breakpoint at 720px, matching AdminShell's structure).

## What's simplified (flagged, not hidden)

The spec calls out video preview/playback, waveform rendering, and the
trim slider as "the three genuinely hard frontend pieces." I did not wire
in a real video package, since that needs an actual media file and a
package decision (`video_player`, `chewie`, etc.) that's yours to make.
Standing in for them right now:

- **Video preview** (Results thumbnails, Clip Editor) — a plain
  `bgVoid`/`bgSurface` colored box in the right aspect ratio.
- **Waveform** (Processing screen) — an animated bar-pulse, not a real
  audio waveform.
- **Trim slider** — a functional `RangeSlider` styled to spec (Cyan
  handles, mono timestamp readout), not a custom scrubber with a
  filmstrip. Swap in a real one once you've picked a video package —
  most (e.g. `video_player` + `chewie`) expose the frame data you'd want
  for a filmstrip background.

Also simplified: the persistent "processing in progress" indicator the
spec describes living in the shell's top bar/sidebar footer while the
user navigates away isn't wired up (Processing screen runs as its own
route rather than a background task the shell polls). And plan-upgrade,
copy-to-clipboard, share, and download buttons are stubbed with empty
`onPressed` handlers — real ones need the API contract.

## Setup

This container doesn't have the Flutter SDK installed (it's normally
fetched from Google Cloud Storage, which isn't reachable from here), so I
wrote every file in `lib/` and `pubspec.yaml` by hand rather than
generating them with `flutter create` — meaning the platform folders
(`android/`, `ios/`, `web/`, etc.) don't exist yet, and none of this has
been run through `flutter analyze` or a real build. To get it running:

```bash
# 1. Unzip this project, cd into it
cd prism_auto

# 2. Scaffold the platform folders (android/ios/web/etc.) without
#    touching lib/ or pubspec.yaml — flutter create is safe to run
#    on an existing project, it only adds what's missing
flutter create .

# 3. Fetch dependencies
flutter pub get

# 4. Run (pick a device/target)
flutter run -d chrome     # or -d macos / an emulator / a connected device
```

If `flutter create .` ever complains about the existing `pubspec.yaml`,
that's expected — it will leave it alone since the file already exists;
just proceed to `flutter pub get`.

## Build order

Per Section 7 of the spec: Upload → Processing → Library → Results →
Captions & Posts → Editor → Export → Plans & Billing. All 8 are built
here; that's the order to review them in.
