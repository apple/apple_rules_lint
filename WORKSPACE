workspace(name = "apple_rules_lint")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
    url = "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

http_archive(
    name = "io_bazel_stardoc",
    sha256 = "87eab53c2f1378ebec022f89097e56351e8b008a10433a0e1db660bd27aa46a9",
    strip_prefix = "stardoc-8275ced1b6952f5ad17ec579a5dd16e102479b72",
    url = "https://github.com/bazelbuild/stardoc/archive/8275ced1b6952f5ad17ec579a5dd16e102479b72.zip",
)

load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")

stardoc_repositories()

load("//lint:repositories.bzl", "lint_deps")

lint_deps()

load("//lint:setup.bzl", "lint_setup")

lint_setup()
