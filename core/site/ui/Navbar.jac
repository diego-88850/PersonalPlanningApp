import from "@jac/runtime" { Link }

import from "@hugeicons/react" { HugeiconsIcon }
import from "@hugeicons/core-free-icons" { Moon01Icon, Sun01Icon }

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
                    <span className="text-lg font-bold tracking-tight">Upkeep</span>
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
                            <HugeiconsIcon
                                icon={Sun01Icon}
                                strokeWidth={2}
                                className="size-4"
                            />
                        } else {
                            <HugeiconsIcon
                                icon={Moon01Icon}
                                strokeWidth={2}
                                className="size-4"
                            />
                        } }
                    </button>
                </div>
            </div>
        </header>;
}
