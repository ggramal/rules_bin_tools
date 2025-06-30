"""
This module contains code for downloading kubectl tool 
"""
load("@rules_bin_tools//tools:utils.bzl", "get_sha256sum")

_TOOL_NAME = "kubectl"

def _download_impl(ctx):
    url = "https://dl.k8s.io/release/{version}/bin/{os}/{arch}/{tool}".format(
        tool = _TOOL_NAME,
        version = ctx.attr.version,
        os = ctx.attr.os,
        arch = ctx.attr.arch,
    )


    url_sha256sum = url + ".sha256"


    ctx.download(
        url = [url_sha256sum],
        output = "sha256sum",
    )

    data = ctx.read("sha256sum")
    sha256sum = get_sha256sum(data, "")

    ctx.download(
        url = url,
        sha256 = sha256sum,
        output = _TOOL_NAME,
        executable = True,
    )

    ctx.file("BUILD.bazel", """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "executable",
    srcs = ["{tool}"],
    visibility = ["//visibility:public"]
)
""".format(tool=_TOOL_NAME))


kubectl_download = repository_rule(
    implementation = _download_impl,
    attrs = {
        "version": attr.string(mandatory = True),
        "os": attr.string(mandatory = True),
        "arch": attr.string(mandatory = True),
    },
)
