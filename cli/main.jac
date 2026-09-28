import argparse;
import asyncio;
import sys;
import from jaclang.server.bridge { BridgeError }

glob PROG: str = "upkeep";

obj Invocation {
    has command: str = "";
}

def build_parser -> argparse.ArgumentParser {
    parser = argparse.ArgumentParser(
        prog=PROG, description="The command-line face of Upkeep."
    );
    commands = parser.add_subparsers(
        dest="command", metavar="<command>", required=True
    );
    commands.add_parser("ping", help="check that the server is reachable");
    return parser;
}

def parse_args(argv: list[str]) -> Invocation {
    ns = build_parser().parse_args(argv);
    return Invocation(command=str(getattr(ns, "command", "") or ""));
}

async def dispatch(inv: Invocation) -> int {
    if inv.command == "ping" {
        try {
            result = await ping();
            print(result);
            return EXIT_OK;
        } except BridgeError as e {
            return explain_bridge_error(e);
        }
    }
    warn("upkeep: unknown command " + inv.command);
    return EXIT_USAGE;
}

async def main(argv: list[str]) -> int {
    return await dispatch(parse_args(argv));
}

with entry:__main__ {
    sys.`exit(asyncio.run(main(sys.argv[1:])));
}
