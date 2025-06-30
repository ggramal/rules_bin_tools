"""
This module contains code for downloading alloydb-auth-proxy tool 
"""

_TOOL_NAME = "alloydb-auth-proxy"

def _download_impl(ctx):
    url = "https://storage.googleapis.com/{tool}/{version}/{tool}.{os}.{arch}".format(
        tool = _TOOL_NAME,
        version = ctx.attr.version,
        os = ctx.attr.os,
        arch = ctx.attr.arch,
    )

    ctx.download(
        url = url,
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


alloydb_auth_proxy_download = repository_rule(
    implementation = _download_impl,
    attrs = {
        "version": attr.string(mandatory = True),
        "os": attr.string(mandatory = True),
        "arch": attr.string(mandatory = True),
    },
)
