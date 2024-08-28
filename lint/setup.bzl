load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
load("//lint/private:register_linters.bzl", "COMMON_NAME", "register_linters")

def do_register_linters(name_to_linter_config):
    for name in name_to_linter_config.keys():
        if not name.islower():
            fail("Linter names are expected to be in lowercase: %s" % name)

    register_linters(
        name = COMMON_NAME,
        linters = name_to_linter_config,
    )

def lint_setup(name_to_linter_config = {}):
    """Register the given linters.

    This rule is designed to be run by users from the `WORKSPACE`. Ruleset
    authors are expected to use `ruleset_lint_config`.

    Args:
         linters: a dict of "well known name" to Label.
    """

    bazel_skylib_workspace()

    if native.existing_rule(COMMON_NAME):
        fail(
            "Linting has already been configured. Please ensure that the call " +
            "to `register_linters` is included as early as possible in your " +
            "WORKSPACE. If you experience problems or need help, please raise an issue " +
            "at https://github.com/apple/apple_rules_lint/issues/new",
        )
        return

    # Ensure that labels are correct
    do_register_linters(name_to_linter_config)

def ruleset_lint_setup():
    """Register the given linters.

    This rule is designed to be run by authors of rulesets so that they
    can ensure that they can call `get_lint_config` safely. Users should
    use `lint_setup` instead.
    """

    if not native.existing_rule(COMMON_NAME):
        do_register_linters({})
