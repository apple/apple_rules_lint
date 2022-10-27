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

Alternatively, using Bzlmod:

```py
# MODULE.bazel
bazel_dep(name = "apple_rules_lint", version = "0.1.1")

linter = use_extension("@apple_rules_lint//lint:extensions.bzl", "linter")
linter.configure(name = "java-checkstyle", config = "//your:checkstyle-config")
```

You may override specific lint configurations on a per-package basis by:

```py
# BUILD.bazel

load("@apple_rules_lint//lint:defs.bzl", "package_lint_config")

package_lint_config({
    "java-checkstyle": ":alternative-checkstyle-config",
})
```

### API Documentation

Can be found in [the api docs](api.md)

## Ruleset Authors

### WORKSPACE setup

To add linter support to your repo, add this to...

```py
# repositories.bzl
load("@apple_rules_lint//lint:repositories.bzl", "lint_deps")

lint_deps()
```

Then add this to...

```py
# setup.bzl
load("@apple_rules_lint//lint:setup.bzl", "ruleset_lint_setup")

ruleset_lint_setup()
```

### Bzlmod setup

Add:

```py
# MODULE.bazel

bazel_dep(name = "apple_rules_lint", version = "0.1.1")

linter = use_extension("@apple_rules_lint//lint:extensions.bzl", "linter")
linter.register(name = "java-checkstyle")
```

### Getting the configured config for a linter

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


# Integrating `apple_rules_lint` With Your Rulesets

For the sake of this example, we'll show how `apple_rules_lint` is
integrated with the Selenium project, but the same process can be
followed for any linter:

1. Wrap the linter with a `_test` rule, so you can run them with bazel
   test. In Selenium, this is the
   [spotbugs_test](https://github.com/SeleniumHQ/selenium/blob/selenium-4.0.0-beta-1/java/private/spotbugs.bzl)

2. It is recommended, but not required, that your test return a `LinterInfo`
   so that other tooling can detect whether this is a lint test.

3. Create a config rule or a marker rule of some sort. For example,
   [spotbugs_config](https://github.com/SeleniumHQ/selenium/blob/selenium-4.0.0-beta-1/java/private/spotbugs_config.bzl)

4. Pick a "well known" name: `lang-tool` seems to work well (such as
   `java-spotbugs`, but you might have `go-gofmt` or `py-black`)

5. Create a macro that uses
   [get_lint_config](./api.md#get_lint_config) to look up the config
   for you. If that's present, create a new instance of your test
   rule. You can see this in action
   [here](https://github.com/SeleniumHQ/selenium/blob/selenium-4.0.0-beta-1/java/private/library.bzl).

6. As you write code, make sure your macro is called. If you're a
   ruleset author, this can be as lightweight as exporting the macro created
   above as the default way to call your rules.

7. ...

8. Profit!

Users can then use the "well known" name to point to an instance of
the config rule in their `WORKSPACE` files:

```starlark
lint_setup({
    "java-spotbugs": "//java:spotbugs-config",
})
```
