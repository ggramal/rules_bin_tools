"""
This module contains code for downloading helm tool 
"""
load("@rules_bin_tools//tools:utils.bzl", "get_sha256sum")

_TOOL_NAME = "helm"

def _download_impl(ctx):
    file = "{tool}-{version}-{os}-{arch}.tar.gz".format(
        tool = _TOOL_NAME,
        version = ctx.attr.version,
        os = ctx.attr.os,
        arch = ctx.attr.arch,
    )
    url  = "https://get.helm.sh/{file}".format(
        file = file
    )
    url_sha256sum = url + ".sha256sum"


    ctx.download(
        url = [url_sha256sum],
        output = "sha256sum",
    )

    data = ctx.read("sha256sum")
    sha256sum = get_sha256sum(data, file)
    if sha256sum == None or sha256sum == "":
        fail("Could not find sha256sum for file {}".format(file))

    ctx.download_and_extract(
        url = url,
        sha256 = sha256sum,
        type = "tar.gz", 
        output = _TOOL_NAME, 
    )


    ctx.file("BUILD.bazel", """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "executable",
    srcs = ["{tool}/{os}-{arch}/{tool}"],
    visibility = ["//visibility:public"]
)
""".format(tool=_TOOL_NAME, os=ctx.attr.os, arch=ctx.attr.arch))


helm_download = repository_rule(
    implementation = _download_impl,
    attrs = {
        "version": attr.string(mandatory = True),
        "os": attr.string(mandatory = True),
        "arch": attr.string(mandatory = True),
    },
)
