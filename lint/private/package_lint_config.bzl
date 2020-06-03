
def _empty_rule_impl(ctx):
    return [
        DefaultInfo()
    ]

_empty_rule = rule(
    _empty_rule_impl,
    attrs = {
    },
)

OVERRIDE_RULE_NAME = "package_lint_config"

def package_lint_config(linters):
    if native.existing_rule(":%s" % OVERRIDE_RULE_NAME):
        fail("Lint configurations may only be overridden once per package")

    for (key, value) in linters.items():
        if not key.islower():
            fail("All linter names should be lower case. eg. \"java-checkstyle\": %s" % key)

        native.alias(
            name = "%s_%s" % (OVERRIDE_RULE_NAME, key),
            actual = value,
        )

    # Add a marker rule to indicate that we've finished overriding things
    _empty_rule(name = OVERRIDE_RULE_NAME)
