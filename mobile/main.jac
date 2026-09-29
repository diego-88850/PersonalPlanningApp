import from "@jac/mobui" { View, Text }

def:pub app -> JsxElement {
    model = useUpkeep();
    return
        <View>
            <Text>
                {"Upkeep " + model.day + (" (signed in)" if model.session.loggedIn else "")}
            </Text>
        </View>;
}
