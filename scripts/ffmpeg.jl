include("../funcs/vid_tools.jl")
using .vid_tools

# convert file
convert_file(
  old_file="C:/Users/vikra/Downloads/old_video.mkv",
  new_file="C:/Users/vikra/Downloads/new_converted_video.mkv",
  from="00:00:00",
  to="00:00:10"
)
