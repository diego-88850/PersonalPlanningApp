glob TAB_LABELS: dict[str, str] = {"today": "Today", "goals": "Goals", "jobs": "Jobs"};

def:pub Planner -> JsxElement {
    model = useUpkeep();
    s = model.session;
    has tab: str = "today";

    if s.checking {
        return <p className="p-8 pt-24 text-muted-foreground">Loading...</p>;
    }
    if not s.loggedIn {
        return <AuthForm session={s}/>;
    }

    return
        <div className="mx-auto w-full max-w-5xl px-4 pb-16 pt-24 sm:px-6">
            <div className="mb-6 flex items-center justify-between gap-3">
                <nav className="flex gap-1 rounded-full bg-muted p-1">
                    {for key in ["today", "goals", "jobs"] {
                        <button
                            key={key}
                            onClick={lambda { tab = key; }}
                            className={cn(
                                "rounded-full px-4 py-1.5 text-sm font-medium transition-colors",
                                "bg-card text-foreground shadow-sm"
                                if tab == key
                                else "text-muted-foreground hover:text-foreground"
                            )}
                        >
                            {TAB_LABELS[key]}
                        </button>
                    }}
                </nav>
                <Button variant="ghost" size="sm" onClick={lambda { model.logout(); }}>
                    Log out
                </Button>
            </div>
            {if model.error {
                <div
                    className="mb-4 flex items-center justify-between gap-3 rounded-xl bg-destructive/10 px-4 py-2.5 text-sm text-destructive"
                >
                    <span>{model.error}</span>
                    <button
                        className="font-medium underline-offset-4 hover:underline"
                        onClick={lambda { model.dismissError(); }}
                    >
                        Dismiss
                    </button>
                </div>
            }}
            {if tab == "today" {
                <TodayTab model={model}/>
            }}
            {if tab == "goals" {
                <GoalsTab model={model}/>
            }}
            {if tab == "jobs" {
                <JobsTab model={model}/>
            }}
        </div>;
}
