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
