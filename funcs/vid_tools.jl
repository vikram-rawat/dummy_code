module vid_tools

# Add the other functions here
export convert_file, join_files, fix_audio_delay

using Printf
using Gtk4


"""
======================
This function converts a video file 
======================
"""
function convert_file(;
  old_file::String,
  new_file::String,
  from::String="00:00:00",
  to::String="",
  scale_height::Int=480   # new option, default 480
)
  # 1. Validation
  if length(from) < 8
    error("Invalid 'from' time format. Use HH:MM:SS")
  end

  # 2. Interactive Overwrite
  overwrite_flag = "-n"
  if isfile(new_file)
    println("====================")
    println("New File already exists. Please Select an Option...")
    println("====================")
    result = Gtk4.ask_dialog("File already exists. Do you want to overwrite?")
    overwrite_flag = result ? "-y" : "-n"
  end

  # 3. Build Command Components
  # Using an array is cleaner for 'run' in Julia
  args = ["ffmpeg", overwrite_flag, "-i", old_file]

  # Video filters and seeking
  append!(args, ["-vf", "scale=-2:$scale_height", "-ss", from])

  if !isempty(to) && length(to) >= 8
    append!(args, ["-to", to])
  end

  # Encoding settings
  append!(args, ["-c:v", "libx264", "-crf", "23", "-preset", "veryfast", new_file])

  # 4. Display and Run
  full_cmd_str = join(args, " ")
  println("-------------------------------------")
  println("Executing: $full_cmd_str")
  println("-------------------------------------")

  # Run directly (Julia handles the shell escaping for you)
  try
    run_cmd = run(`$args`)
    println("\nSuccess! File saved to: $new_file")
    return run_cmd
  catch e
    println("Error executing ffmpeg: $e")
  end
end # func


"""
======================
join_files(file_names::Vector{String}, folder_path::String, output_file::String)

Concatenate multiple media files using ffmpeg.
Creates a temporary `join.txt` file listing the inputs, then runs ffmpeg concat.
======================
"""
function join_files(;
  file_names::Vector{String},
  folder_path::String,
  output_file::String
)
  # Use normpath to let Julia handle slashes correctly for Windows
  folder_path = abspath(folder_path)
  file_names = [normpath(joinpath(folder_path, basename(f))) for f in file_names]
  output_file = normpath(joinpath(folder_path, basename(output_file)))
  file_path = normpath(joinpath(folder_path, "join.txt"))

  # Create join.txt
  open(file_path, "w") do io
    for f in file_names
      # FFmpeg's concat file needs escaped backslashes on Windows
      escaped_path = replace(f, "\\" => "/")
      println(io, "file '$escaped_path'")
    end
  end

  # Build ffmpeg command WITHOUT wrapping in Cmd([...]) inside the run call
  # Just pass the array directly to run()
  ffmpeg_args = [
    "ffmpeg", "-y", "-f", "concat", "-safe", "0",
    "-i", file_path,
    "-c", "copy", output_file
  ]

  println("Executing: $(join(ffmpeg_args, " "))")
  result = run(`$ffmpeg_args`) # Use backticks with the array
  return result
end

"""
======================
fix_audio_delay(from::String, to::String, delay::Int)
Apply an audio delay (in ms) to both channels using ffmpeg.
======================
"""
function fix_audio_delay(;
  from::String,
  to::String,
  delay::Int
)
  # Build ffmpeg command
  ffmpeg_cmd = Cmd([
    "ffmpeg", "-i", from,
    "-af", "adelay=$(delay)|$(delay)",
    to
  ])

  println("----------------------------")
  println(ffmpeg_cmd)
  println("----------------------------")

  run_cmd = run(ffmpeg_cmd)

  println("----------------------------")
  return run_cmd
end

end # module
