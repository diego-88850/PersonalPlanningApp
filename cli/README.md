# upkeep CLI

`cli/main.jac` is an `argparse` program. Each command is a bridged call to a
walker on the server (`core/server.jac`), so the CLI never holds planning logic.

```bash
jac run web                 # start the server (terminal 1)
jac run cli -- ping         # terminal 2; everything after -- is the CLI's argv
jac test cli
```

`cli/commands/common.jac` maps bridge failures to exit codes 3 (unreachable),
4 (timeout) and 5 (rejected) and prints a hint on stderr, keeping stdout clean
for piping. Set `JAC_BRIDGE_TOKEN` to a token from `POST /user/login` to act as
a signed-in user; without it the CLI is a fresh anonymous user.
