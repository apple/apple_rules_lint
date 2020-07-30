# apple_rules_lint
A linting framework for Bazel

## Users

You must load and configure the linting framework before anything else.
This is because later rulesets that depend on the linting framework will
attempt to ensure that linters are configured by registering no-op 
implmentations of lint configs. You can do this by: 

```py
# WORKSPACE

load("@apple_rules_lint//lint:repositories.bzl", "lint_deps")

lint_deps()

load("@apple_rules_lint//lint:setup.bzl", "lint_setup")

lint_setup({
    "java-checkstyle": "//your:checkstyle-config",
})
```

You may override specific lint configurations on a per-package basis by:

```py
# BUILD.bazel

load("@apple_rules_lint//lint:defs.bzl", "package_lint_config")

package_lint_config({
    "java-checkstyle": ":alternative-checkstyle-config",
})
```

## Ruleset Authors

```py
# repositories.bzl
load("@apple_rules_lint//lint:repositories.bzl", "lint_deps")

lint_deps()
```

```py
# setup.bzl
load("@apple_rules_lint//lint:setup.bzl", "ruleset_lint_setup")

ruleset_lint_setup()
```

To obtain the currently configured config for a ruleset, use:

```py
# your_rules.bzl

load("@apple_rules_lint//lint:defs.bzl", "get_lint_config")

config = get_lint_config("java-checkstyle", tags)
if config != None:
    # set up lint targets
    pass
```

Where `tags` are the tags of the rule to check.
