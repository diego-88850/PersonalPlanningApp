import from "@jac/runtime" { Outlet }

def init_theme {
    saved = localStorage.getItem("jac-theme");
    if saved == "dark" {
        document.documentElement.classList.add("dark");
    } else {
        document.documentElement.classList.remove("dark");
    }
}

def set_head {
    document.title = "Upkeep";
    icon: any = document.createElement("link");
    icon.rel = "icon";
    icon.href = "/static/assets/upkeep-logo.svg";
    head: any = document.head;
    head.appendChild(icon);
}

def:pub SiteShell -> JsxElement {
    init_theme();
    can with entry {
        set_head();
    }
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
