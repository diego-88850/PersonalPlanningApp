import io;
import from contextlib { redirect_stderr }

def usage_error(argv: list[str]) -> bool {
    buf = io.StringIO();
    exited = False;
    with redirect_stderr(buf) {
        try {
            parse_args(argv);
        } except SystemExit {
            exited = True;
        }
    }
    return exited and "usage:" in buf.getvalue();
}

test "today and check default to today's date" {
    assert parse_args(["today"]).day == today_str();
    inv = parse_args(["check", "meds"]);
    assert (inv.command, inv.name, inv.undo, inv.day) == ("check", "meds", False, today_str());
}

test "check takes --undo and --day" {
    inv = parse_args(["check", "meds", "--undo", "--day", "2026-10-01"]);
    assert inv.undo and inv.day == "2026-10-01";
}

test "log-workout keeps its title and details verbatim" {
    inv = parse_args(["log-workout", "Legs", "--details", "squat  3x5"]);
    assert (inv.name, inv.text) == ("Legs", "squat  3x5");
    assert parse_args(["log-workout", "Legs"]).text == "";
}

test "add-job takes company, position, notes and a date" {
    inv = parse_args(["add-job", "Acme", "Intern", "--notes", "referral", "--day", "2026-09-30"]);
    assert (inv.name, inv.position, inv.text, inv.day) == ("Acme", "Intern", "referral", "2026-09-30");
    assert usage_error(["add-job", "Acme"]);
}

test "login and register take a username" {
    assert parse_args(["login", "diego"]).name == "diego";
    assert parse_args(["register", "diego"]).name == "diego";
    assert usage_error(["login"]);
}

test "a missing or unknown command is a usage error" {
    assert usage_error([]);
    assert usage_error(["dance"]);
    assert usage_error(["check"]);
}

test "the parser names itself upkeep and lists every command" {
    buf = io.StringIO();
    with redirect_stderr(buf) {
        try {
            parse_args(["dance"]);
        } except SystemExit {}
    }
    text = buf.getvalue();
    assert text.startswith("usage: upkeep");
    for name in [
        "ping", "login", "register", "logout", "today", "add-habit", "check", "log-workout", "add-job"
    ] {
        assert name in text;
    }
}
