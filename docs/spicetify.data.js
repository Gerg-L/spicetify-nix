import { loadOptions, stripNixStore } from "easy-nix-documentation/loader"
export default {
    async load() {
        const optionsJSON = process.env.SPICETIFY_OPTIONS_JSON
        if (optionsJSON === undefined) {
            console.log("SPICETIFY_OPTIONS_JSON is undefined");
            exit(1)
        }
        return await loadOptions(optionsJSON, {
            include: [/^(?!.*_module)/],
            mapDeclarations: declaration => {
                const relDecl = stripNixStore(declaration);
                return `<a href="https://github.com/Gerg-L/spicetify-nix/tree/master/${relDecl}">&lt;spicetify/${relDecl}&gt;</a>`
            },
        })
    }
}
