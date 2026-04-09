include("../funcs/vid_tools.jl")
using .vid_tools

# convert file
convert_file(
  old_file="C:/Users/vikra/Downloads/old_video.mkv",
  new_file="C:/Users/vikra/Downloads/new_converted_video_1.mkv",
  from="00:00:00",
  to="00:00:25"
)


join_results = join_files(
  file_names=[
    "split_video_1.mkv",
    "split_video_2.mkv"
  ],
  folder_path="c:/users/vikra/downloads",
  output_file="full_video.mkv"
)
