def _empty_rule_impl(ctx):
    return [
        DefaultInfo(),
    ]

_empty_rule = rule(
    _empty_rule_impl,
    attrs = {
    },
)

OVERRIDE_RULE_NAME = "package_lint_config"

def package_lint_config(linters):
    """Register the given linters for the current bazel package.

    This is expected to be near the top of the `BUILD.bazel` file and
    allows users to override or configure specific linters for a bazel
    package.

    Args:
      linters: a dict of "well known name" to Label.
    """

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
