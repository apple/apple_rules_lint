
def _register_linters_impl(repository_ctx):
  linter_names = [name.lower() for name in repository_ctx.attr.linters.keys()]
  repository_ctx.file("defs.bzl", "configured_linters = %s" % linter_names)

  # Ensure that all values are actually labels
  linters = {}
  for (name, value) in repository_ctx.attr.linters.items():
      # Apparently the `Label` isn't available in this context. *sigh*
      # Manually munge rule names so that they evaluate nicely
      if value.startswith("//"):
        linters.update({name.lower(): "@%s" % value})
      elif value.startswith(":"):
        linters.update({name.lower(): "@//%s" % value})
      else:
        linters.update({name.lower(): value})

  repository_ctx.file(
        "BUILD.bazel",
        """
load("@apple_rules_lint//lint/private:package_lint_config.bzl", "package_lint_config")

package(default_visibility = ["//visibility:public"])

package_lint_config(%s)
""" % repr(linters))


_register_linters = repository_rule(
  _register_linters_impl,
  attrs = {
    "linters": attr.string_dict(
        doc = "Dict of well-known linter name to label of linter configuration.",
        allow_empty = True,
    ),
  },
)

def _do_register_linters(name_to_linter_config):
    for name in name_to_linter_config.keys():
        if not name.islower():
            fail("Linter names are expected to be in lowercase: %s" % name)

    _register_linters(
        name = "apple_linters",
        linters = name_to_linter_config)


def lint_setup(name_to_linter_config = {}):
  if native.existing_rule("apple_linters"):
    fail(
      "Linting has already been configured. Please ensure that the call " +
      "to `register_linters` is included as early as possible in your " +
      "WORKSPACE. If you experience problems or need help, please raise an issue " +
      "at https://github.com/apple/apple_rules_lint/issues/new")
    return

  # Ensure that labels are correct
  _do_register_linters(name_to_linter_config)


def ruleset_lint_setup():
  _do_register_linters({})
