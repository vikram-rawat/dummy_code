module vid_tools

export convert_file
using Printf

function convert_file(; old_file::String, new_file::String, from::String="00:00:00", to::String="")
  # 1. Validation
  if length(from) < 8
    error("Invalid 'from' time format. Use HH:MM:SS")
  end

  # 2. Interactive Overwrite
  overwrite_flag = "-y"
  if isfile(new_file)
    print("File already exists: $new_file\nDo you want to overwrite it? [y/n]: ")
    flush(stdout)
    answer = readline() |> strip |> lowercase
    if answer in ["y", "yes"]
      overwrite_flag = "-y"
    else
      println("Aborting process.")
      return nothing
    end
  end

  # 3. Build Command Components
  # Using an array is cleaner for 'run' in Julia
  args = ["ffmpeg", "-i", old_file, overwrite_flag]

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
