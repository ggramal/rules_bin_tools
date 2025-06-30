"""
module extensions
"""

load("@rules_bin_tools//tools:utils.bzl", "detect_host_platform")
load("@rules_bin_tools//tools/alloydb_auth_proxy:download.bzl", "alloydb_auth_proxy_download")
load("@rules_bin_tools//tools/helm:download.bzl", "helm_download")
load("@rules_bin_tools//tools/kubectl:download.bzl", "kubectl_download")

def _impl(ctx):
    host_os, host_arch = detect_host_platform(ctx)

    for module in ctx.modules:
        for index, tag in enumerate(module.tags.download):  # buildifier: disable=unused-variable
            if tag.alloydb_auth_proxy_version:
                alloydb_auth_proxy_download(
                    name = "alloydb_auth_proxy_" + tag.suffix,
                    version = tag.alloydb_auth_proxy_version,
                    os = host_os,
                    arch = host_arch,
                )
            if tag.helm_version:
                helm_download(
                    name = "helm_" + tag.suffix,
                    version = tag.helm_version,
                    os = host_os,
                    arch = host_arch,
                )
            if tag.kubectl_version:
                kubectl_download(
                    name = "kubectl_" + tag.suffix,
                    version = tag.kubectl_version,
                    os = host_os,
                    arch = host_arch,
                )

_download = tag_class(
    attrs = {
        "alloydb_auth_proxy_version": attr.string(),
        "helm_version": attr.string(),
        "kubectl_version": attr.string(),
        "suffix": attr.string(default = "executable"),
    },
)

tools = module_extension(
    implementation = _impl,
    tag_classes = {
        "download": _download,
    },
    os_dependent = True,
    arch_dependent = True,
)
