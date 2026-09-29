def:pub name_limit -> int {
    return 80;
}

def:pub statuses -> list[str] {
    return ["Applied", "Online Assessment", "Interview", "Offer", "Rejected"];
}

def:pub goal_kinds -> list[str] {
    return ["habit", "workout"];
}

def:pub valid_name(name: str) -> bool {
    return 0 < len(name.strip()) <= name_limit();
}
