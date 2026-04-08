# video functions

module vid_tools

export convert_file

using Printf

# function to convert a file to another format with compression
function convert_file(
  ; old_file::String,
  new_file::String,
  from::String="00:00:00",
  to::String=""
)
  # Validate start time
  if length(from) <= 7
    error("You didn't provide a valid 'from' time!!")
  end

  # Interactive overwrite check
  overwrite_flag = "-y"  # default
  if isfile(new_file)
    println("File already exists: $new_file")
    println("Do you want to overwrite it? [Y/N]: ")
    flush(stdout)  # ensure prompt is shown immediately

    answer = Base.prompt("", default="n") |> strip |> lowercase
    if answer in ["y", "yes"]
      overwrite_flag = "-y"
    elseif answer in ["n", "no"]
      overwrite_flag = "-n"
    else
      error("Invalid input. Please type Y or N.")
    end
  end

  # Choose ffmpeg command template
  if isempty(to) || length(to) <= 4
    ffmpeg_cmd = raw"""
    ffmpeg -i "%s" %s `
      -vf "scale=-2:480" `
      -ss %s %s `
      -c:v libx264 -crf 23 -preset veryfast `
      "%s"
    """
  else
    ffmpeg_cmd = raw"""
    ffmpeg -i "%s" %s `
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
    overwrite_flag,
    from,
    to,
    new_file
  )

  println("-------------------------------------")
  println(cmd)
  println("_____________________________________")

  # Run via PowerShell
  run_cmd = run(`powershell -NoLogo -NoProfile -Command $cmd`)

  println("--------------------------------------------------")
  println("\nNew_file: $new_file \nfrom: $from to $to\n")
  println("--------------------------------------------------")

  return run_cmd

end # func

end # module
