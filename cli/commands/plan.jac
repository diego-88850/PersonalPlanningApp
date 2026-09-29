import datetime;

def today_str -> str {
    return datetime.date.today().isoformat();
}

def match_habits(habits: list[HabitView], name: str) -> list[HabitView] {
    key = name.strip().lower();
    exact = [h for h in habits if h.name.lower() == key];
    return exact or [h for h in habits if h.name.lower().startswith(key)];
}

def render_today(t: Today) -> str {
    lines = [f"{t.day}  week {t.week_pct}%", "", "Habits"];
    for h in t.habits {
        mark = "x" if h.done_today else " ";
        lines.append(f"  [{mark}] {h.name}  streak {h.current} (best {h.longest})");
    }
    if not t.habits {
        lines.append("  (none)");
    }
    lines.append("Workouts");
    for w in t.workouts {
        lines.append("  " + w.title + (": " + w.details if w.details else ""));
    }
    if not t.workouts {
        lines.append("  (none)");
    }
    lines.append("Goals");
    for g in t.goals {
        lines.append(f"  {g.title}  {g.done}/{g.target} ({g.pct}%)");
    }
    if not t.goals {
        lines.append("  (none)");
    }
    return "\n".join(lines);
}

def finish(res: Result, message: str) -> int {
    if res.ok {
        say(message);
        return EXIT_OK;
    }
    warn("upkeep: " + res.error);
    return EXIT_FAILURE;
}

async def run_today(day: str) -> int {
    say(render_today(await get_today(day)));
    return EXIT_OK;
}

async def run_add_habit(name: str) -> int {
    return finish(await add_habit(name), "Added habit " + name.strip());
}

async def run_check(name: str, day: str, undo: bool) -> int {
    found = match_habits(await list_habits(day), name);
    if len(found) != 1 {
        warn(
            "upkeep: no habit named " + name
            if not found
            else "upkeep: " + name + " is ambiguous: " + ", ".join([h.name for h in found])
        );
        return EXIT_FAILURE;
    }
    verb = "Unchecked " if undo else "Checked ";
    return finish(
        await set_check(found[0].id, day, not undo), verb + found[0].name + " for " + day
    );
}

async def run_log_workout(title: str, day: str, details: str) -> int {
    return finish(
        await log_workout(day, title, details), "Logged workout " + title.strip()
    );
}

async def run_add_job(company: str, position: str, day: str, notes: str) -> int {
    return finish(
        await add_application(company, position, day, notes),
        "Added " + position.strip() + " at " + company.strip()
    );
}
