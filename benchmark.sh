#!/bin/bash

if ! command -v fio > /dev/null; then
    echo "Error: 'fio' is not installed" 1>&2 && exit 1
fi

display_help() {
    echo "Usage:"
    echo "Simple disk benchmark to emulate cbbackupmgr disk usage"
    echo ""
    echo "Options:"
    echo " -d, --directory  The path to a directory on disk to benchmark"
    echo " -h, --help       Show this help dialog"
}

ARGS=$(getopt --options "d:,h" --longoptions "directory:,help" -- "$@")

eval set -- "$ARGS"
unset ARGS

declare -A args
args=(["directory"]="." ["help"]="")

while true; do
    case "$1" in
        -d|--directory)
            shift; args["directory"]=$1; shift;;
        -h|--help)
            args["help"]=1; shift;;
        --)
            shift; break;;
    esac
done

if [[ ${args["help"]} ]]; then
    display_help
    exit 0
fi

if [[ ! -d ${args["directory"]} ]]; then
    echo "Error: directory '${args["directory"]}' does not exist" 1>&2 && exit 1
fi

fio --directory ${args["directory"]} benchmark.toml | tee benchmark.log
