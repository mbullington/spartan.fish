# set -g __spartan_right_prompt_stamp

# Taken from elementary OS stylesheet
set -g __elementary_color_grey "#383e41"

## number of seconds since epoch
function __spartan_date.now
  date +%s
end

## 24hr format (like 20:00, etc)
function __spartan_date.24h_mm
  date "+%H:%M"
end

# set -g __spartan_segment_current_bg

function __spartan_segment_right: -a bg fg text
  if test -z $__spartan_segment_current_bg
    inline: (set_color normal)(set_color $bg)
  else
    inline: (set_color $bg -b $__spartan_segment_current_bg)
  end

  set -g __spartan_segment_current_bg $bg

  if [ $bg != "normal" ]
    inline: \uE0B2
  end

  inline: (set_color $fg -b $bg)"$text"
end

function __spartan_segment_right_close
  set_color normal
  set -e __spartan_segment_current_bg
end

function __spartan_fish_preexec --on-event fish_preexec
  set -g __fish_exec_start (__spartan_date.now)
end

function __spartan_fish_postexec --on-event fish_postexec
  set -l end (__spartan_date.now)
  set -g __fish_exec_duration (math $end - $__fish_exec_start)
end

function __spartan_right_prompt_time
  set -l prettydate (__spartan_date.24h_mm)
  __spartan_segment_right: $__elementary_color_grey blue (inline: (bold: " $prettydate "))
  set -g __spartan_right_prompt_stamp (__spartan_date.now)
end

function fish_right_prompt
  set -l last_status $status

  if test -z $__spartan_right_prompt_stamp
    __spartan_right_prompt_time
  else
    set -l now (__spartan_date.now)
    set -l diff (math $now - $__spartan_right_prompt_stamp)
  
    # make sure we only have the opaque background once every minute
    if [ $diff -ge 10 ]
      __spartan_right_prompt_time
    end
  end

  if [ $last_status != 0 ]
    __spartan_segment_right: red $__elementary_color_grey (inline: (bold: " $last_status "))
  end

  if not test -z $fish_private_mode
    __spartan_segment_right: white $__elementary_color_grey (inline: " incognito ")
  end

  if test -z $__fish_exec_duration
  # command has to be running for more than 5 seconds
  else if [ $__fish_exec_duration -ge 5 ]
    set -l prettyduration (echo $__fish_exec_duration"000" | humanize_duration)
    __spartan_segment_right: green $__elementary_color_grey (inline: (bold: " "$prettyduration" "))
  end

  __spartan_segment_right_close
end