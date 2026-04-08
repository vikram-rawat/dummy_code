# video functions

module vid_tools

export convert_file

using Printf

# function to convert a file to another format with compression
function convert_file(
  ;
  old_file::String,
  new_file::String,
  from::String="00:00:00",
  to::String=""
)
  # default start time
  if length(from) <= 7
    error("You didn't provide a Valid from time!!")
  elseif isfile(new_file)
    error("File already exists: $new_file")
  end

  # Choose ffmpeg command template
  if length(to) <= 4
    ffmpeg_cmd = raw"""
    ffmpeg -i "%s" `
      -vf "scale=-2:480" `
      -ss %s %s `
      -c:v libx264 -crf 23 -preset veryfast `
      "%s"
    """
  else
    ffmpeg_cmd = raw"""
      ffmpeg -i "%s" `
        -vf "scale=-2:480" `
        -ss %s -to %s `
        -c:v libx264 -crf 23 -preset veryfast `
        "%s"
      """
  end

  # Format command
  cmd = Printf.format(
    Printf.Format(ffmpeg_cmd),
    old_file,
    from,
    to,
    new_file
  )

  println("-------------------------------------")
  println(cmd)
  println("_____________________________________")

  # Run via non interactive PowerShell
  run_cmd = run(`powershell -NoLogo -NoProfile -Command $cmd`)

  println("--------------------------------------------------")
  # println(@sprintf("\nNew_file: %s \nfrom: %s to %s\n", new_file, from, to))
  println("\nNew_file: $new_file \nfrom: $from to $to\n")
  println("--------------------------------------------------")

  return run_cmd

end # func

end # module
