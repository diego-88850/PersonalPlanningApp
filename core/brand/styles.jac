import from pathlib { Path }

def css(p: Colors) -> str {
    return "--background:"
        + p.bg
        + ";--foreground:"
        + p.text
        + ";--card:"
        + p.surface
        + ";--card-foreground:"
        + p.text
        + ";--primary:"
        + p.accent
        + ";--primary-foreground:"
        + p.accentText
        + ";--popover:"
        + p.surface
        + ";--popover-foreground:"
        + p.text
        + ";--secondary:"
        + p.elevated
        + ";--secondary-foreground:"
        + p.text
        + ";--accent:"
        + p.elevated
        + ";--accent-foreground:"
        + p.text
        + ";--ring:"
        + p.accent
        + ";--success:"
        + p.success
        + ";--muted:"
        + p.elevated
        + ";--muted-foreground:"
        + p.muted
        + ";--border:"
        + p.border
        + ";--input:"
        + p.border
        + ";--like:"
        + p.like
        + ";--reply:"
        + p.reply
        + ";--destructive:"
        + p.danger
        + ";--radius:"
        + str(radii().md)
        + "px;--spacing:"
        + str(spacing().xs)
        + "px;--font-sans:"
        + font_family()
        + ",sans-serif;--font-display:"
        + font_family()
        + ",sans-serif;";
}

with entry {
    dest = Path(__file__).resolve().parent.parent / "site" / "styles" / "brand.css";
    dest.write_text(
        ":root{" + css(light_palette()) + "}\n.dark{" + css(dark_palette()) + "}\n",
        encoding="utf-8"
    );
    logo = dest.parent.parent / "assets" / "upkeep-logo.svg";
    logo.write_text(logo_xml(), encoding="utf-8");
}
