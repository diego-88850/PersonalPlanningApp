# upkeep CLI

`cli/main.jac` is an `argparse` program. Every command is a bridged call to a
function on the server (`core/server.jac`), so the CLI holds no planning logic.
Run it as `jac run cli -- <command>`; everything after `--` is the CLI's argv.

```bash
jac run web                          # terminal 1: start the server (port 8001)
jac run cli -- register diego        # terminal 2: create an account and sign in
jac run cli -- add-habit meds
jac run cli -- check meds            # a unique prefix works: `check me`
jac run cli -- log-workout Legs --details "squat 3x5"
jac run cli -- add-job Acme Intern --notes referral
jac run cli -- today
```

| Command | Does |
|---|---|
| `register <user>` / `login <user>` / `logout` | Account and saved token |
| `add-habit <name>` | New daily habit |
| `check <habit> [--undo] [--day D]` | Check off (or undo) a habit |
| `log-workout <title> [--details T] [--day D]` | Log a gym session |
| `add-job <company> <position> [--notes T] [--day D]` | New application (status Applied) |
| `today [--day D]` | Habits, workouts, goal progress, weekly %; `D` is `YYYY-MM-DD`, default today |
| `ping` | Is the server reachable |

## Identity

`login` and `register` ask for a password (or read `UPKEEP_PASSWORD`),
`POST /user/login`, and save the token to `~/.upkeep/token` (mode 0600). Each
run installs it with `sv_client.set_bearer_token`. The standard
`JAC_BRIDGE_TOKEN` environment variable still wins if it is set. Without any
token the CLI is anonymous and protected calls exit 5.

## Server location

The default is `http://localhost:8001`. Set `UPKEEP_URL` to point elsewhere; the
CLI derives `JAC_APP_SERVER_URL` (`<UPKEEP_URL>/api/server`) from it unless you
set that variable yourself.

## Exit codes

0 ok, 1 the server said no (bad input, unknown habit), 2 usage, 3 server
unreachable, 4 timeout, 5 not signed in. Hints go to stderr; stdout stays clean
for piping.

## Layout

| Path | What it is |
|---|---|
| `main.jac` | Parser, `Invocation`, `route`, `dispatch`; the `__main__` guard lets tests import it |
| `commands/plan.jac` | Habit, workout, job and `today` commands, plus the pure `match_habits` and `render_today` |
| `commands/auth.jac` | `login`, `register`, `logout`, token file, proof-of-work solver |
| `commands/common.jac` | Exit codes, `say`, `warn`, `explain_bridge_error` |

Imports between modules are wires in `arch.jac`, not lines in the files.
`jac test cli` runs the annexes beside each module; none of them need a server.
