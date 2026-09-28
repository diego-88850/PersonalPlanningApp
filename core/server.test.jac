def ids_of(items: list[any]) -> list[str] {
    return [i.id for i in items];
}

test "ping answers" {
    assert ping() == "upkeep";
}

test "add_habit validates the name" {
    assert not add_habit("   ").ok;
    assert not add_habit("x" * 81).ok;
    res = add_habit("  meds  ");
    assert res.ok and res.id;
    assert "meds" in [h.name for h in list_habits("2099-06-01")];
    delete_item(res.id);
}

test "set_check is idempotent and drives done_today and streaks" {
    hid = add_habit("stretch").id;
    assert set_check(hid, "2099-06-01").ok;
    assert set_check(hid, "2099-06-01").ok;
    assert set_check(hid, "2099-06-02").ok;
    view = [h for h in list_habits("2099-06-02") if h.id == hid][0];
    assert view.done_today;
    assert (view.current, view.longest, view.week_done) == (2, 2, 2);
    assert set_check(hid, "2099-06-02", False).ok;
    view = [h for h in list_habits("2099-06-02") if h.id == hid][0];
    assert not view.done_today;
    assert (view.current, view.week_done) == (1, 1);
    delete_item(hid);
}

test "set_check rejects bad days and unknown habits" {
    hid = add_habit("read").id;
    assert not set_check(hid, "tomorrow").ok;
    assert not set_check("nope", "2099-06-01").ok;
    assert list_habits("not-a-day") == [];
    delete_item(hid);
}

test "archived habits disappear from the list" {
    hid = add_habit("old habit").id;
    assert archive_habit(hid).ok;
    assert hid not in ids_of(list_habits("2099-06-01"));
    assert not archive_habit("nope").ok;
    delete_item(hid);
}

test "workouts list newest first and respect the limit" {
    a = log_workout("2099-06-01", "legs", "squat 3x5").id;
    b = log_workout("2099-06-02", "push").id;
    top = list_workouts(2);
    assert ids_of(top) == [b, a];
    assert top[1].details == "squat 3x5";
    assert len(list_workouts(1)) == 1;
    assert list_workouts(0) == [];
    delete_item(a);
    delete_item(b);
}

test "log_workout validates input" {
    assert not log_workout("bad", "legs").ok;
    assert not log_workout("2099-06-01", "  ").ok;
}

test "applications start as Applied and can be updated" {
    aid = add_application("Acme", "Intern", "2099-06-01", "referral").id;
    row = [a for a in list_applications() if a.id == aid][0];
    assert (row.company, row.status, row.notes) == ("Acme", "Applied", "referral");
    assert update_application(aid, "Interview").ok;
    assert update_application(aid, notes="phone screen").ok;
    row = [a for a in list_applications() if a.id == aid][0];
    assert (row.status, row.notes) == ("Interview", "phone screen");
    assert update_application(aid, notes="").ok;
    row = [a for a in list_applications() if a.id == aid][0];
    assert row.status == "Interview" and row.notes == "";
    delete_item(aid);
}

test "applications reject bad input" {
    assert not add_application("", "Intern", "2099-06-01").ok;
    assert not add_application("Acme", "Intern", "soon").ok;
    aid = add_application("Beta", "Intern", "2099-06-01").id;
    assert not update_application(aid, "Ghosted").ok;
    assert not update_application("nope", "Offer").ok;
    delete_item(aid);
}

test "applications list newest applied first" {
    a = add_application("OldCo", "Dev", "2099-05-01").id;
    b = add_application("NewCo", "Dev", "2099-05-09").id;
    order = ids_of(list_applications());
    assert order.index(b) < order.index(a);
    delete_item(a);
    delete_item(b);
}

test "habit goals count check-ins this week" {
    hid = add_habit("gym habit").id;
    gid = set_goal("Gym 4x", "habit", 4, hid).id;
    set_check(hid, "2099-06-01");
    set_check(hid, "2099-06-03");
    set_check(hid, "2099-05-31");
    goal = [g for g in list_goals("2099-06-03") if g.id == gid][0];
    assert (goal.done, goal.target, goal.pct) == (2, 4, 50);
    delete_item(gid);
    delete_item(hid);
}

test "workout goals count logged workouts this week" {
    gid = set_goal("Lift 2x", "workout", 2).id;
    a = log_workout("2099-06-01", "legs").id;
    b = log_workout("2099-06-02", "push").id;
    c = log_workout("2099-06-03", "pull").id;
    goal = [g for g in list_goals("2099-06-03") if g.id == gid][0];
    assert (goal.done, goal.pct) == (3, 100);
    for i in [gid, a, b, c] {
        delete_item(i);
    }
}

test "set_goal validates input" {
    assert not set_goal("", "workout", 2).ok;
    assert not set_goal("x", "sleep", 2).ok;
    assert not set_goal("x", "workout", 0).ok;
    assert not set_goal("x", "habit", 2, "nope").ok;
    assert list_goals("bad") == [];
}

test "delete_item removes things and rejects unknown ids" {
    wid = log_workout("2099-06-01", "temp").id;
    assert delete_item(wid).ok;
    assert wid not in ids_of(list_workouts(1000));
    assert not delete_item(wid).ok;
    assert not delete_item("nope").ok;
}

test "get_today combines habits, workouts and goals for one day" {
    hid = add_habit("today habit").id;
    set_check(hid, "2099-06-03");
    wid = log_workout("2099-06-03", "run").id;
    gid = set_goal("Run once", "workout", 1).id;
    today = get_today("2099-06-03");
    assert today.day == "2099-06-03";
    assert hid in ids_of(today.habits);
    assert ids_of(today.workouts) == [wid];
    assert gid in ids_of(today.goals);
    assert 0 < today.week_pct <= 100;
    assert get_today("bad").habits == [];
    for i in [hid, wid, gid] {
        delete_item(i);
    }
}
