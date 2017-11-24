# virtualenv does not work correctly when tmux is run inside virtualenv.
# this function is a wrapper around tmux command that deactivates virtualenv
# before running tmux and reactivates it again. --cenkalti
tmux()
{
    local current_env=""
    if [ "$VIRTUAL_ENV" != "" ]; then
        current_env="$VIRTUAL_ENV"
        deactivate
    fi

    command tmux "$@"
    local ret=$?

    if [ "$current_env" != "" ]; then
        workon $(basename $current_env)
    fi

    return $ret
}
