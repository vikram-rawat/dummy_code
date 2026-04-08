include("../funcs/vid_tools.jl")
using .vid_tools

# convert file
convert_file(
  old_file="C:/Users/vikra/Downloads/old_video.mkv",
  new_file="C:/Users/vikra/Downloads/new_converted_video.mkv",
  from="00:00:00",
  to="00:00:05"
)

function ask_user()
  print("Continue? [y/n]: ")
  flush(stdout)
  answer = readline(stdin)
  return answer
end

res = ask_user()
