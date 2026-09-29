import from "@jac/runtime" {
    jacLogin,
    jacLogout,
    jacIsLoggedIn,
    __getLocalStorage,
    __setLocalStorage,
    __removeLocalStorage
}

obj Session {
    has loggedIn: bool,
        checking: bool,
        signup: bool,
        username: str,
        password: str,
        error: str,
        busy: bool,
        setUsername: Callable[[str], None],
        setPassword: Callable[[str], None],
        toggleMode: Callable[[], None],
        submit: Callable[[], None],
        logout: Callable[[], None];
}

def:pub useSession -> Session {
    has loggedIn: bool = False,
        checking: bool = True,
        signup: bool = False,
        username: str = "",
        password: str = "",
        error: str = "",
        busy: bool = False;

    can with entry {
        loggedIn = jacIsLoggedIn();
        checking = False;
    }

    async def submit -> None {
        if busy {
            return;
        }
        error = "";
        if not username.strip() or not password {
            error = "Please fill in all fields";
            return;
        }
        if signup and len(password) < 4 {
            error = "Password must be at least 4 characters";
            return;
        }
        busy = True;
        try {
            if signup {
                registration_error = await register_with_challenge(
                    username.strip(), password
                );
                if registration_error {
                    error = registration_error;
                    return;
                }
            }
            if await jacLogin(username.strip(), password) {
                __setLocalStorage("upkeep_username", username.strip());
                password = "";
                loggedIn = True;
            } else {
                error = "Account created. Please log in."
                    if signup
                    else "Invalid username or password";
                signup = False;
            }
        } except Exception {
            error = "Could not reach the server. Please try again.";
        } finally {
            busy = False;
        }
    }

    def logout {
        jacLogout();
        __removeLocalStorage("upkeep_username");
        loggedIn = False;
        username = "";
        password = "";
        error = "";
        signup = False;
    }

    return Session(
        loggedIn=loggedIn,
        checking=checking,
        signup=signup,
        username=username,
        password=password,
        error=error,
        busy=busy,
        setUsername=lambda (value: str) { username = value; },
        setPassword=lambda (value: str) { password = value; },
        toggleMode=lambda {
            signup = not signup;
            error = "";
        },
        submit=submit,
        logout=logout
    );
}
