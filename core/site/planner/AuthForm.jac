def:pub AuthForm(session: Session) -> JsxElement {
    return
        <div className="mx-auto flex min-h-[80vh] max-w-sm flex-col justify-center px-4 pt-16">
            <div className="mb-6 text-center">
                <h1 className="text-3xl font-semibold tracking-tight">Upkeep</h1>
                <p className="mt-2 text-sm text-muted-foreground">
                    Habits, workouts, weekly goals and job applications, kept in one calm place.
                </p>
            </div>
            <Card>
                <CardContent>
                    <form
                        className="flex flex-col gap-3"
                        onSubmit={lambda (e: FormEvent) {
                            e.preventDefault();
                            session.submit();
                        }}
                    >
                        <h2 className="text-base font-medium">
                            {"Create your account" if session.signup else "Welcome back"}
                        </h2>
                        <Input
                            placeholder="Username"
                            autoComplete="username"
                            value={session.username}
                            onChange={lambda (e: ChangeEvent) {
                                session.setUsername(e.target.value);
                            }}
                        />
                        <Input
                            type="password"
                            placeholder="Password"
                            autoComplete={
                                "new-password" if session.signup else "current-password"
                            }
                            value={session.password}
                            onChange={lambda (e: ChangeEvent) {
                                session.setPassword(e.target.value);
                            }}
                        />
                        {if session.error {
                            <p className="text-sm text-destructive">{session.error}</p>
                        }}
                        <Button type="submit" disabled={session.busy}>
                            {"One moment..." if session.busy else ("Sign up" if session.signup else "Log in")}
                        </Button>
                    </form>
                </CardContent>
            </Card>
            <button
                type="button"
                className="mt-4 text-sm text-muted-foreground underline-offset-4 hover:underline"
                onClick={lambda { session.toggleMode(); }}
            >
                {"Already have an account? Log in" if session.signup else "New here? Create an account"}
            </button>
        </div>;
}
