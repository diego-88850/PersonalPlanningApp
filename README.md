# Upkeep

**Name:** Diego Alonso Coronado
**UMID (University of Michigan ID):** 3033 2549 
**Course:** EECS449, Assignment 1: Personal Planning App in Jac

A personal tracker for the parts of life that sit outside school and work:
daily habits (like taking medicine), gym sessions, weekly goals, and job
applications. It is meant to be lighter than Notion (no databases to design,
no templates to maintain) and more structured than a calendar.

## Main Features

- **Daily check-in:** Add any habit you want (medicine, stretching, reading)
  and check it off each day. One tap, no setup per day.
- **Gym log:** Record what you did in each session (exercises, sets, notes).
- **Weekly goals:** Set a target such as "Gym 4x this week." Progress is
  computed automatically from your check-ins and workout logs, so you never
  update a goal by hand.
- **Job application tracker:** A sortable table of company, position, status
  (Applied, Online Assessment, Interview, Offer, Rejected), date applied, and
  notes.
- **Streaks and progress stats:** Current and longest streak per habit, plus
  weekly completion percentage.

## How the Four Components Fit Together

All four components share one **core** (data models and server functions).
No component contains its own planning logic; each is a view over the same
data.

| Component | Role | Main workflows |
|-----------|------|----------------|
| Server | Source of truth. Stores all data so it persists between sessions. | Habits, check-ins, workouts, goals, applications, stats |
| Web frontend | Full experience, best for planning. | Edit weekly goals, daily view, job tracker table, stats |
| Mobile app | Daily use on the go. | Check-in, log a workout, update job status, view weekly progress (read-only) |
| Command-line interface (CLI) | Fastest way to capture something. | Add an application, log a workout, check off an item, print today's plan |

Because of this, something logged in the terminal appears immediately on the
phone and in the browser.

## Prerequisites

- Jac 0.37.23 (pinned in `jac.toml`). The `jac` binary bundles its own Python
  and Bun, so no separate Python or Node install is needed.
- Mobile in a browser needs nothing else. Running it natively needs an
  emulator or the Expo Go app on a phone.
- Recommended: VS Code with the Jac extension.

## Setup

```bash
git clone https://github.com/diego-88850/PersonalPlanningApp.git
cd PersonalPlanningApp
jac install --npm    # frontend dependencies (jac run also installs them on first start)
```

No API keys or other configuration are needed. On the machine this was built
on, a plain `jac install` failed while creating a Python virtual environment
(an error inside Jac's bundled Python); `jac install --npm` and everything
else worked, and nothing in the project needs the Python-side install.

## Running the Web App and Server

From the repository root:

```bash
jac run web
```

Then open http://localhost:8000 and sign up. The page has three tabs: **Today**
(check off habits, log a workout, step through days), **Goals** (weekly goals
and habit stats) and **Jobs** (a sortable application table). Light by default;
the toggle in the top bar switches to a dark theme.

After editing source files, restart `jac run web`: the dev server's file
watcher does not reliably pick up changes.

The web frontend is served on port 8000 and the
server API on port 8001; both start together. Registration solves a small
proof-of-work challenge and is rate limited (5 accounts per hour).

## Using the Mobile App

The mobile app is written in Jac (no Swift or Kotlin). To try it in a browser:

```bash
jac build mobile --platform web       # once per checkout
jac run --dev --platform web mobile
```

Open http://localhost:8000. It starts its own backend, so you do not need
`jac run web`. Sign in, then use the tabs: **Today** (check off habits, log a
workout), **Jobs** (tap a status to update it) and **Progress** (read-only
weekly progress). `jac run --dev mobile` runs it natively through Expo; a
physical device needs a reachable HTTPS backend. See `mobile/README.md`.

## Using the CLI

With the server running (see `cli/README.md` for details):

```bash
jac run cli -- register diego                         # first time only; later: login diego
jac run cli -- add-habit meds                         # add a habit
jac run cli -- check meds                             # check it off for today
jac run cli -- log-workout "Legs" --details "squat 3x5"
jac run cli -- add-job "Company" "Position"           # add an application (status: Applied)
jac run cli -- today                                  # print today's plan and progress
```

## What Makes This Project Stand Out

- **One core, three interfaces.** Planning logic is written once and reused,
  so all components stay consistent.
- **Built for actual daily use.** Each workflow is placed where it is fastest:
  quick capture in the terminal, daily check-in on the phone, planning and
  tables on the web.
- **Goals that update themselves.** Weekly goals are derived from real
  activity, which makes the streak and progress stats trustworthy rather than
  self-reported.
- **Deliberately small scope.** A few workflows done reliably instead of a
  long feature list.

## Project Structure

```
jac.toml              # apps, dependencies, lint and test config
arch.jac              # every import between project modules (wires) and layering rules
core/
  server.jac          # SERVER: nodes, result objs, all public functions
  rules.jac           # pure date, streak and percentage logic (server only)
  validation.jac      # limits and checks shared by server and clients
  brand/              # warm design tokens shared by web and mobile
  upkeep/             # client side: useUpkeep hook, session, dates
    native/           # mobile screens, components, theme, icons
  site/
    planner/          # web screens: Planner, TodayTab, GoalsTab, JobsTab, AuthForm
    ui/               # shadcn primitives (button, card, input, textarea, badge) and shell
web/                  # web app entry and file-based routes
mobile/               # mobile app entry
cli/                  # command-line interface (main.jac, commands/)
*.test.jac            # tests sit next to the module they test
```

## Testing

```bash
jac check     # type-check and lint every app
jac test      # unit tests: rules, validation, server functions, CLI
```

The server tests call the functions directly; the CLI tests need no server.
Client screens are checked by hand in the browser (see above).
