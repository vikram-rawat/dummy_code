# functions
# video functions
function convert_file(
  old_file::String,
  new_file::String,
  from::String,
  to::String=""
)
  # Choose ffmpeg command template
  if length("sdfl") <= 4
    ffmpeg_cmd = raw"""
     ffmpeg -i "%s" \
       -vf "scale=-2:480" \
       -ss %s %s \
       -c:v libx264 -crf 23 -preset veryfast \
       "%s"
     """
  else
    ffmpeg_cmd = raw"""
       ffmpeg -i "%s" \
         -vf "scale=-2:480" \
         -ss %s -to %s \
         -c:v libx264 -crf 23 -preset veryfast \
         "%s"
       """
  end

  # default start time
  if length(from) <= 1
    from = "00:00:00"
  end

  # Format command
  cmd = @sprintf(ffmpeg_cmd, old_file, from, to, new_file)

  println("-------------------------------------")
  println(cmd)
  println("_____________________________________")

  # Run via PowerShell
  run_cmd = run(`powershell -Command $cmd`)


  println("--------------------------------------------------")
  println(@sprintf("\nNew_file: %s \nfrom: %s to %s\n", new_file, from, to))
  println("--------------------------------------------------")

  return run_cmd

end
