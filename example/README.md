# Example Lint Project

This example demonstrates some of the features of the `apple_rules_lint`.

To get started run:

`bazel build //project/...`

The build will pass. It should do! It does almost nothing! Now run:

`bazel test //project/...`

No tests are run. Boo! That's no fun! But all's not lost! Open up the `WORKSPACE` and change:

```py
lint_setup({
#    "lint_example": "//:default_config",
})
```

to:

```py
lint_setup({
    "lint_example": "//:default_config",
})
```

What does this do? It says that rules that are aware of the `lint_example`
tool should be using the `//:default_config` configuration for tests. By 
default, we've set this up to fail all the lint tests.

But if you look closely, not all the lint tests have failed. This is because
the build file in `//project/override` uses the `package_lint_config_override`
rule to override the configuration for the `lint_example` tool.

