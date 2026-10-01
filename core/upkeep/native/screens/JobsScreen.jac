import from "@jac/mobui" { View, Text, Pressable, ScrollView }

def:pub JobsScreen(model: UpkeepState) -> JsxElement {
    theme = useTheme();
    C = theme.colors;
    styles = makeStyles(C);
    <ScrollView style={styles.body} contentContainerStyle={styles.scroll}>
        <View style={styles.dayText}>
            <Text style={styles.title}>Job applications</Text>
            <Text style={styles.subtitle}>Tap a status to update it.</Text>
        </View>
        {[
            <View key={a.id} style={styles.card}>
                <View style={styles.rowBody}>
                    <Text style={styles.cardTitle}>{a.company}</Text>
                    <Text style={styles.rowMeta}>
                        {a.position + " - applied " + short_day(a.applied_on)}
                    </Text>
                    {if a.notes {
                        <Text style={styles.rowMeta}>{a.notes}</Text>
                    }}
                </View>
                <View style={styles.chips}>
                    {[
                        <Pressable
                            key={st}
                            accessibilityRole="button"
                            accessibilityLabel={"Set " + a.company + " to " + st}
                            accessibilityState={{"selected": st == a.status}}
                            style={[styles.chip, (styles.chipOn if st == a.status else None)]}
                            onPress={lambda { model.setApplicationStatus(a.id, st); }}
                        >
                            <Text
                                style={[
                                    styles.chipLabel,
                                    (styles.chipLabelOn if st == a.status else None)
                                ]}
                            >
                                {st}
                            </Text>
                        </Pressable> for st in statuses()
                    ]}
                </View>
            </View> for a in model.applications
        ]}
        {if len(model.applications) == 0 {
            <EmptyState
                icon="jobs"
                title="No applications yet"
                hint="Add applications from the web app or the CLI and update their status here."
            />
        }}
    </ScrollView>
}
