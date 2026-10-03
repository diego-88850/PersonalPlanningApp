# Upkeep mobile

The mobile app is written in Jac with `@jac/mobui` (React Native components),
so there is no Swift or Kotlin. `main.jac` renders
`core/upkeep/native/UpkeepMobile.jac`, which uses the same `useUpkeep` hook as
the web app. It is frontend only: it bridges to the server in `core/server.jac`.

Scope (as in the README): check off habits, log a workout, update a job's
status, and read weekly progress. Adding habits, applications and goals is done
on the web app or the CLI.

```bash
jac build mobile --platform web       # once per checkout: the dev preview needs this first
jac run --dev --platform web mobile   # the same screens in a browser (react-native-web)
jac run --dev mobile                  # native through Expo; first run scaffolds .jac/mobile-rn/
jac build mobile --platform web       # browser bundle
```

Without the one-time build, the preview page stays blank on a fresh checkout
(the dev server never emits `.jac/client/mobile/compiled`; seen on jac 0.37.23).
The browser preview starts its own backend (App on :8000, API on :8001), so no
other server is needed. A physical device needs a reachable HTTPS backend, not
localhost.

## Layout

| Path | What it is |
|---|---|
| `core/upkeep/native/UpkeepMobile.jac` | Auth gate, header, banner, tab switch |
| `core/upkeep/native/screens/` | `AuthScreen`, `TodayScreen`, `JobsScreen`, `ProgressScreen` |
| `core/upkeep/native/components/` | `TabBar`, `BridgeBanner`, `EmptyState` |
| `core/upkeep/native/theme.jac` | One `StyleSheet` built from the shared warm tokens |
| `icon.jac` / `icon.native.jac` | Lucide icons for web / native; keep the key sets in sync |

Colours, spacing and radii come from `core/brand/tokens.jac`, shared with the
web app. Only `.jac` primitives are used; raw HTML tags are a compile error in a
mobile app.
