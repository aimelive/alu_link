# LaunchPad ALU 🚀

**Every venture needs a crew.**

LaunchPad ALU is a mission board for the ALU ecosystem. Student-led ventures
launch *missions* (internships and gigs); students build a *crew card* of
skills, see a live *readiness ring* on every mission, request to join, and
track each application along a *flight path* through the review pipeline.

This is a full UI/UX redesign built on top of the original BridgeALU backend:
the Firebase project, Firestore schema, providers, services, and matching
logic are **unchanged**, so both apps read and write the same data.

---

## Concept & UX redesign

| Domain object | BridgeALU | LaunchPad ALU |
|---|---|---|
| Startup / org | Organization | **Venture** (needs "launch clearance" from admin) |
| Opportunity | Opportunity post | **Mission** with a brief |
| Student profile | Profile + skills | **Crew card** with a skill deck |
| Match score | % match badge | **Readiness ring** (circular gauge, signature element) |
| Application status | Colored status chip | **Flight path** stepper: Requested → Shortlisted → Interview → Onboard |
| Admin panel | Verify orgs | **Mission control** clearance desk |

### Visual identity
- **Palette** — "night runway": deep pine `#14453D`, ember amber `#E8862E`,
  warm paper `#F7F3EA`, with full light/dark themes.
- **Type** — Space Grotesk (display) + Manrope (body) via `google_fonts`.
- **Signature elements** — `ReadinessRing` (CustomPainter gauge shown on every
  mission card, mission detail, journey entry, and crew review) and
  `FlightPath` (pipeline stepper shared by students and ventures, so both
  sides see the same stage language).

## Architecture (unchanged backend)

```
lib/
├── models/        # UserModel, StartupModel, OpportunityModel, ApplicationModel  (UNCHANGED)
├── services/      # AuthService: FirebaseAuth + users collection               (UNCHANGED)
├── providers/     # Auth, Opportunity, Application, Startup, Theme, Language   (UNCHANGED)
├── utils/         # MatchCalculator, Departments (UNCHANGED) · app_strings (new copy)
├── theme/         # pad_theme.dart — all design tokens in one place            (NEW)
├── widgets/       # readiness_ring, mission_card, flight_path                  (NEW)
└── screens/       # fully redesigned UI layer                                  (NEW)
    ├── splash_screen · auth_gate · login_screen · signup_screen
    ├── explorer_shell        # student: mission_board_tab · journey_tab · crew_card_tab
    ├── founder_shell         # venture: command_deck_tab · launch_mission_tab · venture_tab
    ├── mission_detail_screen · crew_review_screen
    └── mission_control_screen  # admin clearance
```

**State management:** Provider (`ChangeNotifier`) for session/profile state,
Firestore `snapshots()` streams via `StreamBuilder` for real-time data —
identical to the original app.

**Firestore collections (unchanged):** `users`, `startups`, `opportunities`,
`applications`. Match scores are snapshotted at application time; venture
verification is a live stream on `users/{uid}.verified`.

## Running it

```bash
flutter pub get
flutter run
```

`lib/firebase_options.dart` is carried over from BridgeALU, so the app talks
to the same Firebase project out of the box. The Android `applicationId` and
iOS bundle id were intentionally left unchanged so the existing Firebase app
registrations keep working. i18n (EN/FR) and light/dark themes toggle from
any top bar.

## Roles

- **Student (crew)** — browse the board, filter by department, search, open a
  brief, request to join, track the flight path, manage the skill deck.
- **Venture** — launch missions, review crew sorted by readiness, move
  candidates through the pipeline, close/delete missions, edit venture
  profile, see live clearance status.
- **Admin** — mission control: clear ALU ventures for launch.
