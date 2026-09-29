def:pub Planner -> JsxElement {
    model = useUpkeep();
    s = model.session;
    has habitName: str = "";

    if s.checking {
        return <p className="p-8 pt-24">Loading...</p>;
    }

    if not s.loggedIn {
        return
            <form
                className="mx-auto flex max-w-sm flex-col gap-3 p-6 pt-24"
                onSubmit={lambda (e: FormEvent) {
                    e.preventDefault();
                    s.submit();
                }}
            >
                <h1 className="text-2xl font-bold">
                    {"Create account" if s.signup else "Log in"}
                </h1>
                <input
                    className="rounded border p-2"
                    placeholder="Username"
                    value={s.username}
                    onChange={lambda (e: ChangeEvent) { s.setUsername(e.target.value); }}
                />
                <input
                    className="rounded border p-2"
                    type="password"
                    placeholder="Password"
                    value={s.password}
                    onChange={lambda (e: ChangeEvent) { s.setPassword(e.target.value); }}
                />
                {if s.error {
                    <p className="text-sm text-red-500">{s.error}</p>
                }}
                <button
                    type="submit"
                    className="rounded bg-primary p-2 text-primary-foreground"
                    disabled={s.busy}
                >
                    {"Sign up" if s.signup else "Log in"}
                </button>
                <button
                    type="button"
                    className="text-sm underline"
                    onClick={lambda { s.toggleMode(); }}
                >
                    {"Have an account? Log in" if s.signup else "New here? Create an account"}
                </button>
            </form>;
    }

    async def submitHabit {
        added = await model.addHabit(habitName);
        if added {
            habitName = "";
        }
    }

    return
        <div className="mx-auto max-w-xl p-6 pt-24">
            <div className="mb-4 flex items-center justify-between">
                <div className="flex items-center gap-2">
                    <button onClick={lambda { model.shiftDay(-1); }}>{"<"}</button>
                    <h1 className="text-xl font-bold">{model.day}</h1>
                    <button onClick={lambda { model.shiftDay(1); }}>{">"}</button>
                </div>
                <button className="text-sm underline" onClick={lambda { model.logout(); }}>
                    Log out
                </button>
            </div>
            {if model.error {
                <p className="mb-3 text-sm text-red-500" onClick={lambda { model.dismissError(); }}>
                    {model.error}
                </p>
            }}
            {if model.today {
                <p className="mb-3 text-sm text-muted-foreground">
                    {"Week " + str(model.today.week_pct) + "%"}
                </p>
            }}
            <ul className="mb-4 flex flex-col gap-2">
                {for h in (model.today.habits if model.today else []) {
                    <li key={h.id}>
                        <label className="flex items-center gap-2">
                            <input
                                type="checkbox"
                                checked={h.done_today}
                                onChange={lambda (e: ChangeEvent) {
                                    model.toggleHabit(h.id, e.target.checked);
                                }}
                            />
                            {h.name}
                            <span className="text-xs text-muted-foreground">
                                {"streak " + str(h.current)}
                            </span>
                        </label>
                    </li>
                }}
            </ul>
            <form
                className="flex gap-2"
                onSubmit={lambda (e: FormEvent) {
                    e.preventDefault();
                    submitHabit();
                }}
            >
                <input
                    className="flex-1 rounded border p-2"
                    placeholder="New habit"
                    value={habitName}
                    onChange={lambda (e: ChangeEvent) { habitName = e.target.value; }}
                />
                <button type="submit" className="rounded border pl-3 pr-3">Add</button>
            </form>
        </div>;
}
