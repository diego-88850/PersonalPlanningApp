import from "@jac/mobui" { View, Text, Pressable, TextInput, ActivityIndicator }

def:pub AuthScreen(session: Session) -> JsxElement {
    theme = useTheme();
    C = theme.colors;
    styles = makeStyles(C);
    <View style={styles.authWrap}>
        <View style={styles.dayText}>
            <Text style={styles.title}>Upkeep</Text>
            <Text style={styles.subtitle}>
                Habits, workouts, weekly goals and job applications, kept in one calm place.
            </Text>
        </View>
        <View style={styles.card}>
            <Text style={styles.cardTitle}>
                {"Create your account" if session.signup else "Welcome back"}
            </Text>
            <TextInput
                style={styles.input}
                value={session.username}
                placeholder="Username"
                placeholderTextColor={C.muted}
                autoCapitalize="none"
                autoCorrect={False}
                onChangeText={lambda (t: str) { session.setUsername(t); }}
            />
            <TextInput
                style={styles.input}
                value={session.password}
                placeholder="Password"
                placeholderTextColor={C.muted}
                secureTextEntry={True}
                autoCapitalize="none"
                onChangeText={lambda (t: str) { session.setPassword(t); }}
                onSubmitEditing={lambda { session.submit(); }}
            />
            {if session.error {
                <Text style={styles.errorText}>{session.error}</Text>
            }}
            <Pressable
                accessibilityRole="button"
                style={[styles.button, (styles.disabled if session.busy else None)]}
                disabled={session.busy}
                onPress={lambda { session.submit(); }}
            >
                {if session.busy {
                    <ActivityIndicator size="small" color={C.accentText}/>
                } else {
                    <Text style={styles.buttonLabel}>
                        {"Sign up" if session.signup else "Log in"}
                    </Text>
                } }
            </Pressable>
        </View>
        <Pressable accessibilityRole="button" onPress={lambda { session.toggleMode(); }}>
            <Text style={styles.link}>
                {"Already have an account? Log in" if session.signup else "New here? Create an account"}
            </Text>
        </Pressable>
    </View>
}
