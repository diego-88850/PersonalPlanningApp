import from "@jac/runtime" { Link }

def:pub NotFound -> JsxElement {
    return
        <section
            className="flex min-h-[80vh] items-center justify-center pt-16 text-center"
        >
            <div className="mx-auto max-w-xl px-6">
                <p className="font-mono text-sm text-primary">404</p>
                <h1 className="mt-3 text-5xl font-bold tracking-tight">
                    Nothing here.
                </h1>
                <div className="mt-8">
                    <Link
                        to="/"
                        className={buttonVariants().call(None, {"size": "lg"})}
                    >
                        Back to Upkeep
                    </Link>
                </div>
            </div>
        </section>;
}
