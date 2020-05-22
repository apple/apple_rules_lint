
def _register_linters_impl(repository_ctx):
  repository_ctx.file("BUILD.bazel", "")
  repository_ctx.file("defs.bzl", "configured_linters = %s" % repository_ctx.attr.linter_names)


_register_linters = repository_rule(
  _register_linters_impl,
  attrs = {
    "linter_names": attr.string_list(allow_empty = True)
  },
)


def _do_register_linters(name_to_linter_config = {}):
  native.register_toolchains(*name_to_linter_config.values())

  _register_linters(
    "apple_linters",
    linter_names = name_to_linter_config.keys())


def register_linters(name_to_linter_config = {}):
  if native.existing_rule("apple_linters"):
    # we do want this on one line to prevent the message being
    # broken up with random logging prefix.
    fail(
      "Linting has already been configured. Please ensure that the call "
      "to `register_linters` is included as early as possible in your "
      "WORKSPACE. If you experience problems or need help, please ask on "
      "the #bazel-users slack channel")
    return

  _do_register_linters(name_to_linter_config)

def ruleset_register_linters():
  _do_register_linters({})
 
