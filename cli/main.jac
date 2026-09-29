import argparse;
import asyncio;
import sys;
import from jaclang.server.bridge { BridgeError }

glob PROG: str = "upkeep";

obj Invocation {
    has command: str = "",
        name: str = "",
        position: str = "",
        text: str = "",
        day: str = "",
        undo: bool = False;
}

def build_parser -> argparse.ArgumentParser {
    parser = argparse.ArgumentParser(
        prog=PROG, description="The command-line face of Upkeep."
    );
    commands = parser.add_subparsers(
        dest="command", metavar="<command>", required=True
    );
    commands.add_parser("ping", help="check that the server is reachable");
    commands.add_parser("logout", help="forget the saved login");
    for (cmd, text) in [
        ("login", "sign in and save the token"),
        ("register", "create an account, then sign in")
    ] {
        commands.add_parser(cmd, help=text).add_argument("name", help="username");
    }
    today = commands.add_parser("today", help="print today's plan and progress");
    today.add_argument("--day", `default="", help="YYYY-MM-DD (default: today)");
    habit = commands.add_parser("add-habit", help="add a daily habit");
    habit.add_argument("name");
    check = commands.add_parser("check", help="check off a habit for the day");
    check.add_argument("name", help="habit name (a unique prefix works)");
    check.add_argument("--undo", action="store_true", help="uncheck instead");
    check.add_argument("--day", `default="", help="YYYY-MM-DD (default: today)");
    workout = commands.add_parser("log-workout", help="log a gym session");
    workout.add_argument("name", help="title, e.g. 'Legs'");
    workout.add_argument("--details", dest="text", `default="", help="exercises, sets");
    workout.add_argument("--day", `default="", help="YYYY-MM-DD (default: today)");
    job = commands.add_parser("add-job", help="add a job application (status: Applied)");
    job.add_argument("name", help="company");
    job.add_argument("position");
    job.add_argument("--notes", dest="text", `default="");
    job.add_argument("--day", `default="", help="date applied (default: today)");
    return parser;
}

def parse_args(argv: list[str]) -> Invocation {
    ns = build_parser().parse_args(argv);
    return Invocation(
        command=str(ns.command),
        name=str(getattr(ns, "name", "")),
        position=str(getattr(ns, "position", "")),
        text=str(getattr(ns, "text", "")),
        day=str(getattr(ns, "day", "") or today_str()),
        undo=bool(getattr(ns, "undo", False))
    );
}

async def route(inv: Invocation) -> int {
    if inv.command == "ping" {
        say(await ping());
        return EXIT_OK;
    }
    if inv.command == "login" {
        return run_login(inv.name);
    }
    if inv.command == "register" {
        return run_register(inv.name);
    }
    if inv.command == "logout" {
        return run_logout();
    }
    if inv.command == "today" {
        return await run_today(inv.day);
    }
    if inv.command == "add-habit" {
        return await run_add_habit(inv.name);
    }
    if inv.command == "check" {
        return await run_check(inv.name, inv.day, inv.undo);
    }
    if inv.command == "log-workout" {
        return await run_log_workout(inv.name, inv.day, inv.text);
    }
    if inv.command == "add-job" {
        return await run_add_job(inv.name, inv.position, inv.day, inv.text);
    }
    warn("upkeep: unknown command " + inv.command);
    return EXIT_USAGE;
}

async def dispatch(inv: Invocation) -> int {
    try {
        return await route(inv);
    } except BridgeError as e {
        return explain_bridge_error(e);
    }
}

async def main(argv: list[str]) -> int {
    apply_auth();
    return await dispatch(parse_args(argv));
}

with entry:__main__ {
    sys.`exit(asyncio.run(main(sys.argv[1:])));
}
