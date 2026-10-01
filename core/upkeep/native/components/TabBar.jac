import from "@jac/mobui" { View, Text, Pressable }

obj Tab {
    has key: str,
        icon: str,
        label: str;
}

glob TABS: list[Tab] = [
         Tab(key="today", icon="today", label="Today"),
         Tab(key="jobs", icon="jobs", label="Jobs"),
         Tab(key="progress", icon="progress", label="Progress")
     ];

def:pub TabBar(activeTab: str, onNavigate: Callable[[str], None]) -> JsxElement {
    theme = useTheme();
    C = theme.colors;
    styles = makeStyles(C);
    <View style={styles.tabBar}>
        {[
            <Pressable
                accessibilityRole="button"
                accessibilityLabel={t.label}
                accessibilityState={{"selected": activeTab == t.key}}
                style={styles.tabItem}
                key={t.key}
                onPress={lambda { onNavigate(t.key); }}
            >
                <Icon
                    name={t.icon}
                    size={22}
                    color={C.accent if activeTab == t.key else C.muted}
                />
                <Text
                    style={styles.tabLabelOn if activeTab == t.key else styles.tabLabel}
                >
                    {t.label}
                </Text>
            </Pressable> for t in TABS
        ]}
    </View>
}
