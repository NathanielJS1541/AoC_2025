TEMPLATE = """
native.genrule(
  name = {},
  visibility = ["//visibility:public"],
)
"""

def _impl(ctx):
  print("hmm")
  for i, line in enumerate(["a", "b", "c"]):
    print(i, line)
    new_local_repository(
      # name = "turn{:04}".format(i),
      name = "my_repo",
      path = "out/",
      build_file_content = TEMPLATE.format(line),
    )

_read_turns_params = tag_class(
  attrs = {
    "path": attr.label,
  },
)

read_turns = module_extension(
  implementation = _impl,
  tag_classes = {"file": _read_turns_params},
)


