# https://github.com/paulirish/pure/blob/master/LICENSE
function _pure_parse_directory \
    --description "Replace '$HOME' with '~'" \
    --argument-names max_path_length

    set --local folder (string replace $HOME '~' $PWD)
    
    if test -n "$max_path_length";
        if test (string length $folder) -gt $max_path_length;
            # If path exceeds maximum symbol limit, use default fish path formating function
            set folder (prompt_pwd)
        end
    end
    echo $folder
end

function fish_title \
    --description "Set title to current folder and shell name" \
    --argument-names last_command

    set --local basename (string replace -r '^.*/' '' -- $PWD)
    set --local current_folder (_pure_parse_directory)
    set --local current_command (status current-command 2>/dev/null; or echo $_)

    set --local prompt "$basename ⇢ $last_command"

    if test -z "$last_command"
        if test "$current_command" = "fish"
            set prompt "$current_folder"
        else
            set prompt "$current_folder ⇢ $current_command"
        end
    end

    echo $prompt
end