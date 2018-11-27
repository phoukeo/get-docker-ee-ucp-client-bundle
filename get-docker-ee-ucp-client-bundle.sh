#!/usr/bin/env bash

############################################################################################################################################################
# This script downloads a Docker EE UCP Client Bundle.
#
#   Syntax: get-docker-ee-ucp-client-bundle.sh-d docker-ee-ucp-manager
#
#   Pre-requisites:
#
#     The curl command must be installed.
#     The jq command must be installed.
#    
#     Your Docker ID must be exported in an environment variable named DOCKER_USER
#     Your Docker Password must be exported in an environment variable named DOCKER_PASSWORD
#
############################################################################################################################################################
# Gary Forghetti
# Docker, Inc
############################################################################################################################################################

function usage () {
    printf 'Usage: get-docker-ee-ucp-client-bundle.sh-d docker-ee-ucp-manager-host\n' >&2
    printf ' -d is the Docker EE UCP Manager Host (hostname or IP address) and must be specified.\n' >&2
    printf ' -h displays this command help.\n' >&2
}

############################################################################################################################################################
# Check for the curl command
############################################################################################################################################################
if ! command -v curl &> /dev/null ; then
    printf 'This script requires the curl command!\n' >&2
    exit 1
fi

############################################################################################################################################################
# Check for the jq command
############################################################################################################################################################
if ! command -v jq &> /dev/null ; then
    printf 'This script requires the jq command!\n' >&2
    exit 1
fi

############################################################################################################################################################
# Check to see if the DOCKER_USER environment variable is set
############################################################################################################################################################
if [[ -z $DOCKER_USER ]]; then
    printf 'The DOCKER_USER environment variable is not set!\n' >&2
    exit 1
fi

############################################################################################################################################################
# Check to see if the DOCKER_PASSWORD environment variable is set
############################################################################################################################################################
if [[ -z $DOCKER_PASSWORD ]]; then
    printf 'The DOCKER_PASSWORD environment variable is not set!\n' >&2
    exit 1
fi

############################################################################################################################################################
# Check to see if the DOCKER_PASSWORD environment variable is set
############################################################################################################################################################
if [[ -z $DOCKER_PASSWORD ]]; then
    printf 'The DOCKER_PASSWORD environment variable is not set!\n' >&2
    exit 1
fi

############################################################################################################################################################
# Get the command line arguments
############################################################################################################################################################
DOCKER_EE_HOST=''

OPTERR=0

while getopts ":d:h" opt; do
    case $opt in
        d)                          # -d docker ee ucp host
            DOCKER_EE_HOST=$OPTARG
            if [[ -z $DOCKER_EE_HOST ]]; then
                printf 'The Docker EE UCP Manager Host (hostname or IP address) was not specified!\n' >&2
                usage
                exit 1
            fi
            ;;
        h)                          # -h command help
            usage
            exit 0
            ;;            
        \?)
            printf "Invalid option: -%s\\n" "${OPTARG}" >&2
            usage
            exit 1
            ;;
        :)
            case $OPTARG in
                d)
                    printf 'The Docker EE UCP Manager Host (hostname or IP address) was not specified!\n' >&2
                    usage
                    exit 1
                    ;;
            esac
    esac
done

############################################################################################################################################################
# Verify the Docker EE UCP Manager Host (hostname or IP address) was specified
############################################################################################################################################################
if [[ -z $DOCKER_EE_HOST ]]; then
    printf 'The Docker EE UCP Manager Host (hostname or IP address) was not specified!\n' >&2
    usage               
    exit 1
fi   

############################################################################################################################################################
# Get an authorization token
############################################################################################################################################################
CREDENTIALS="{\"username\":\"${DOCKER_USER}\",\"password\":\"${DOCKER_PASSWORD}\"}"
OUTPUT=$(curl --insecure --location --silent --show-error --connect-timeout 10 -d "${CREDENTIALS}" "https://${DOCKER_EE_HOST}/auth/login" --write-out "%{http_code}")
HTTP_CODE=$(echo "$OUTPUT" | awk 'END{print}')
if [[ "$HTTP_CODE" != "200" ]]; then
        printf 'Unable to get an authorization token!\n' >&2
        printf "HTTP Code: %s\\n" "${HTTP_CODE}" >&2
        printf "https://%s/auth/login\\n" "${DOCKER_EE_HOST}" >&2
        exit 1
fi  

AUTHTOKEN=$(echo "$OUTPUT" | awk 'NR > 1 { print prev } { prev = $0 }' | jq -r .auth_token)
if [[ -z $AUTHTOKEN ]]; then
    printf 'Unable to get an authorization token!\n' >&2
    printf "%s\\n" "${OUTPUT}" >&2
    exit 1
fi    

############################################################################################################################################################
# Download a Docker EE UCP client bundle
############################################################################################################################################################
rm -f bundle.zip

OUTPUT=$(curl --insecure --location --silent --show-error --connect-timeout 10 --header "Authorization: Bearer ${AUTHTOKEN}" --write-out "%{http_code}" "https://${DOCKER_EE_HOST}/api/clientbundle" -o bundle.zip)
HTTP_CODE=$(echo "$OUTPUT" | awk 'END{print}')
if [[ "$HTTP_CODE" != "200" ]]; then
        printf 'Unable to download a Docker EE Client Bundle!\n' >&2
        printf "HTTP Code: %s\\n" "${HTTP_CODE}" >&2
        printf "https://%s/api/clientbundle\\n" "${DOCKER_EE_HOST}" >&2
        exit 1
fi        

############################################################################################################################################################
# Unzip the downloaded client bundle
############################################################################################################################################################
unzip -o bundle.zip   

printf 'Run the following command to configure your shell for Docker EE commands:\n'
printf "eval \"\$(<env.sh)\"\\n"
