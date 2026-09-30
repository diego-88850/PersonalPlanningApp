import from "@jac/runtime" { Outlet }

def init_theme {
    saved = localStorage.getItem("jac-theme");
    if saved == "dark" {
        document.documentElement.classList.add("dark");
    } else {
        document.documentElement.classList.remove("dark");
    }
}

def:pub SiteShell -> JsxElement {
    init_theme();
    return
        <div
            className="min-h-screen overflow-x-clip bg-background text-foreground antialiased"
        >
            <Navbar/>
            <main>
                <Outlet/>
            </main>
        </div>;
}
