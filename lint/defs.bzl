load("//lint/private:get_lint_config.bzl", _get_lint_config = "get_lint_config")
load(
    "//lint/private:package_lint_config.bzl",
    _package_lint_config = "package_lint_config",
)
load("//lint/private:providers.bzl", _LinterInfo = "LinterInfo")

LinterInfo = _LinterInfo
get_lint_config = _get_lint_config
package_lint_config = _package_lint_config
