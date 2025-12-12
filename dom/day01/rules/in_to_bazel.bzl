IN_BAZEL_COMMAND = """
sed -e "s/R/+/g" -e "s/L/-/g" $1 |
jq -Rn "[inputs | tonumber]" |
sed "s/\\[/turns = \\[/" > $2
"""

def _in_bazel_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    src = ctx.attr.src.files.to_list()[0]
    ctx.actions.run_shell(
      inputs = [src],
      command = IN_BAZEL_COMMAND,
      arguments = [src.path, out.path],
      outputs = [out],
    )
    return [DefaultInfo(
      files = depset([out]),
    )]

in_bazel = rule(
    implementation = _in_bazel_impl,
    attrs = {
      "src": attr.label(allow_single_file = True),
    }
)
