def habit(name: str, done: bool = False) -> HabitView {
    return HabitView(id=name, name=name, done_today=done, current=2, longest=5, week_done=1);
}

test "match_habits prefers an exact name over a prefix" {
    habits = [habit("read"), habit("reading list")];
    assert [h.name for h in match_habits(habits, "READ")] == ["read"];
}

test "match_habits falls back to a prefix and can be ambiguous or empty" {
    habits = [habit("meds"), habit("stretch"), habit("stretch legs")];
    assert [h.name for h in match_habits(habits, "me")] == ["meds"];
    assert len(match_habits(habits, "str")) == 2;
    assert match_habits(habits, "gym") == [];
}

test "render_today shows habits, workouts and goals" {
    today = Today(
        day="2026-10-02",
        habits=[habit("meds", True), habit("stretch")],
        workouts=[WorkoutView(id="w", day="2026-10-02", title="Legs", details="squat 3x5")],
        goals=[GoalView(id="g", title="Gym 4x", kind="workout", habit_id="", target=4, done=2, pct=50)],
        week_pct=40
    );
    text = render_today(today);
    assert text.splitlines()[0] == "2026-10-02  week 40%";
    assert "[x] meds  streak 2 (best 5)" in text;
    assert "[ ] stretch" in text;
    assert "Legs: squat 3x5" in text;
    assert "Gym 4x  2/4 (50%)" in text;
}

test "render_today marks empty sections" {
    text = render_today(Today(day="2026-10-02", habits=[], workouts=[], goals=[], week_pct=0));
    assert text.count("(none)") == 3;
}
