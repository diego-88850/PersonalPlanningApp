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

- Jac (version: TODO(verify), e.g. the version from the course setup)
- Python TODO(verify) version
- For mobile: TODO(verify) (e.g. Node.js plus an emulator or the Expo Go app)
- Recommended: VS Code with the Jac extension

## Setup

```bash
git clone [your repo URL]
cd [repo folder]
jac install          # TODO(verify): the dependency install command
```

Optional configuration (TODO(verify): if you use AI features or API keys):

```bash
export [KEY_NAME]=your-key-here
```

## Running the Web App and Server

From the repository root:

```bash
jac run
```

Then open the URL printed in the terminal (TODO(verify): usually
`http://localhost:XXXX`). The server and web frontend start together.

## Using the Mobile App

1. Make sure the server above is running.
2. TODO(verify): command to launch the mobile app, for example:
```bash
   cd mobile && jac start --client android   # placeholder
```
3. TODO(verify): how the phone or emulator finds the server (same Wi-Fi and
   the computer's local IP address, or an emulator alias).
4. Use the tabs to check in on habits, log a workout, update an application's
   status, and view weekly progress.

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
jac.toml     # project configuration (default app set for `jac run`)
core/        # shared data models and server functions
web/         # browser frontend
mobile/      # mobile app
cli/         # command-line interface
```

(TODO(verify): match this to the real layout after scaffolding.)
