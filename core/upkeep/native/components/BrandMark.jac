import from "@jac/mobui" { Image }

def:pub BrandMark(size: int = 40) -> JsxElement {
    return
        <Image
            accessibilityLabel="Upkeep"
            source={{"uri": "/static/assets/upkeep-logo.svg"}}
            style={{"width": size, "height": size}}
        />;
}
