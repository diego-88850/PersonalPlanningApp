import from "lucide-react" { Plus, Trash2 }

glob SELECT: str = "h-8 rounded-lg border border-input bg-transparent px-2 text-sm outline-none focus-visible:ring-3 focus-visible:ring-ring/50";

def:pub GoalsTab(model: UpkeepState) -> JsxElement {
    has title: str = "",
        kind: str = "habit",
        habitId: str = "",
        target: int = 3;
    today = model.today;
    habits = today.habits if today else [];
    goals = today.goals if today else [];
    pct = today.week_pct if today else 0;
    chosen = habitId or (habits[0].id if len(habits) > 0 else "");
    chosen_name = "";
    for h in habits {
        if h.id == chosen {
            chosen_name = h.name;
        }
    }
    suggestion = (
        (chosen_name if kind == "habit" else "Workouts") + " " + str(target) + "x"
    );

    async def submitGoal {
        added: bool = False;
        added = await model.addGoal(title if title.strip() else suggestion, kind, target, chosen if kind == "habit" else "");
        if added {
            title = "";
        }
    }

    return
        <div className="grid gap-6 lg:grid-cols-5">
            <div className="lg:col-span-5">
                <h1 className="text-2xl font-semibold tracking-tight">Weekly goals</h1>
                <p className="mt-1 text-sm text-muted-foreground">
                    {"Progress comes straight from your check-ins and workouts. As of " + pretty_day(model.day) + "."}
                </p>
            </div>
            <div className="flex flex-col gap-6 lg:col-span-3">
                <Card>
                    <CardHeader>
                        <CardTitle>Goals</CardTitle>
                    </CardHeader>
                    <CardContent>
                        {for g in goals {
                            <div key={g.id} className="group mb-4 last:mb-0">
                                <div className="mb-1 flex items-center justify-between gap-2 text-sm">
                                    <span className="flex items-center gap-2 font-medium">
                                        {g.title}
                                        <Badge variant="secondary">
                                            {"Habit" if g.kind == "habit" else "Workouts"}
                                        </Badge>
                                    </span>
                                    <span className="flex items-center gap-2 text-muted-foreground">
                                        {str(g.done) + "/" + str(g.target)}
                                        <button
                                            aria-label={"Delete " + g.title}
                                            onClick={lambda { model.removeItem(g.id); }}
                                            className="rounded-md p-1 hover:text-destructive"
                                        >
                                            <Trash2 className="size-4"/>
                                        </button>
                                    </span>
                                </div>
                                <div className="h-2.5 overflow-hidden rounded-full bg-muted">
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
                                No goals yet. Try "Gym 4x" below.
                            </p>
                        }}
                    </CardContent>
                </Card>
                <Card>
                    <CardHeader>
                        <CardTitle>New goal</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <form
                            className="flex flex-col gap-3"
                            onSubmit={lambda (e: FormEvent) {
                                e.preventDefault();
                                submitGoal();
                            }}
                        >
                            <div className="flex flex-wrap items-center gap-2 text-sm">
                                <span>Count</span>
                                <select
                                    className={SELECT}
                                    value={kind}
                                    onChange={lambda (e: ChangeEvent) { kind = e.target.value; }}
                                >
                                    <option value="habit">a habit</option>
                                    <option value="workout">workouts</option>
                                </select>
                                {if kind == "habit" {
                                    <select
                                        className={SELECT}
                                        value={chosen}
                                        onChange={lambda (e: ChangeEvent) {
                                            habitId = e.target.value;
                                        }}
                                    >
                                        {for h in habits {
                                            <option key={h.id} value={h.id}>{h.name}</option>
                                        }}
                                    </select>
                                }}
                                <select
                                    className={SELECT}
                                    value={str(target)}
                                    onChange={lambda (e: ChangeEvent) {
                                        target = int(e.target.value);
                                    }}
                                >
                                    {for n in [1, 2, 3, 4, 5, 6, 7] {
                                        <option key={n} value={str(n)}>{str(n) + " times"}</option>
                                    }}
                                </select>
                                <span>a week</span>
                            </div>
                            {if kind == "habit" and len(habits) == 0 {
                                <p className="text-sm text-muted-foreground">
                                    Add a habit on the Today tab first.
                                </p>
                            }}
                            <div className="flex gap-2">
                                <Input
                                    placeholder={"Name (optional): " + suggestion}
                                    value={title}
                                    onChange={lambda (e: ChangeEvent) { title = e.target.value; }}
                                />
                                <Button type="submit" variant="secondary">
                                    <Plus/>
                                    Add
                                </Button>
                            </div>
                        </form>
                    </CardContent>
                </Card>
            </div>
            <Card className="lg:col-span-2 self-start">
                <CardHeader>
                    <CardTitle>Habit stats</CardTitle>
                </CardHeader>
                <CardContent>
                    <p className="mb-4">
                        <span className="text-4xl font-semibold tracking-tight">
                            {str(pct) + "%"}
                        </span>
                        <span className="ml-2 text-sm text-muted-foreground">
                            of this week's check-ins
                        </span>
                    </p>
                    <table className="w-full text-sm">
                        <thead>
                            <tr className="text-left text-xs text-muted-foreground">
                                <th className="pb-2 font-medium">Habit</th>
                                <th className="pb-2 text-right font-medium">Streak</th>
                                <th className="pb-2 text-right font-medium">Best</th>
                                <th className="pb-2 text-right font-medium">Week</th>
                            </tr>
                        </thead>
                        <tbody>
                            {for h in habits {
                                <tr key={h.id} className="border-t border-border/60">
                                    <td className="py-2 font-medium">{h.name}</td>
                                    <td className="py-2 text-right">{str(h.current)}</td>
                                    <td className="py-2 text-right">{str(h.longest)}</td>
                                    <td className="py-2 text-right">{str(h.week_done)}</td>
                                </tr>
                            }}
                        </tbody>
                    </table>
                    {if today and len(habits) == 0 {
                        <p className="text-sm text-muted-foreground">No habits yet.</p>
                    }}
                </CardContent>
            </Card>
        </div>;
}
