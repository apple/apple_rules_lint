load("//lint/private:register_linters.bzl", "COMMON_NAME", "register_linters")

def _linter_impl(module_ctx):
    linters = {}

    for mod in module_ctx.modules:
        for tag in mod.tags.register:
            if not tag.name.islower():
                fail("Linter names are expected to be in lowercase: {linter}".format(
                    linter = tag.name,
                ))
            if tag.name in linters:
                fail("Linter '{linter}' has been registered by both '{mod_1}' and '{mod_2}'".format(
                    linter = tag.name,
                    mod_1 = linters[tag.name],
                    mod_2 = mod.name,
                ))
            linters[tag.name] = mod.name

    name_to_linter_config = {}
    for mod in module_ctx.modules:
        # Only the root module's linter configuration should apply.
        if not mod.is_root:
            continue
        for tag in mod.tags.configure:
            if tag.name not in linters:
                fail("Linter '{linter}' has not been registered".format(
                    linter = tag.name,
                ))
            if tag.name in name_to_linter_config:
                fail("Linter '{linter}' is configured multiple times".format(
                    linter = tag.name,
                ))
            name_to_linter_config[tag.name] = str(tag.config)

    register_linters(
        name = COMMON_NAME,
        linters = name_to_linter_config,
    )

_register = tag_class(
    attrs = {
        "name": attr.string(mandatory = True),
    },
)

_configure = tag_class(
    attrs = {
        "name": attr.string(mandatory = True),
        "config": attr.label(mandatory = True),
    },
)

linter = module_extension(
    implementation = _linter_impl,
    tag_classes = {
        "register": _register,
        "configure": _configure,
    },
)
