# rules_binary_tools

bazel rules for downloading various binary tools like helm,kubectl etc for different platforms

## Motivation

Deterministically manage infrastructure tools using Bazel.

By leveraging Bazel, we eliminate the need for team members to manually manage tooling. Specifically, they no longer need to worry about:

1. **Which tools to download**  
2. **Where to install or store them locally**  
3. **What version of each tool to use**

This approach ensures consistency, reduces setup time, and prevents version drift across environments.


## Instalation

To import rules_binary_tools in your project, you first need to add it to your `MODULE.bazel` file:

```python
bazel_dep(name = "rules_bin_tools")
git_override(
    module_name = "rules_bin_tools",
    commit = "...",
    remote = "https://github.com/ggramal/rules_bin_tools",
)
tools = use_extension("@rules_bin_tools//tools:extensions.bzl", "tools")

tools.download(
    helm_version = "v3.18.3",
)
use_repo(tools, "helm_executable")
```

## Usage

Once imported you can use the executables in your targets like so

```python
#path/to/tf/BUILD

sh_binary(
    name = "example",
    data = [
        "@helm_executable//:executable",
    ],
    srcs = [
        "example.sh",
    ],
    env = {
        "EXECUTABLE": "$(rootpath @helm_executable//:executable)",
    }
)
```

More examples can be found in examples dir



