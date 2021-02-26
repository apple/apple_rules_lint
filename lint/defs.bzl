load("@apple_linters//:defs.bzl", "configured_linters")
load(
    "//lint/private:package_lint_config.bzl",
    "OVERRIDE_RULE_NAME",
    _package_lint_config = "package_lint_config",
)

package_lint_config = _package_lint_config

def get_lint_config(linter_name, tags):
    """Gets the lint config for a particular linter from the tags of a rule.

    This will return either `None` or the label configured in `lint_setup`.
    If the tags `no-lint` or `no-linter_name` (eg. `no-java-checkstyle`) are
    found, then `None` will be returned. This allows linting to be turned off
    for specific rules.

    Args:
      linter_name: The "well known" name of the linter (eg. `java-checkstyle`)
      tags: The tags from the rule (eg. `ctx.attr.tags`)
    """
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
