# Upkeep mobile

React Native face of Upkeep through `@jac/mobui`. Frontend only: it needs a
reachable server, and a physical device needs a real HTTPS URL, not localhost.

```bash
jac run --dev mobile                  # first run scaffolds the Expo project
jac run --dev --platform web mobile   # same UI in a browser
```

Platform-specific modules use file variants (`icon.jac` / `icon.native.jac`).
