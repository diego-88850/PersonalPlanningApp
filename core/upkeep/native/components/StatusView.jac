import from "@jac/mobui" { View, Text }

def:pub EmptyState(icon: str, title: str, hint: str) -> JsxElement {
    theme = useTheme();
    C = theme.colors;
    styles = makeStyles(C);
    <View style={styles.empty}>
        <Icon name={icon} size={30} color={C.muted}/>
        <Text style={styles.emptyTitle}>{title}</Text>
        <Text style={styles.emptyText}>{hint}</Text>
    </View>
}
