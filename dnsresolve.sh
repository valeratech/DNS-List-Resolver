#!/bin/bash

set -e
set -u
set -o pipefail

VERBOSITY="false"
AREC="false"
MAIL="false"
OUTPUT="false"

verbose()
    {
    if [[ ${VERBOSITY} == "true" ]]
    then
        sleep 1
	echo "Loading..."
	echo "${@}"
	sleep 1    
    elif [[ ${VERBOSITY} == "false" ]]
    then
	:        
    fi
    }

usage ()
    {  
        echo >&2
	echo "To generate a list of DNS records use the following syntax:" >&2
        echo "  ${0} [OPTIONS] [INPUT-FILE]" >&2
        echo "EXAMPLE: ${0} -vamf example.txt" >&2
        echo >&2
        echo " Option -v   will add verbosity to the script and output" >&2
	echo " Option -a   will specify A-RECORDS for a given domain" >&2
        echo " Option -m   will specify MX-RECORDS for email" >&2
	echo " Option -f   (REQUIRED) specify the input file as the argument" >&2
	echo >&2
    }  


if [[ -z ${@} ]]
then
    usage
    exit 1
fi

while getopts "vamf:" OPTIONS
do
    case ${OPTIONS} in
	v)
            VERBOSITY="true"
            verbose "***Verbosity Mode Enabled***"
	    ;;
	a)
            AREC="true"
	    verbose "Adding option to dig: A-RECORDS"
            ;;

        m)
            MAIL="true"
	    verbose "Adding option to dig: MX-RECORDS"
            ;;

        f)
	    if ! [[ -a ${OPTARG} ]]
	    then
	        verbose "Input file does not exist. See usage below:"
		usage
		exit 1
	    else
	        OUTPUT=$(cat ${OPTARG})
	    fi
	    ;;
    	?)
            usage
            exit 0
	    ;;
    esac
done

shift $(( OPTIND - 1 ))

if [[ ${#} -gt 0 || $OUTPUT = "false" ]]
then
    verbose "See usage"
    usage
    exit 1
fi

if [[ ${AREC} = "true" && ${MAIL} = "true"  ]]
then
    for DOMAIN in $OUTPUT
    do     
        echo "**************************************" >> dnsoutput.txt
	echo "" >> dnsoutput.txt
	echo "$DOMAIN" >> dnsoutput.txt
        echo "" >> dnsoutput.txt
	echo "A-RECORD:" >> dnsoutput.txt
	dig +short a $DOMAIN >> dnsoutput.txt
	echo "" >> dnsoutput.txt
	echo "MX-RECORDS:" >> dnsoutput.txt
	dig +short mx $DOMAIN >> dnsoutput.txt
	echo "" >> dnsoutput.txt
        echo "**************************************" >> dnsoutput.txt
    done
    verbose Generating A-Records and MX-Records

elif [[ ${AREC} = "true" && ${MAIL} = "false" ]]
then
    for DOMAIN in $OUTPUT
    do
	echo "**************************************" >> dnsoutput.txt
        echo "" >> dnsoutput.txt
	echo "$DOMAIN" >> dnsoutput.txt
        echo "" >> dnsoutput.txt
        echo "A-RECORDS:" >> dnsoutput.txt
        dig +short a $DOMAIN >> dnsoutput.txt
        echo "" >> dnsoutput.txt
        echo "**************************************" >> dnsoutput.txt
    done
    verbose Generating A-Records...

elif [[ ${AREC} = "false" && ${MAIL} = "true" ]]
then
    for DOMAIN in $OUTPUT
    do
        echo "**************************************" >> dnsoutput.txt
        echo "" >> dnsoutput.txt
	echo "$DOMAIN" >> dnsoutput.txt
        echo "" >> dnsoutput.txt
	echo "MX-RECORDS:" >> dnsoutput.txt
	dig +short mx $DOMAIN >> dnsoutput.txt
	echo "" >> dnsoutput.txt
        echo "**************************************" >> dnsoutput.txt
    done
    verbose Generating MX-Records...

else
    usage
    exit 1
fi

verbose COMPLETED

exit 0    

