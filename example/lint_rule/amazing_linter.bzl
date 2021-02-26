load("@apple_rules_lint//lint:defs.bzl", "get_lint_config")

ExampleConfigInfo = provider(
    fields = {
        "always_pass": "Whether the lint check should always pass",
    },
)

def _example_linter_config_impl(ctx):
    return [
        ExampleConfigInfo(
            always_pass = ctx.attr.always_pass,
        ),
    ]

example_linter_config = rule(
    _example_linter_config_impl,
    attrs = {
        "always_pass": attr.bool(),
    },
    provides = [
        ExampleConfigInfo,
    ],
)

def _lintable_test_impl(ctx):
    config = ctx.attr.config[ExampleConfigInfo]
    exit_flag = 0 if config.always_pass else 1

    test = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(
        test,
        "#!/bin/sh\nexit %d" % exit_flag,
        is_executable = True,
    )

    return [
        DefaultInfo(
            executable = test,
        ),
    ]

lintable_test = rule(
    _lintable_test_impl,
    test = True,
    attrs = {
        "target": attr.label(
            mandatory = True,
        ),
        "config": attr.label(
            providers = [
                [ExampleConfigInfo],
            ],
        ),
    },
)

def _lintable_rule_impl(ctx):
    return [
    ]

_lintable_rule = rule(
    _lintable_rule_impl,
    attrs = {
    },
)

def lintable_rule(name, tags = [], visibility = None):
    _lintable_rule(name = name, visibility = visibility)

    config = get_lint_config("lint_example", tags)
    if config != None:
        lintable_test(
            name = "%s-test" % name,
            target = name,
            config = config,
        )
