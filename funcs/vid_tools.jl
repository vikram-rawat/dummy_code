module vid_tools

export convert_file
using Printf
using Gtk4


function convert_file(;
  old_file::String,
  new_file::String,
  from::String="00:00:00",
  to::String=""
)
  # 1. Validation
  if length(from) < 8
    error("Invalid 'from' time format. Use HH:MM:SS")
  end

  # 2. Interactive Overwrite
  overwrite_flag = "-n"
  if isfile(new_file)
    result = Gtk4.ask_dialog("File already exists. Do you want to overwrite?")
    overwrite_flag = result ? "-y" : "-n"
  end

  # 3. Build Command Components
  # Using an array is cleaner for 'run' in Julia
  args = ["ffmpeg", overwrite_flag, "-i", old_file]

  # Video filters and seeking
  append!(args, ["-vf", "scale=-2:480", "-ss", from])

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

end # module
