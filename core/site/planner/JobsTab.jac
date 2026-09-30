import from "lucide-react" { ArrowDown, ArrowUp, Plus, Trash2 }

glob STATUS_CLASS: dict[str, str] = {
         "Applied": "bg-muted text-foreground",
         "Online Assessment": "bg-amber-200/70 text-amber-950 dark:bg-amber-400/20 dark:text-amber-100",
         "Interview": "bg-primary/15 text-foreground",
         "Offer": "bg-[color:var(--success)]/25 text-foreground",
         "Rejected": "bg-destructive/10 text-destructive"
     },
     COLUMNS: list[str] = ["company", "position", "status", "applied_on"],
     COLUMN_LABELS: dict[str, str] = {
         "company": "Company",
         "position": "Position",
         "status": "Status",
         "applied_on": "Applied"
     };

def sort_value(a: ApplicationView, key: str) -> str {
    if key == "company" {
        return a.company.lower();
    }
    if key == "position" {
        return a.position.lower();
    }
    if key == "status" {
        rank = 0;
        seen = 0;
        for name in statuses() {
            if name == a.status {
                rank = seen;
            }
            seen += 1;
        }
        return str(rank);
    }
    return a.applied_on;
}

def:pub JobsTab(model: UpkeepState) -> JsxElement {
    has company: str = "",
        position: str = "",
        notes: str = "",
        sortKey: str = "applied_on",
        sortDesc: bool = True;

    rows = sorted(
        model.applications,
        key=lambda (a: ApplicationView) { sort_value(a, sortKey); },
        reverse=sortDesc
    );

    async def submitJob {
        added: bool = False;
        added = await model.addApplication(company, position, notes);
        if added {
            company = "";
            position = "";
            notes = "";
        }
    }

    def sortBy(key: str) {
        if sortKey == key {
            sortDesc = not sortDesc;
        } else {
            sortKey = key;
            sortDesc = key == "applied_on";
        }
    }

    return
        <div className="flex flex-col gap-6">
            <div>
                <h1 className="text-2xl font-semibold tracking-tight">Job applications</h1>
                <div className="mt-3 flex flex-wrap gap-2">
                    {for st in statuses() {
                        <span
                            key={st}
                            className={cn(
                                "rounded-full px-3 py-1 text-xs font-medium",
                                STATUS_CLASS[st]
                            )}
                        >
                            {st + " " + str(len([a for a in model.applications if a.status == st]))}
                        </span>
                    }}
                </div>
            </div>
            <Card>
                <CardContent>
                    <form
                        className="grid gap-2 sm:grid-cols-4"
                        onSubmit={lambda (e: FormEvent) {
                            e.preventDefault();
                            submitJob();
                        }}
                    >
                        <Input
                            placeholder="Company"
                            value={company}
                            onChange={lambda (e: ChangeEvent) { company = e.target.value; }}
                        />
                        <Input
                            placeholder="Position"
                            value={position}
                            onChange={lambda (e: ChangeEvent) { position = e.target.value; }}
                        />
                        <Input
                            placeholder="Notes (optional)"
                            value={notes}
                            onChange={lambda (e: ChangeEvent) { notes = e.target.value; }}
                        />
                        <Button type="submit">
                            <Plus/>
                            Add application
                        </Button>
                    </form>
                </CardContent>
            </Card>
            <Card>
                <CardContent>
                    <div className="overflow-x-auto">
                        <table className="w-full text-sm">
                            <thead>
                                <tr className="text-left text-xs text-muted-foreground">
                                    {for col in COLUMNS {
                                        <th
                                            key={col}
                                            className={cn(
                                                "pb-2 pr-3 font-medium",
                                                "hidden sm:table-cell" if col == "applied_on" else ""
                                            )}
                                        >
                                            <button
                                                className="inline-flex items-center gap-1 hover:text-foreground"
                                                onClick={lambda { sortBy(col); }}
                                            >
                                                {COLUMN_LABELS[col]}
                                                {if sortKey == col {
                                                    <span>
                                                        {if sortDesc {
                                                            <ArrowDown className="size-3"/>
                                                        } else {
                                                            <ArrowUp className="size-3"/>
                                                        } }
                                                    </span>
                                                }}
                                            </button>
                                        </th>
                                    }}
                                    <th className="hidden pb-2 pr-3 font-medium sm:table-cell">Notes</th>
                                    <th className="pb-2"></th>
                                </tr>
                            </thead>
                            <tbody>
                                {for a in rows {
                                    <tr key={a.id} className="border-t border-border/60">
                                        <td className="py-2.5 pr-3 font-medium">{a.company}</td>
                                        <td className="py-2.5 pr-3">{a.position}</td>
                                        <td className="py-2.5 pr-3">
                                            <select
                                                aria-label={"Status for " + a.company}
                                                className={cn(
                                                    "h-7 rounded-full border-0 px-3 text-xs font-medium outline-none focus-visible:ring-3 focus-visible:ring-ring/50",
                                                    STATUS_CLASS[a.status]
                                                )}
                                                value={a.status}
                                                onChange={lambda (e: ChangeEvent) {
                                                    model.setApplicationStatus(a.id, e.target.value);
                                                }}
                                            >
                                                {for st in statuses() {
                                                    <option key={st} value={st}>{st}</option>
                                                }}
                                            </select>
                                        </td>
                                        <td className="hidden whitespace-nowrap py-2.5 pr-3 text-muted-foreground sm:table-cell">
                                            {short_day(a.applied_on)}
                                        </td>
                                        <td className="hidden max-w-[14rem] truncate py-2.5 pr-3 text-muted-foreground sm:table-cell">
                                            {a.notes}
                                        </td>
                                        <td className="py-2.5 text-right">
                                            <button
                                                aria-label={"Delete " + a.company}
                                                onClick={lambda { model.removeItem(a.id); }}
                                                className="rounded-md p-1 text-muted-foreground hover:text-destructive"
                                            >
                                                <Trash2 className="size-4"/>
                                            </button>
                                        </td>
                                    </tr>
                                }}
                            </tbody>
                        </table>
                    </div>
                    {if len(model.applications) == 0 {
                        <p className="py-4 text-center text-sm text-muted-foreground">
                            No applications yet. Add your first one above.
                        </p>
                    }}
                </CardContent>
            </Card>
        </div>;
}
