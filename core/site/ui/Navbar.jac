import from "@jac/runtime" { Link }

import from "lucide-react" { Moon, Sun }

def:pub Navbar -> JsxElement {
    theme = useTheme();
    dark = theme.dark;

    can with [dark] entry {
        document.documentElement.classList.toggle("dark", dark);
    }

    return
        <header
            className="fixed inset-x-0 top-0 z-50 border-b border-border/60 bg-background/75 backdrop-blur-xl"
        >
            <div
                className="mx-auto flex h-16 max-w-7xl items-center gap-6 pl-4 pr-4 sm:pl-6 sm:pr-6 lg:pl-8 lg:pr-8"
            >
                <Link to="/" className="flex items-center gap-2.5">
                    <span className="size-3 rounded-full bg-primary"></span>
                    <span className="text-lg font-semibold tracking-tight">Upkeep</span>
                </Link>
                <div className="ml-auto flex items-center gap-2">
                    <button
                        onClick={lambda { theme.toggle(); }}
                        title="Toggle theme"
                        className={buttonVariants().call(
                            None, {"variant": "ghost", "size": "icon"}
                        )}
                    >
                        {if dark {
                            <Sun className="size-4"/>
                        } else {
                            <Moon className="size-4"/>
                        } }
                    </button>
                </div>
            </div>
        </header>;
}
