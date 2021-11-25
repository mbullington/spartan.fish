function fish_prompt
  set -l last_status $status
  if [ $last_status = 0 ]
    set_color green
  else
    set_color red
  end

  inline: ":= "

  set_color normal
end
