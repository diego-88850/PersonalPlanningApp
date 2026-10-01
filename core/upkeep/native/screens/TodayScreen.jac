import from "@jac/mobui" { View, Text, Pressable, TextInput, ScrollView }

def:pub TodayScreen(model: UpkeepState) -> JsxElement {
    theme = useTheme();
    C = theme.colors;
    styles = makeStyles(C);
    has title: str = "",
        details: str = "";
    today = model.today;
    habits = today.habits if today else [];
    workouts = today.workouts if today else [];
    pct = today.week_pct if today else 0;

    async def submitWorkout {
        logged: bool = False;
        logged = await model.logWorkout(title, details);
        if logged {
            title = "";
            details = "";
        }
    }

    <ScrollView
        style={styles.body}
        contentContainerStyle={styles.scroll}
        keyboardShouldPersistTaps="handled"
    >
        <View style={styles.dayRow}>
            <View style={styles.dayText}>
                <Text style={styles.title}>{pretty_day(model.day)}</Text>
                <Text style={styles.subtitle}>
                    {"This week: " + str(pct) + "% of habit check-ins"}
                </Text>
            </View>
            <View style={styles.dayNav}>
                {if model.day != local_today() {
                    <Pressable
                        accessibilityRole="button"
                        style={styles.todayChip}
                        onPress={lambda { model.setDay(local_today()); }}
                    >
                        <Text style={styles.todayChipLabel}>Today</Text>
                    </Pressable>
                }}
                <Pressable
                    accessibilityRole="button"
                    accessibilityLabel="Previous day"
                    style={styles.navButton}
                    onPress={lambda { model.shiftDay(-1); }}
                >
                    <Icon name="left" size={18} color={C.text}/>
                </Pressable>
                <Pressable
                    accessibilityRole="button"
                    accessibilityLabel="Next day"
                    style={styles.navButton}
                    onPress={lambda { model.shiftDay(1); }}
                >
                    <Icon name="right" size={18} color={C.text}/>
                </Pressable>
            </View>
        </View>
        <View style={styles.track}>
            <View style={[styles.fillDone, {"width": str(pct) + "%"}]}/>
        </View>
        <View style={styles.card}>
            <Text style={styles.cardTitle}>Habits</Text>
            {[
                <Pressable
                    key={h.id}
                    accessibilityRole="button"
                    accessibilityLabel={("Uncheck " if h.done_today else "Check ") + h.name}
                    accessibilityState={{"checked": h.done_today}}
                    style={styles.row}
                    onPress={lambda { model.toggleHabit(h.id, not h.done_today); }}
                >
                    <View style={[styles.check, (styles.checkOn if h.done_today else None)]}>
                        {if h.done_today {
                            <Icon name="check" size={18} color={C.accentText}/>
                        }}
                    </View>
                    <View style={styles.rowBody}>
                        <Text style={[styles.rowTitle, (styles.rowDone if h.done_today else None)]}>
                            {h.name}
                        </Text>
                        <Text style={styles.rowMeta}>
                            {str(h.current) + " day streak, best " + str(h.longest)}
                        </Text>
                    </View>
                </Pressable> for h in habits
            ]}
            {if today and len(habits) == 0 {
                <EmptyState
                    icon="inbox"
                    title="No habits yet"
                    hint="Add habits from the web app or the CLI and they show up here."
                />
            }}
        </View>
        <View style={styles.card}>
            <Text style={styles.cardTitle}>Workout</Text>
            {[
                <View key={w.id} style={styles.workout}>
                    <Icon name="workout" size={18} color={C.accent}/>
                    <View style={styles.rowBody}>
                        <Text style={styles.rowTitle}>{w.title}</Text>
                        {if w.details {
                            <Text style={styles.rowMeta}>{w.details}</Text>
                        }}
                    </View>
                    <Pressable
                        accessibilityRole="button"
                        accessibilityLabel={"Delete " + w.title}
                        onPress={lambda { model.removeItem(w.id); }}
                    >
                        <Icon name="trash" size={18} color={C.muted}/>
                    </Pressable>
                </View> for w in workouts
            ]}
            <TextInput
                style={styles.input}
                value={title}
                placeholder="What did you train? e.g. Legs"
                placeholderTextColor={C.muted}
                onChangeText={lambda (t: str) { title = t; }}
            />
            <TextInput
                style={[styles.input, styles.inputMulti]}
                value={details}
                placeholder="Exercises, sets, notes"
                placeholderTextColor={C.muted}
                multiline={True}
                onChangeText={lambda (t: str) { details = t; }}
            />
            <Pressable
                accessibilityRole="button"
                style={styles.buttonSoft}
                onPress={lambda { submitWorkout(); }}
            >
                <Text style={styles.buttonSoftLabel}>Log workout</Text>
            </Pressable>
        </View>
    </ScrollView>
}
