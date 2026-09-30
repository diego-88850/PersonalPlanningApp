def:pub pad2(n: int) -> str {
    return "0" + str(n) if n < 10 else str(n);
}

def:pub fmt_date(d: any) -> str {
    return str(d.getFullYear()) + "-" + pad2(d.getMonth() + 1) + "-" + pad2(d.getDate());
}

def:pub local_today -> str {
    return fmt_date(new(Date));
}

def:pub shift_day(day: str, delta: int) -> str {
    parts = day.split("-");
    return fmt_date(
        new(Date, int(parts[0]), int(parts[1]) - 1, int(parts[2]) + delta)
    );
}

def:pub parse_day(day: str) -> any {
    parts = day.split("-");
    return new(Date, int(parts[0]), int(parts[1]) - 1, int(parts[2]));
}

def:pub pretty_day(day: str) -> str {
    return parse_day(day).toLocaleDateString(
        "en-US", {"weekday": "long", "month": "long", "day": "numeric"}
    );
}

def:pub short_day(day: str) -> str {
    return parse_day(day).toLocaleDateString("en-US", {"month": "short", "day": "numeric"});
}
