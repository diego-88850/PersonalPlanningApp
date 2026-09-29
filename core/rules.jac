import datetime;

def valid_day(day: str) -> bool {
    if len(day) != 10 {
        return False;
    }
    try {
        datetime.date.fromisoformat(day);
        return True;
    } except ValueError {
        return False;
    }
}

def week_so_far(day: str) -> list[str] {
    end = datetime.date.fromisoformat(day);
    start = end - datetime.timedelta(days=end.weekday());
    return [
        (start + datetime.timedelta(days=i)).isoformat()
        for i in range(end.weekday() + 1)
    ];
}

def streaks(days: list[str], today: str) -> tuple[int, int] {
    ordinals = sorted(set([datetime.date.fromisoformat(d).toordinal() for d in days]));
    best = 0;
    run = 0;
    prev = -1;
    for o in ordinals {
        run = run + 1 if o == prev + 1 else 1;
        best = max(best, run);
        prev = o;
    }
    have = set(ordinals);
    cursor = datetime.date.fromisoformat(today).toordinal();
    if cursor not in have {
        cursor -= 1;
    }
    current = 0;
    while cursor in have {
        current += 1;
        cursor -= 1;
    }
    return (current, best);
}

def completion_pct(done: int, habits: int, days: int) -> int {
    possible = habits * days;
    return min(100, done * 100 // possible) if possible > 0 else 0;
}
