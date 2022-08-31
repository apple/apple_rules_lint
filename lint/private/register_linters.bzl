COMMON_NAME = "apple_linters"

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
            linters.update({name.lower(): "@//%s%s" % (native.package_name, value)})
        else:
            linters.update({name.lower(): value})

    repository_ctx.file(
        "BUILD.bazel",
        """
load("@apple_rules_lint//lint/private:package_lint_config.bzl", "package_lint_config")

package(default_visibility = ["//visibility:public"])

package_lint_config(%s)

exports_files(["defs.bzl"])
""" % repr(linters),
    )

register_linters = repository_rule(
    _register_linters_impl,
    attrs = {
        "linters": attr.string_dict(
            doc = "Dict of well-known linter name to label of linter configuration.",
            allow_empty = True,
        ),
    },
)
