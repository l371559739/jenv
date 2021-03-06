if [[ ! -o interactive ]]; then
    return
fi

compctl -K _jenv jenv

_jenv_commands()
{
    command=($(echo ${JENV_COMMANDS}))

    for cmd in ${command}; do
        echo ${cmd}
    done
}

_jenv_candidates()
{
    for candidate in ${JENV_CANDIDATES}
    do
        echo $candidate
    done
}

_jenv_repo()
{
    echo "add"
    echo "update"
}

_jenv_candidate_version()
{
    if __jenvtool_utils_array_contains "JENV_CANDIDATES[@]" "$1"; then
        if [[ "$2" == "default"  || "$2" == "uninstall" || "$2" == "cd" || "$2" == "use" ]]; then
           versions=($(echo $(__jenvtool_candidate_installed_versions "$1")))
        else
           versions=($(echo $(__jenvtool_candidate_versions "$1")))
        fi
        for version in ${versions}; do
            echo ${version}
        done
    fi
}

_jenv() {
    local words completions
    read -cA words

    if [ "${#words}" -eq 2 ]; then
        completions="$(_jenv_commands)"
    elif [ "${#words}" -eq 4 ]; then
        typeset prev
        typeset command
        prev=${words[3]}
        command=${words[2]}
        completions="$(_jenv_candidate_version ${prev} ${command})"
    else
        typeset prev
        prev=${words[2, -2]}

        case "${prev}" in
        use)        completions="$(_jenv_candidates)";;
        pause)      completions="$(_jenv_candidates)";;
        list)       completions="$(_jenv_candidates)";;
        ls)         completions="$(_jenv_candidates)";;
        install)    completions="$(_jenv_candidates)";;
        execute)    completions="$(_jenv_candidates)";;
        exe)        completions="$(_jenv_candidates)";;
        show)       completions="$(_jenv_candidates)";;
        default)    completions="$(_jenv_candidates)";;
        which)      completions="$(_jenv_candidates)";;
        cd)         completions="$(_jenv_candidates)";;
        uninstall)  completions="$(_jenv_candidates)";;
        reinstall)  completions="$(_jenv_candidates)";;
        repo)       completions="$(_jenv_repo)";;
        *)          completions=();;
        esac
    fi
    reply=("${(ps:\n:)completions}")
}