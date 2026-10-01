import from "@jac/mobui" { View, Text, ScrollView }

def:pub ProgressScreen(model: UpkeepState) -> JsxElement {
    theme = useTheme();
    C = theme.colors;
    styles = makeStyles(C);
    today = model.today;
    habits = today.habits if today else [];
    goals = today.goals if today else [];
    pct = today.week_pct if today else 0;
    <ScrollView style={styles.body} contentContainerStyle={styles.scroll}>
        <View style={styles.dayText}>
            <Text style={styles.title}>This week</Text>
            <Text style={styles.subtitle}>{"As of " + pretty_day(model.day)}</Text>
        </View>
        <View style={styles.card}>
            <Text style={styles.bigNumber}>{str(pct) + "%"}</Text>
            <Text style={styles.subtitle}>of this week's habit check-ins</Text>
            <View style={styles.track}>
                <View style={[styles.fillDone, {"width": str(pct) + "%"}]}/>
            </View>
        </View>
        <View style={styles.card}>
            <Text style={styles.cardTitle}>Goals</Text>
            {[
                <View key={g.id} style={styles.rowBody}>
                    <View style={styles.row}>
                        <Text style={styles.statName}>{g.title}</Text>
                        <Text style={styles.rowMeta}>{str(g.done) + "/" + str(g.target)}</Text>
                    </View>
                    <View style={styles.track}>
                        <View
                            style={[
                                (styles.fillDone if g.pct >= 100 else styles.fill),
                                {"width": str(g.pct) + "%"}
                            ]}
                        />
                    </View>
                </View> for g in goals
            ]}
            {if today and len(goals) == 0 {
                <EmptyState
                    icon="progress"
                    title="No goals yet"
                    hint="Set weekly goals on the web app and track them here."
                />
            }}
        </View>
        <View style={styles.card}>
            <Text style={styles.cardTitle}>Habit stats</Text>
            <View style={styles.row}>
                <Text style={styles.statName}></Text>
                <Text style={styles.statHead}>Streak</Text>
                <Text style={styles.statHead}>Best</Text>
                <Text style={styles.statHead}>Week</Text>
            </View>
            {[
                <View key={h.id} style={styles.statRow}>
                    <Text style={styles.statName}>{h.name}</Text>
                    <Text style={styles.statNum}>{str(h.current)}</Text>
                    <Text style={styles.statNum}>{str(h.longest)}</Text>
                    <Text style={styles.statNum}>{str(h.week_done)}</Text>
                </View> for h in habits
            ]}
        </View>
    </ScrollView>
}
