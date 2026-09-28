test "valid_day accepts only ISO dates" {
    assert valid_day("2026-10-02");
    assert not valid_day("2026-13-02");
    assert not valid_day("20261002");
    assert not valid_day("tomorrow");
    assert not valid_day("");
}

test "valid_name trims and bounds" {
    assert valid_name("meds");
    assert not valid_name("   ");
    assert not valid_name("x" * 81);
    assert valid_name("x" * 80);
}

test "week_so_far runs Monday through the given day" {
    assert week_so_far("2026-10-05") == ["2026-10-05"];
    assert week_so_far("2026-10-07") == ["2026-10-05", "2026-10-06", "2026-10-07"];
    assert len(week_so_far("2026-10-11")) == 7;
}

test "week_so_far crosses month and year boundaries" {
    assert week_so_far("2026-01-01") == ["2025-12-29", "2025-12-30", "2025-12-31", "2026-01-01"];
}

test "streaks counts a run ending today" {
    assert streaks(["2026-10-01", "2026-10-02"], "2026-10-02") == (2, 2);
}

test "streaks keeps the run alive if only today is missing" {
    assert streaks(["2026-09-30", "2026-10-01"], "2026-10-02") == (2, 2);
}

test "streaks resets after a missed day but remembers the longest" {
    days = ["2026-09-01", "2026-09-02", "2026-09-03", "2026-10-02"];
    assert streaks(days, "2026-10-02") == (1, 3);
    assert streaks(days, "2026-10-04") == (0, 3);
}

test "streaks ignores duplicates and order" {
    assert streaks(["2026-10-02", "2026-10-01", "2026-10-02"], "2026-10-02") == (2, 2);
    assert streaks([], "2026-10-02") == (0, 0);
}

test "completion_pct is bounded and safe on empty input" {
    assert completion_pct(3, 2, 3) == 50;
    assert completion_pct(9, 2, 3) == 100;
    assert completion_pct(0, 0, 3) == 0;
    assert completion_pct(1, 1, 0) == 0;
}
