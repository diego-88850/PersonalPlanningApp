import tempfile;
import hashlib;
import from pathlib { Path }

test "a saved token reads back and is private to the owner" {
    path = Path(tempfile.mkdtemp()) / "nested" / "token";
    assert read_token(path) == "";
    save_token(path, "abc.def");
    assert read_token(path) == "abc.def";
    assert path.stat().st_mode & 0o077 == 0;
    save_token(path, "second");
    assert read_token(path) == "second";
}

test "solve_challenge finds the proof of work number" {
    target = hashlib.sha256(("salt" + "42").encode()).hexdigest();
    assert solve_challenge({"salt": "salt", "target": target, "max_number": 100}) == 42;
    assert solve_challenge({"salt": "salt", "target": "nope", "max_number": 10}) is None;
}

test "failure reads the server's error message" {
    assert failure({"ok": False, "error": {"message": "bad password"}}) == "bad password";
    assert failure({"ok": False}) == "request failed";
}
