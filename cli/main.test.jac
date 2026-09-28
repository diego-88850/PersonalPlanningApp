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

test "ping parses" {
    assert parse_args(["ping"]).command == "ping";
}

test "a missing or unknown command is a usage error" {
    assert usage_error([]);
    assert usage_error(["dance"]);
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
    assert "ping" in text;
}
