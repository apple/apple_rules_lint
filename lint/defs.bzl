load("@apple_linters//:defs.bzl", "configured_linters")
load(
    "//lint/private:package_lint_config.bzl",
    "OVERRIDE_RULE_NAME",
    _package_lint_config = "package_lint_config",
)

package_lint_config = _package_lint_config


def get_lint_config(linter_name, tags):
    if not linter_name.islower():
        fail("Linter names are expected to be in lowercase: %s" % linter_name)

    skip_names = [
        "no-lint",
        "no-%s" % linter_name,
    ]
    skip_tags = [name for name in skip_names if name in tags]
    if len(skip_tags) > 0:
        return None

    if native.existing_rule("%s_%s" % (OVERRIDE_RULE_NAME, linter_name)) != None:
        return Label("@//%s:%s_%s" % (native.package_name(), OVERRIDE_RULE_NAME, linter_name))

    if linter_name in configured_linters:
        return Label("@apple_linters//:%s_%s" % (OVERRIDE_RULE_NAME, linter_name))

    return None
