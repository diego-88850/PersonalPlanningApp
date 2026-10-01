import from "@jac/mobui" { StyleSheet, Platform }

glob TOP_PAD: int = Platform.select({"ios": 52, "android": 30, "default": 12});

def:pub makeStyles(C: Colors) -> any {
    S = spacing();
    R = radii();
    F = fonts();
    return StyleSheet.create(
        {
            "root": {"flex": 1, "backgroundColor": C.bg},
            "page": {
                "flex": 1,
                "width": "100%",
                "maxWidth": 640,
                "alignSelf": "center"
            },
            "center": {
                "flex": 1,
                "backgroundColor": C.bg,
                "alignItems": "center",
                "justifyContent": "center"
            },
            "body": {"flex": 1},
            "header": {
                "flexDirection": "row",
                "alignItems": "center",
                "justifyContent": "space-between",
                "paddingTop": TOP_PAD,
                "paddingBottom": S.md,
                "paddingHorizontal": S.lg,
                "borderBottomWidth": 1,
                "borderBottomColor": C.border
            },
            "brand": {"flexDirection": "row", "alignItems": "center", "gap": S.sm},
            "brandDot": {
                "width": 12,
                "height": 12,
                "borderRadius": R.pill,
                "backgroundColor": C.accent
            },
            "brandTitle": {"color": C.text, "fontSize": F.lg, "fontWeight": "bold"},
            "headerActions": {"flexDirection": "row", "gap": S.xs},
            "iconButton": {
                "width": 36,
                "height": 36,
                "borderRadius": R.pill,
                "alignItems": "center",
                "justifyContent": "center"
            },
            "scroll": {"padding": S.lg, "paddingBottom": S.huge, "gap": S.lg},
            "title": {"color": C.text, "fontSize": F.xl, "fontWeight": "bold"},
            "subtitle": {"color": C.muted, "fontSize": F.sm},
            "dayRow": {
                "flexDirection": "row",
                "alignItems": "center",
                "justifyContent": "space-between",
                "gap": S.md
            },
            "dayText": {"flex": 1, "gap": 2},
            "dayNav": {"flexDirection": "row", "alignItems": "center", "gap": S.xs},
            "navButton": {
                "width": 36,
                "height": 36,
                "borderRadius": R.pill,
                "borderWidth": 1,
                "borderColor": C.border,
                "backgroundColor": C.surface,
                "alignItems": "center",
                "justifyContent": "center"
            },
            "todayChip": {
                "paddingHorizontal": S.md,
                "height": 36,
                "borderRadius": R.pill,
                "borderWidth": 1,
                "borderColor": C.border,
                "backgroundColor": C.surface,
                "alignItems": "center",
                "justifyContent": "center"
            },
            "todayChipLabel": {"color": C.text, "fontSize": F.sm, "fontWeight": "500"},
            "card": {
                "backgroundColor": C.surface,
                "borderRadius": R.lg,
                "borderWidth": 1,
                "borderColor": C.border,
                "padding": S.lg,
                "gap": S.md
            },
            "cardTitle": {"color": C.text, "fontSize": F.md, "fontWeight": "600"},
            "track": {
                "height": 8,
                "borderRadius": R.pill,
                "backgroundColor": C.elevated,
                "overflow": "hidden"
            },
            "fill": {"height": 8, "borderRadius": R.pill, "backgroundColor": C.accent},
            "fillDone": {
                "height": 8,
                "borderRadius": R.pill,
                "backgroundColor": C.success
            },
            "row": {
                "flexDirection": "row",
                "alignItems": "center",
                "gap": S.md,
                "paddingVertical": S.xs
            },
            "check": {
                "width": 32,
                "height": 32,
                "borderRadius": R.pill,
                "borderWidth": 2,
                "borderColor": C.border,
                "alignItems": "center",
                "justifyContent": "center"
            },
            "checkOn": {"backgroundColor": C.success, "borderColor": C.success},
            "rowBody": {"flex": 1, "gap": 2},
            "rowTitle": {"color": C.text, "fontSize": F.md, "fontWeight": "500"},
            "rowDone": {"color": C.muted, "textDecorationLine": "line-through"},
            "rowMeta": {"color": C.muted, "fontSize": F.xs},
            "input": {
                "backgroundColor": C.field,
                "borderWidth": 1,
                "borderColor": C.border,
                "borderRadius": R.md,
                "paddingHorizontal": S.md,
                "paddingVertical": S.md,
                "color": C.text,
                "fontSize": F.md
            },
            "inputMulti": {"minHeight": 76, "textAlignVertical": "top"},
            "button": {
                "backgroundColor": C.accent,
                "borderRadius": R.md,
                "paddingVertical": S.md,
                "alignItems": "center"
            },
            "buttonLabel": {
                "color": C.accentText,
                "fontSize": F.md,
                "fontWeight": "600"
            },
            "buttonSoft": {
                "backgroundColor": C.elevated,
                "borderRadius": R.md,
                "paddingVertical": S.md,
                "alignItems": "center"
            },
            "buttonSoftLabel": {
                "color": C.text,
                "fontSize": F.md,
                "fontWeight": "600"
            },
            "disabled": {"opacity": 0.5},
            "link": {"color": C.muted, "fontSize": F.sm, "textAlign": "center"},
            "chips": {"flexDirection": "row", "flexWrap": "wrap", "gap": S.xs},
            "chip": {
                "paddingHorizontal": S.md,
                "paddingVertical": S.sm,
                "borderRadius": R.pill,
                "backgroundColor": C.elevated
            },
            "chipOn": {"backgroundColor": C.accent},
            "chipLabel": {"color": C.text, "fontSize": F.xs, "fontWeight": "500"},
            "chipLabelOn": {"color": C.accentText},
            "workout": {
                "flexDirection": "row",
                "alignItems": "flex-start",
                "gap": S.md,
                "backgroundColor": C.elevated,
                "borderRadius": R.md,
                "padding": S.md
            },
            "bigNumber": {"color": C.text, "fontSize": F.huge, "fontWeight": "bold"},
            "statRow": {
                "flexDirection": "row",
                "alignItems": "center",
                "paddingVertical": S.sm,
                "borderTopWidth": 1,
                "borderTopColor": C.border
            },
            "statName": {"flex": 1, "color": C.text, "fontSize": F.sm, "fontWeight": "500"},
            "statNum": {
                "width": 52,
                "textAlign": "right",
                "color": C.muted,
                "fontSize": F.sm
            },
            "statHead": {
                "width": 52,
                "textAlign": "right",
                "color": C.muted,
                "fontSize": F.xs
            },
            "empty": {
                "alignItems": "center",
                "gap": S.sm,
                "paddingVertical": S.xl,
                "paddingHorizontal": S.lg
            },
            "emptyTitle": {"color": C.text, "fontSize": F.md, "fontWeight": "600"},
            "emptyText": {"color": C.muted, "fontSize": F.sm, "textAlign": "center"},
            "tabBar": {
                "flexDirection": "row",
                "borderTopWidth": 1,
                "borderTopColor": C.border,
                "backgroundColor": C.surface,
                "paddingTop": S.sm,
                "paddingBottom": S.lg
            },
            "tabItem": {"flex": 1, "alignItems": "center", "gap": 2},
            "tabLabel": {"color": C.muted, "fontSize": F.xs},
            "tabLabelOn": {"color": C.accent, "fontSize": F.xs, "fontWeight": "600"},
            "banner": {
                "flexDirection": "row",
                "alignItems": "center",
                "gap": S.sm,
                "backgroundColor": C.dangerSoft,
                "marginHorizontal": S.lg,
                "marginTop": S.md,
                "padding": S.md,
                "borderRadius": R.md
            },
            "bannerText": {"flex": 1, "color": C.danger, "fontSize": F.sm},
            "bannerAction": {
                "flexDirection": "row",
                "alignItems": "center",
                "gap": S.xs,
                "paddingHorizontal": S.sm,
                "paddingVertical": S.xs
            },
            "bannerActionLabel": {"color": C.text, "fontSize": F.sm, "fontWeight": "600"},
            "bannerClose": {"padding": S.xs},
            "authWrap": {
                "flex": 1,
                "justifyContent": "center",
                "padding": S.xl,
                "gap": S.lg
            },
            "errorText": {"color": C.danger, "fontSize": F.sm}
        }
    );
}
