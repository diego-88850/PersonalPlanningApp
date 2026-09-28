import io;
import from contextlib { redirect_stderr }

test "bridge failures map to distinct exit codes and hints" {
    buf = io.StringIO();
    with redirect_stderr(buf) {
        assert explain_bridge_error(
            BridgeUnavailable(
                app="web", name="ping", detail="connection refused"
            )
        )
            == EXIT_UNAVAILABLE;
        assert explain_bridge_error(BridgeTimeout(app="server", name="ping"))
            == EXIT_TIMEOUT;
        assert explain_bridge_error(
            BridgeRejected(app="server", name="ping", detail="401")
        )
            == EXIT_REJECTED;
        assert explain_bridge_error(
            BridgeError(app="web", name="ping", detail="500")
        )
            == EXIT_FAILURE;
    }
    text = buf.getvalue();
    assert "web.ping is not reachable (connection refused)" in text;
    assert START_HINT in text;
    assert "server.ping timed out" in text;
    assert "signed-in identity" in text;
    assert "web.ping failed (500)" in text;
}

test "exit codes are distinct" {
    codes = [
        EXIT_OK,
        EXIT_FAILURE,
        EXIT_USAGE,
        EXIT_UNAVAILABLE,
        EXIT_TIMEOUT,
        EXIT_REJECTED
    ];
    assert len(set(codes)) == len(codes);
}
