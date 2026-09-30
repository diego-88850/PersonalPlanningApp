obj Colors {
    has bg: str = "#171717",
        surface: str = "#262626",
        elevated: str = "#343434",
        border: str = "#3f3f3f",
        text: str = "#fafafa",
        muted: str = "#a3a3a3",
        accent: str = "#f97316",
        accentSoft: str = "rgba(249,115,22,0.16)",
        accentText: str = "#ffffff",
        like: str = "#f4548a",
        reply: str = "#4aa3ff",
        danger: str = "#ff5c5c",
        dangerSoft: str = "rgba(255,92,92,0.14)",
        field: str = "#262626",
        scrim: str = "rgba(0,0,0,0.65)",
        success: str = "#8fb67c";
}

obj Spacing {
    has xs: int = 4,
        sm: int = 8,
        md: int = 12,
        lg: int = 16,
        xl: int = 24,
        xxl: int = 32,
        huge: int = 48;
}

obj Radii {
    has sm: int = 8,
        md: int = 12,
        lg: int = 16,
        xl: int = 24,
        pill: int = 999;
}

obj Fonts {
    has xs: int = 12,
        sm: int = 14,
        md: int = 16,
        lg: int = 20,
        xl: int = 26,
        huge: int = 34;
}

def:pub dark_palette -> Colors {
    return Colors(
        bg="#1e1814",
        surface="#2a221c",
        elevated="#362c24",
        border="#4a3d33",
        text="#f5ebdd",
        muted="#b8a794",
        accent="#e39468",
        accentSoft="rgba(227,148,104,0.16)",
        accentText="#1e1814",
        danger="#f28b7d",
        dangerSoft="rgba(242,139,125,0.16)",
        field="#2a221c",
        success="#8fb67c"
    );
}

def:pub light_palette -> Colors {
    return Colors(
        bg="#faf5ec",
        surface="#fffcf6",
        elevated="#f1e8d8",
        border="#dccdb5",
        text="#3a2e26",
        muted="#7a6955",
        accent="#b9532f",
        accentSoft="rgba(185,83,47,0.12)",
        danger="#b3261e",
        dangerSoft="rgba(179,38,30,0.12)",
        field="#fffcf6",
        success="#5f8a4e"
    );
}

def:pub spacing -> Spacing {
    return Spacing();
}

def:pub radii -> Radii {
    return Radii();
}

def:pub fonts -> Fonts {
    return Fonts();
}

def:pub font_family -> str {
    return "Geist";
}
