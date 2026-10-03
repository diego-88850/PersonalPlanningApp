import from "@jac/mobui" {
    View,
    Text,
    Pressable,
    StatusBar,
    ActivityIndicator,
    KeyboardAvoidingView,
    Platform,
    useWindowDimensions
}

glob TAB_TITLES: dict[str, str] = {"today": "Today", "jobs": "Jobs", "progress": "Progress"};

def:pub UpkeepMobile -> JsxElement {
    theme = useTheme();
    C = theme.colors;
    styles = makeStyles(C);
    model = useUpkeep();
    viewport = useWindowDimensions();
    has tab: str = "today";

    if model.session.checking {
        return
            <View style={styles.center}>
                <ActivityIndicator size="large" color={C.accent}/>
            </View>;
    }

    if not model.session.loggedIn {
        return
            <KeyboardAvoidingView
                style={[styles.root, {"height": viewport.height}]}
                behavior={"padding" if Platform.OS == "ios" else "height"}
            >
                <StatusBar
                    barStyle={"light-content" if theme.dark else "dark-content"}
                    backgroundColor={C.bg}
                />
                <AuthScreen session={model.session}/>
            </KeyboardAvoidingView>;
    }

    <KeyboardAvoidingView
        style={[styles.root, {"height": viewport.height}]}
        behavior={"padding" if Platform.OS == "ios" else "height"}
    >
        <StatusBar
            barStyle={"light-content" if theme.dark else "dark-content"}
            backgroundColor={C.bg}
        />
        <View style={styles.page}>
            <View style={styles.header}>
                <View style={styles.brand}>
                    <View style={styles.brandDot}/>
                    <Text style={styles.brandTitle}>Upkeep</Text>
                </View>
                <View style={styles.headerActions}>
                    <Pressable
                        accessibilityRole="button"
                        accessibilityLabel="Refresh"
                        style={styles.iconButton}
                        onPress={lambda { model.refresh(); }}
                    >
                        <Icon name="refresh" size={20} color={C.muted}/>
                    </Pressable>
                    <Pressable
                        accessibilityRole="button"
                        accessibilityLabel="Toggle theme"
                        style={styles.iconButton}
                        onPress={lambda { theme.toggle(); }}
                    >
                        <Icon name={"sun" if theme.dark else "moon"} size={20} color={C.muted}/>
                    </Pressable>
                    <Pressable
                        accessibilityRole="button"
                        accessibilityLabel="Log out"
                        style={styles.iconButton}
                        onPress={lambda { model.logout(); }}
                    >
                        <Icon name="logout" size={20} color={C.muted}/>
                    </Pressable>
                </View>
            </View>
            {if model.error {
                <BridgeBanner
                    message={model.error}
                    canRetry={True}
                    onRetry={model.refresh}
                    onDismiss={model.dismissError}
                />
            }}
            <View style={styles.body}>
                {if tab == "today" {
                    <TodayScreen model={model}/>
                } elif tab == "jobs" {
                    <JobsScreen model={model}/>
                } else {
                    <ProgressScreen model={model}/>
                } }
            </View>
            <TabBar activeTab={tab} onNavigate={lambda (key: str) { tab = key; }}/>
        </View>
    </KeyboardAvoidingView>
}
