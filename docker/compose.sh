#!/bin/bash

COMPOSE_PROJECT_NAME="pages"
DEFAULT_SERVICE="dev"

function fn_configure() {
    NO_CACHE=${NO_CACHE:=""}
    IS_RUNNING=${IS_RUNNING:="FALSE"}
    IS_EXIST=${IS_EXIST:="FALSE"}
    IS_RELEASE=${IS_RELEASE:="FALSE"}
    DO_BUILD=${DO_BUILD:="FALSE"}
    DO_RUN=${DO_RUN:="FALSE"}
    DO_BASH=${DO_BASH:="FALSE"}
    DO_KILL=${DO_KILL:="FALSE"}
}

function fn_is_running() {
    IS_RUNNING=`docker ps -q --no-trunc | grep $(docker-compose -p ${COMPOSE_PROJECT_NAME} ps -q ${DEFAULT_SERVICE})`
    if [[ "${IS_RUNNING}" != "FALSE" ]] && [[ -n "${IS_RUNNING}" ]]; then
        IS_RUNNING="TRUE"
    fi
}

function fn_is_exist() {
    IS_EXIST=`docker-compose -p ${COMPOSE_PROJECT_NAME} ps -q ${DEFAULT_SERVICE}`
    if [[ "${IS_EXIST}" != "FALSE" ]] && [[ -n "${IS_EXIST}" ]]; then
        IS_EXIST="TRUE"
    fi
}

function fn_check_release() {
    if [[ "${IS_RELEASE}" == "TRUE" ]]; then
        DEFAULT_SERVICE="release"
    fi
}

function fn_build() {
    echo "Build '${COMPOSE_PROJECT_NAME}' docker image"
    docker-compose -p ${COMPOSE_PROJECT_NAME} build ${NO_CACHE} ${DEFAULT_SERVICE}
}

function fn_run() {
    fn_down
    echo "Run '${COMPOSE_PROJECT_NAME}' docker container"
    docker-compose -p ${COMPOSE_PROJECT_NAME} up -d ${DEFAULT_SERVICE}
}

function fn_bash() {
    fn_is_running
    if [[ "${IS_RUNNING}" != "TRUE" ]]; then
        fn_run
    fi
    echo "Connect to shell of '${COMPOSE_PROJECT_NAME}' docker container"
    docker-compose -p ${COMPOSE_PROJECT_NAME} exec ${DEFAULT_SERVICE} /bin/bash
}

function fn_kill() {
    fn_is_running
    if [[ "${IS_RUNNING}" == "TRUE" ]]; then
        echo "Kill '${COMPOSE_PROJECT_NAME}' docker container"
        docker-compose -p ${COMPOSE_PROJECT_NAME} kill
    else
        echo "There is no running '${COMPOSE_PROJECT_NAME}' docker container"
    fi
}

function fn_down() {
    fn_is_exist
    if [[ "${IS_EXIST}" == "TRUE" ]]; then
        echo "Down '${COMPOSE_PROJECT_NAME}' docker container, network, and volumes"
        docker-compose -p ${COMPOSE_PROJECT_NAME} down -v
    else
        echo "There is no '${COMPOSE_PROJECT_NAME}' docker container"
    fi
}

function fn_main() {
    fn_configure
    fn_check_release
    if [[ "${DO_DOWN}" == "TRUE" ]]; then
        fn_down
    elif [[ "${DO_KILL}" == "TRUE" ]]; then
        fn_kill
    elif [[ "${DO_BASH}" == "TRUE" ]]; then
        fn_bash
    elif [[ "${DO_RUN}" == "TRUE" ]]; then
        fn_run
    elif [[ "${DO_BUILD}" == "TRUE" ]]; then
        fn_build
    fi
}

optspec=":bdrks-:"
while getopts "${optspec}" optchar; do
    case ${optchar} in
        -)
            case "${OPTARG}" in
                no-cache)
                    echo "Parsing option: '--${OPTARG}', build with no-cache";
                    NO_CACHE="--no-cache"
		    		;;
                project)
		    		val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
		    		echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
		    		COMPOSE_PROJECT_NAME=${val}
		    		;;
		    	project=*)
		    		val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
                    OPTIND=$(( $OPTIND + 1 ))
		    		echo "Parsing option: '--${opt}', value: '${val}'" >&2;
		    		COMPOSE_PROJECT_NAME=${val}
		    		;;
                release)
                    echo "Parsing option: '--${OPTARG}', release mode";
                    IS_RELEASE="TRUE"
		    		;;
		    	service)
		    		val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
		    		echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
		    		DEFAULT_SERVICE=${val}
		    		;;
		    	service=*)
		    		val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
                    OPTIND=$(( $OPTIND + 1 ))
		    		echo "Parsing option: '--${opt}', value: '${val}'" >&2;
		    		DEFAULT_SERVICE=${val}
		    		;;
		    	*)
		    		if [ "${OPTERR}" == 1 ] || [ "${optspec:0:1}" != ":" ]; then
                    	echo "Unknown option --${OPTARG}"
             		fi
                    ;;
            esac
            ;;
        b)
            DO_BUILD="TRUE"
            ;;
        d)
            DO_DOWN="TRUE"
            ;;
        r)
            DO_RUN="TRUE"
            ;;
        s)
            DO_BASH="TRUE"
            ;;
        k)
            DO_KILL="TRUE"
            ;;
        *)
			if [ "${OPTERR}" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
            	echo "Non-option argument: '-${OPTARG}'"
            fi
            ;;
    esac
done

fn_main