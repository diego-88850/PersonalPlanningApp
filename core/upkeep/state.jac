import from "@jac/runtime" {
    BridgeError,
    BridgeUnavailable,
    BridgeTimeout,
    BridgeRejected
}

obj UpkeepState {
    has session: Session,
        day: str,
        today: Today | None,
        workouts: list[WorkoutView],
        applications: list[ApplicationView],
        loading: bool,
        error: str,
        setDay: Callable[[str], None],
        shiftDay: Callable[[int], None],
        refresh: Callable[[], None],
        toggleHabit: Callable[[str, bool], None],
        addHabit: Callable[[str], bool],
        archiveHabit: Callable[[str], None],
        logWorkout: Callable[[str, str], bool],
        addApplication: Callable[[str, str, str], bool],
        setApplicationStatus: Callable[[str, str], None],
        addGoal: Callable[[str, str, int, str], bool],
        removeItem: Callable[[str], None],
        logout: Callable[[], None],
        dismissError: Callable[[], None];
}

def describe(e: Exception) -> str {
    if isinstance(e, BridgeUnavailable) {
        return "Can't reach the server. Check your connection and try again.";
    }
    if isinstance(e, BridgeTimeout) {
        return "The server is taking too long to answer.";
    }
    if isinstance(e, BridgeRejected) {
        return "The server refused that request. Please sign in again.";
    }
    if isinstance(e, BridgeError) {
        return "Something went wrong talking to the server.";
    }
    return "Something went wrong. Please try again.";
}

def:pub useUpkeep -> UpkeepState {
    session = useSession();
    has day: str = local_today(),
        today: Today | None = None,
        workouts: list[WorkoutView] = [],
        applications: list[ApplicationView] = [],
        loading: bool = False,
        error: str = "";

    async def refresh {
        fresh_today: Today | None = None;
        fresh_workouts: list[WorkoutView] = [];
        fresh_applications: list[ApplicationView] = [];
        try {
            loading = True;
            fresh_today = await get_today(day);
            fresh_workouts = await list_workouts(30);
            fresh_applications = await list_applications();
            today = fresh_today;
            workouts = fresh_workouts;
            applications = fresh_applications;
        } except Exception as e {
            error = describe(e);
        } finally {
            loading = False;
        }
    }

    async def settle(res: Result) -> bool {
        if not res.ok {
            error = res.error;
            return False;
        }
        error = "";
        await refresh();
        return True;
    }

    async def toggleHabit(habitId: str, done: bool) {
        res: Result | None = None;
        try {
            res = await set_check(habitId, day, done);
            await settle(res);
        } except Exception as e {
            error = describe(e);
        }
    }

    async def addHabit(name: str) -> bool {
        if not valid_name(name) {
            error = "Habit name must be 1-" + str(name_limit()) + " characters";
            return False;
        }
        res: Result | None = None;
        ok: bool = False;
        try {
            res = await add_habit(name);
            ok = await settle(res);
        } except Exception as e {
            error = describe(e);
        }
        return ok;
    }

    async def archiveHabit(habitId: str) {
        res: Result | None = None;
        try {
            res = await archive_habit(habitId);
            await settle(res);
        } except Exception as e {
            error = describe(e);
        }
    }

    async def logWorkout(title: str, details: str) -> bool {
        if not valid_name(title) {
            error = "Workout title must be 1-" + str(name_limit()) + " characters";
            return False;
        }
        res: Result | None = None;
        ok: bool = False;
        try {
            res = await log_workout(day, title, details);
            ok = await settle(res);
        } except Exception as e {
            error = describe(e);
        }
        return ok;
    }

    async def addApplication(company: str, position: str, notes: str) -> bool {
        if not valid_name(company) or not valid_name(position) {
            error = "Company and position must be 1-" + str(name_limit()) + " characters";
            return False;
        }
        res: Result | None = None;
        ok: bool = False;
        try {
            res = await add_application(company, position, local_today(), notes);
            ok = await settle(res);
        } except Exception as e {
            error = describe(e);
        }
        return ok;
    }

    async def setApplicationStatus(appId: str, status: str) {
        res: Result | None = None;
        try {
            res = await update_application(appId, status);
            await settle(res);
        } except Exception as e {
            error = describe(e);
        }
    }

    async def addGoal(title: str, kind: str, target: int, habitId: str) -> bool {
        if not valid_name(title) {
            error = "Goal title must be 1-" + str(name_limit()) + " characters";
            return False;
        }
        res: Result | None = None;
        ok: bool = False;
        try {
            res = await set_goal(title, kind, target, habitId);
            ok = await settle(res);
        } except Exception as e {
            error = describe(e);
        }
        return ok;
    }

    async def removeItem(itemId: str) {
        res: Result | None = None;
        try {
            res = await delete_item(itemId);
            await settle(res);
        } except Exception as e {
            error = describe(e);
        }
    }

    def logout {
        session.logout();
        today = None;
        workouts = [];
        applications = [];
        error = "";
        day = local_today();
    }

    can with [session.loggedIn, day] entry {
        if session.loggedIn {
            refresh();
        }
    }

    return UpkeepState(
        session=session,
        day=day,
        today=today,
        workouts=workouts,
        applications=applications,
        loading=loading,
        error=error,
        setDay=lambda (value: str) { day = value; },
        shiftDay=lambda (delta: int) { day = shift_day(day, delta); },
        refresh=refresh,
        toggleHabit=toggleHabit,
        addHabit=addHabit,
        archiveHabit=archiveHabit,
        logWorkout=logWorkout,
        addApplication=addApplication,
        setApplicationStatus=setApplicationStatus,
        addGoal=addGoal,
        removeItem=removeItem,
        logout=logout,
        dismissError=lambda { error = ""; }
    );
}
