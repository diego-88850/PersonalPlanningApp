import sys;
import from jaclang.server.bridge {
    BridgeError,
    BridgeRejected,
    BridgeTimeout,
    BridgeUnavailable
}

glob EXIT_OK: int = 0,
     EXIT_FAILURE: int = 1,
     EXIT_USAGE: int = 2,
     EXIT_UNAVAILABLE: int = 3,
     EXIT_TIMEOUT: int = 4,
     EXIT_REJECTED: int = 5;

glob START_HINT: str = "hint: start the server with `jac run web`";

def warn(text: str) {
    sys.stderr.write(text + "\n");
}

def say(text: str) {
    sys.stdout.write(text + "\n");
}

def _suffix(detail: str) -> str {
    return " (" + detail + ")" if detail else "";
}

def explain_bridge_error(e: BridgeError) -> int {
    where = e.app + "." + e.name;
    refused = "Connect call failed" in e.detail;
    if isinstance(e, BridgeUnavailable) or refused {
        warn(
            "upkeep: " + where + " is not reachable"
            + ("" if refused else _suffix(e.detail))
        );
        warn(START_HINT);
        return EXIT_UNAVAILABLE;
    }
    if isinstance(e, BridgeTimeout) {
        warn("upkeep: " + where + " timed out" + _suffix(e.detail));
        return EXIT_TIMEOUT;
    }
    if isinstance(e, BridgeRejected) or "401" in e.detail {
        warn("upkeep: " + where + " rejected the call (not signed in?)");
        warn("hint: sign in with `login <username>` (or `register <username>` first)");
        return EXIT_REJECTED;
    }
    warn("upkeep: " + where + " failed" + _suffix(e.detail));
    return EXIT_FAILURE;
}
