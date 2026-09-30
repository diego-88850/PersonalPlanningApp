import from "lucide-react" { Check, ChevronLeft, ChevronRight, Dumbbell, Flame, Plus, Trash2, X }

def:pub TodayTab(model: UpkeepState) -> JsxElement {
    has habitName: str = "",
        title: str = "",
        details: str = "";
    today = model.today;
    habits = today.habits if today else [];
    workouts = today.workouts if today else [];
    goals = today.goals if today else [];
    pct = today.week_pct if today else 0;

    async def submitHabit {
        added: bool = False;
        added = await model.addHabit(habitName);
        if added {
            habitName = "";
        }
    }

    async def submitWorkout {
        logged: bool = False;
        logged = await model.logWorkout(title, details);
        if logged {
            title = "";
            details = "";
        }
    }

    return
        <div className="grid gap-6 lg:grid-cols-5">
            <div className="flex flex-wrap items-end justify-between gap-3 lg:col-span-5">
                <div>
                    <h1 className="text-2xl font-semibold tracking-tight">
                        {pretty_day(model.day)}
                    </h1>
                    <p className="mt-1 text-sm text-muted-foreground">
                        {"This week: " + str(pct) + "% of habit check-ins done"}
                    </p>
                    <div className="mt-2 h-2 w-56 overflow-hidden rounded-full bg-muted">
                        <div
                            className="h-full rounded-full bg-[color:var(--success)] transition-all"
                            style={{"width": str(pct) + "%"}}
                        ></div>
                    </div>
                </div>
                <div className="flex items-center gap-1">
                    <Button
                        variant="outline"
                        size="icon"
                        aria-label="Previous day"
                        onClick={lambda { model.shiftDay(-1); }}
                    >
                        <ChevronLeft/>
                    </Button>
                    {if model.day != local_today() {
                        <Button
                            variant="outline"
                            size="sm"
                            onClick={lambda { model.setDay(local_today()); }}
                        >
                            Today
                        </Button>
                    }}
                    <Button
                        variant="outline"
                        size="icon"
                        aria-label="Next day"
                        onClick={lambda { model.shiftDay(1); }}
                    >
                        <ChevronRight/>
                    </Button>
                </div>
            </div>
            <Card className="self-start lg:col-span-3">
                <CardHeader>
                    <CardTitle>Habits</CardTitle>
                </CardHeader>
                <CardContent>
                    <ul className="flex flex-col">
                        {for h in habits {
                            <li
                                key={h.id}
                                className="group flex items-center gap-3 rounded-xl px-2 py-2 hover:bg-muted/60"
                            >
                                <button
                                    aria-label={
                                        ("Uncheck " if h.done_today else "Check ") + h.name
                                    }
                                    aria-pressed={h.done_today}
                                    onClick={lambda { model.toggleHabit(h.id, not h.done_today); }}
                                    className={cn(
                                        "flex size-7 shrink-0 items-center justify-center rounded-full border-2 transition-colors",
                                        "border-[color:var(--success)] bg-[color:var(--success)] text-white"
                                        if h.done_today
                                        else "border-border hover:border-primary"
                                    )}
                                >
                                    {if h.done_today {
                                        <Check className="size-4"/>
                                    }}
                                </button>
                                <div className="min-w-0 flex-1">
                                    <p
                                        className={cn(
                                            "truncate font-medium",
                                            "text-muted-foreground line-through"
                                            if h.done_today
                                            else ""
                                        )}
                                    >
                                        {h.name}
                                    </p>
                                    <p className="flex items-center gap-1 text-xs text-muted-foreground">
                                        {if h.current > 0 {
                                            <Flame className="size-3.5 text-primary"/>
                                        }}
                                        {str(h.current) + " day streak, best " + str(h.longest)}
                                    </p>
                                </div>
                                <button
                                    aria-label={"Archive " + h.name}
                                    onClick={lambda { model.archiveHabit(h.id); }}
                                    className="rounded-md p-1 text-muted-foreground hover:text-foreground sm:opacity-0 sm:group-hover:opacity-100 focus:opacity-100"
                                >
                                    <X className="size-4"/>
                                </button>
                            </li>
                        }}
                    </ul>
                    {if today and len(habits) == 0 {
                        <p className="px-2 py-3 text-sm text-muted-foreground">
                            No habits yet. Add one below: medicine, stretching, reading.
                        </p>
                    }}
                    <form
                        className="mt-3 flex gap-2"
                        onSubmit={lambda (e: FormEvent) {
                            e.preventDefault();
                            submitHabit();
                        }}
                    >
                        <Input
                            placeholder="New habit"
                            value={habitName}
                            onChange={lambda (e: ChangeEvent) { habitName = e.target.value; }}
                        />
                        <Button type="submit" variant="secondary">
                            <Plus/>
                            Add
                        </Button>
                    </form>
                </CardContent>
            </Card>
            <div className="flex flex-col gap-6 lg:col-span-2">
                <Card>
                    <CardHeader>
                        <CardTitle>Workout</CardTitle>
                    </CardHeader>
                    <CardContent>
                        {for w in workouts {
                            <div
                                key={w.id}
                                className="group mb-3 flex items-start gap-3 rounded-xl bg-muted/60 px-3 py-2"
                            >
                                <Dumbbell className="mt-0.5 size-4 shrink-0 text-primary"/>
                                <div className="min-w-0 flex-1">
                                    <p className="font-medium">{w.title}</p>
                                    {if w.details {
                                        <p className="whitespace-pre-line text-xs text-muted-foreground">
                                            {w.details}
                                        </p>
                                    }}
                                </div>
                                <button
                                    aria-label={"Delete " + w.title}
                                    onClick={lambda { model.removeItem(w.id); }}
                                    className="rounded-md p-1 text-muted-foreground hover:text-destructive"
                                >
                                    <Trash2 className="size-4"/>
                                </button>
                            </div>
                        }}
                        <form
                            className="flex flex-col gap-2"
                            onSubmit={lambda (e: FormEvent) {
                                e.preventDefault();
                                submitWorkout();
                            }}
                        >
                            <Input
                                placeholder="What did you train? e.g. Legs"
                                value={title}
                                onChange={lambda (e: ChangeEvent) { title = e.target.value; }}
                            />
                            <Textarea
                                rows={2}
                                placeholder="Exercises, sets, notes"
                                value={details}
                                onChange={lambda (e: ChangeEvent) { details = e.target.value; }}
                            />
                            <Button type="submit" variant="secondary">Log workout</Button>
                        </form>
                    </CardContent>
                </Card>
                <Card>
                    <CardHeader>
                        <CardTitle>Goals this week</CardTitle>
                    </CardHeader>
                    <CardContent>
                        {for g in goals {
                            <div key={g.id} className="mb-3">
                                <div className="mb-1 flex justify-between text-sm">
                                    <span className="font-medium">{g.title}</span>
                                    <span className="text-muted-foreground">
                                        {str(g.done) + "/" + str(g.target)}
                                    </span>
                                </div>
                                <div className="h-2 overflow-hidden rounded-full bg-muted">
                                    <div
                                        className={cn(
                                            "h-full rounded-full transition-all",
                                            "bg-[color:var(--success)]" if g.pct >= 100 else "bg-primary"
                                        )}
                                        style={{"width": str(g.pct) + "%"}}
                                    ></div>
                                </div>
                            </div>
                        }}
                        {if today and len(goals) == 0 {
                            <p className="text-sm text-muted-foreground">
                                Set weekly goals in the Goals tab.
                            </p>
                        }}
                    </CardContent>
                </Card>
            </div>
        </div>;
}
