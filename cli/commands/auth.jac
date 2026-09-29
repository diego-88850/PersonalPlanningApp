import os;
import json;
import hashlib;
import getpass;
import urllib.request;
import from pathlib { Path }
import from jaclang.server { sv_client }

glob DEFAULT_URL: str = "http://localhost:8001";

def server_url -> str {
    return os.environ.get("UPKEEP_URL", DEFAULT_URL).rstrip("/");
}

def token_path -> Path {
    return Path.home() / ".upkeep" / "token";
}

def save_token(path: Path, token: str) {
    path.parent.mkdir(parents=True, exist_ok=True);
    fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600);
    with os.fdopen(fd, "w") as f {
        f.write(token);
    }
}

def read_token(path: Path) -> str {
    return path.read_text().strip() if path.exists() else "";
}

def apply_auth {
    os.environ.setdefault("JAC_APP_SERVER_URL", server_url() + "/api/server");
    token = read_token(token_path());
    if token and not os.environ.get("JAC_BRIDGE_TOKEN") {
        sv_client.set_bearer_token(token);
    }
}

def post_json(path: str, body: dict[str, any]) -> dict[str, any] {
    req = urllib.request.Request(
        server_url() + path,
        data=json.dumps(body).encode(),
        method="POST",
        headers={"Content-Type": "application/json"}
    );
    try {
        with urllib.request.urlopen(req, timeout=15) as resp {
            return json.load(resp);
        }
    } except urllib.error.HTTPError as e {
        try {
            return json.load(e);
        } except ValueError {
            return {"ok": False, "error": {"message": f"HTTP {e.code}"}};
        }
    } except OSError {
        return {
            "ok": False,
            "error": {"message": "server not reachable at " + server_url()}
        };
    }
}

def failure(reply: dict[str, any]) -> str {
    err = reply.get("error") or {};
    return str(err.get("message") or "request failed");
}

def solve_challenge(ch: dict[str, any]) -> int | None {
    for i in range(int(ch["max_number"]) + 1) {
        digest = hashlib.sha256((ch["salt"] + str(i)).encode()).hexdigest();
        if digest == ch["target"] {
            return i;
        }
    }
    return None;
}

def ask_password -> str {
    return os.environ.get("UPKEEP_PASSWORD") or getpass.getpass("Password: ");
}

def sign_in(username: str, password: str) -> int {
    reply = post_json(
        "/user/login",
        {
            "identity": {"type": "username", "value": username},
            "credential": {"type": "password", "password": password}
        }
    );
    if not reply.get("ok") {
        warn("upkeep: login failed: " + failure(reply));
        return EXIT_FAILURE;
    }
    save_token(token_path(), reply["data"]["token"]);
    say("Logged in as " + username);
    return EXIT_OK;
}

def run_login(username: str) -> int {
    return sign_in(username, ask_password());
}

def run_register(username: str) -> int {
    password = ask_password();
    start = post_json("/user/register/challenge", {});
    if not start.get("ok") {
        warn("upkeep: register failed: " + failure(start));
        return EXIT_FAILURE;
    }
    proof: dict[str, any] | None = None;
    if start["data"]["required"] {
        ch = start["data"]["challenge"];
        number = solve_challenge(ch);
        if number is None {
            warn("upkeep: could not solve the registration challenge");
            return EXIT_FAILURE;
        }
        proof = {"token": ch["token"], "number": number};
    }
    reply = post_json(
        "/user/register",
        {
            "identities": [{"type": "username", "value": username}],
            "credential": {"type": "password", "password": password},
            "challenge": proof
        }
    );
    if not reply.get("ok") {
        warn("upkeep: register failed: " + failure(reply));
        return EXIT_FAILURE;
    }
    return sign_in(username, password);
}

def run_logout -> int {
    token_path().unlink(missing_ok=True);
    say("Logged out");
    return EXIT_OK;
}
