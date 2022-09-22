workspace(name = "apple_rules_lint")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
    ],
    sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

http_archive(
    name = "io_bazel_stardoc",
    sha256 = "05fb57bb4ad68a360470420a3b6f5317e4f722839abc5b17ec4ef8ed465aaa47",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/stardoc/releases/download/0.5.2/stardoc-0.5.2.tar.gz",
        "https://github.com/bazelbuild/stardoc/releases/download/0.5.2/stardoc-0.5.2.tar.gz",
    ],
)

load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")

stardoc_repositories()

load("//lint:repositories.bzl", "lint_deps")

lint_deps()

load("//lint:setup.bzl", "lint_setup")

lint_setup()
