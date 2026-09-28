obj Result {
    has ok: bool = True,
        error: str = "",
        id: str = "";
}

obj HabitView {
    has id: str,
        name: str,
        done_today: bool,
        current: int,
        longest: int,
        week_done: int;
}

obj WorkoutView {
    has id: str,
        day: str,
        title: str,
        details: str;
}

obj ApplicationView {
    has id: str,
        company: str,
        position: str,
        status: str,
        applied_on: str,
        notes: str;
}

obj GoalView {
    has id: str,
        title: str,
        kind: str,
        habit_id: str,
        target: int,
        done: int,
        pct: int;
}

obj Today {
    has day: str,
        habits: list[HabitView] = [],
        workouts: list[WorkoutView] = [],
        goals: list[GoalView] = [],
        week_pct: int = 0;
}

node Habit {
    has name: str,
        days: list[str] = [],
        archived: bool = False;
}

node Workout {
    has day: str,
        title: str,
        details: str = "";
}

node Goal {
    has title: str,
        kind: str,
        target: int,
        habit_id: str = "";
}

node Application {
    has company: str,
        position: str,
        status: str,
        applied_on: str,
        notes: str = "";
}

def:pub ping -> str {
    return "upkeep";
}

def _fail(error: str) -> Result {
    return Result(ok=False, error=error);
}

def _owned(id: str) -> Habit | Workout | Goal | Application | None {
    for n in [root -->] {
        if jid(n) == id and isinstance(n, (Habit, Workout, Goal, Application)) {
            return n;
        }
    }
    return None;
}

def _habit_view(h: Habit, day: str) -> HabitView {
    week = set(week_so_far(day));
    (current, longest) = streaks(h.days, day);
    return HabitView(
        id=jid(h),
        name=h.name,
        done_today=day in h.days,
        current=current,
        longest=longest,
        week_done=len([d for d in h.days if d in week])
    );
}

def _workout_view(w: Workout) -> WorkoutView {
    return WorkoutView(id=jid(w), day=w.day, title=w.title, details=w.details);
}

def _goal_views(day: str) -> list[GoalView] {
    week = set(week_so_far(day));
    habit_days = {jid(h): h.days for h in [root -->][?:Habit]};
    workouts = len([w for w in [root -->][?:Workout] if w.day in week]);
    views: list[GoalView] = [];
    for g in [root -->][?:Goal] {
        done = (
            workouts
            if g.kind == "workout"
            else len([d for d in habit_days.get(g.habit_id, []) if d in week])
        );
        views.append(
            GoalView(
                id=jid(g),
                title=g.title,
                kind=g.kind,
                habit_id=g.habit_id,
                target=g.target,
                done=done,
                pct=min(100, done * 100 // g.target)
            )
        );
    }
    return views;
}

def:protect add_habit(name: str) -> Result {
    if not valid_name(name) {
        return _fail(f"Habit name must be 1-{NAME_LIMIT} characters");
    }
    h = root ++> Habit(name=name.strip());
    return Result(id=jid(h));
}

def:protect archive_habit(id: str) -> Result {
    h = _owned(id);
    if not isinstance(h, Habit) {
        return _fail("No such habit");
    }
    h.archived = True;
    return Result(id=id);
}

def:protect set_check(id: str, day: str, done: bool = True) -> Result {
    if not valid_day(day) {
        return _fail("Day must be YYYY-MM-DD");
    }
    h = _owned(id);
    if not isinstance(h, Habit) {
        return _fail("No such habit");
    }
    if done and day not in h.days {
        h.days.append(day);
    } elif not done and day in h.days {
        h.days.remove(day);
    }
    return Result(id=id);
}

def:protect list_habits(day: str) -> list[HabitView] {
    if not valid_day(day) {
        return [];
    }
    return [_habit_view(h, day) for h in [root -->][?:Habit] if not h.archived];
}

def:protect log_workout(day: str, title: str, details: str = "") -> Result {
    if not valid_day(day) {
        return _fail("Day must be YYYY-MM-DD");
    }
    if not valid_name(title) {
        return _fail(f"Workout title must be 1-{NAME_LIMIT} characters");
    }
    w = root ++> Workout(day=day, title=title.strip(), details=details.strip());
    return Result(id=jid(w));
}

def:protect list_workouts(limit: int = 20) -> list[WorkoutView] {
    recent = sorted(
        [root -->][?:Workout], key=lambda (w: Workout) { w.day; }, reverse=True
    );
    return [_workout_view(w) for w in recent[:max(limit, 0)]];
}

def:protect add_application(
    company: str, position: str, applied_on: str, notes: str = ""
) -> Result {
    if not valid_name(company) or not valid_name(position) {
        return _fail(f"Company and position must be 1-{NAME_LIMIT} characters");
    }
    if not valid_day(applied_on) {
        return _fail("Date applied must be YYYY-MM-DD");
    }
    a = root ++> Application(
        company=company.strip(),
        position=position.strip(),
        status=STATUSES[0],
        applied_on=applied_on,
        notes=notes.strip()
    );
    return Result(id=jid(a));
}

def:protect update_application(
    id: str, status: str = "", notes: str | None = None
) -> Result {
    a = _owned(id);
    if not isinstance(a, Application) {
        return _fail("No such application");
    }
    if status and status not in STATUSES {
        return _fail("Status must be one of: " + ", ".join(STATUSES));
    }
    if status {
        a.status = status;
    }
    if notes is not None {
        a.notes = notes.strip();
    }
    return Result(id=id);
}

def:protect list_applications -> list[ApplicationView] {
    recent = sorted(
        [root -->][?:Application],
        key=lambda (a: Application) { a.applied_on; },
        reverse=True
    );
    return [
        ApplicationView(
            id=jid(a),
            company=a.company,
            position=a.position,
            status=a.status,
            applied_on=a.applied_on,
            notes=a.notes
        )
        for a in recent
    ];
}

def:protect set_goal(
    title: str, kind: str, target: int, habit_id: str = ""
) -> Result {
    if not valid_name(title) {
        return _fail(f"Goal title must be 1-{NAME_LIMIT} characters");
    }
    if kind not in GOAL_KINDS {
        return _fail("Goal kind must be one of: " + ", ".join(GOAL_KINDS));
    }
    if not 1 <= target <= 99 {
        return _fail("Goal target must be between 1 and 99");
    }
    if kind == "habit" and not isinstance(_owned(habit_id), Habit) {
        return _fail("A habit goal needs an existing habit");
    }
    g = root ++> Goal(
        title=title.strip(),
        kind=kind,
        target=target,
        habit_id=habit_id if kind == "habit" else ""
    );
    return Result(id=jid(g));
}

def:protect list_goals(day: str) -> list[GoalView] {
    return _goal_views(day) if valid_day(day) else [];
}

def:protect delete_item(id: str) -> Result {
    n = _owned(id);
    if n is None {
        return _fail("Nothing with that id");
    }
    del n;
    return Result(id=id);
}

def:protect get_today(day: str) -> Today {
    if not valid_day(day) {
        return Today(day=day);
    }
    habits = list_habits(day);
    return Today(
        day=day,
        habits=habits,
        workouts=[
            _workout_view(w) for w in [root -->][?:Workout] if w.day == day
        ],
        goals=_goal_views(day),
        week_pct=completion_pct(
            sum([h.week_done for h in habits]), len(habits), len(week_so_far(day))
        )
    );
}
