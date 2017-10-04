#!/bin/bash
#
# Fetch issues from a specified listing file
#

LISTING_FILE="${1}"

if [ ! -z "${LISTING_FILE}" ] ; then
  for ISSUE_URL in $(json_reformat < "${LISTING_FILE}" | grep '"self":' | awk -F'"' '{print $4}') ; do
    ISSUE_KEY=$(json_reformat < "${LISTING_FILE}" | grep -A 1 "${ISSUE_URL}" | grep '"key":' | awk -F'"' '{print $4}')
    ISSUE_FILE="${ISSUE_KEY}.json"
    if [ -f "${ISSUE_FILE}" ] ; then
      echo "Skipping issue ${ISSUE_KEY} as ${ISSUE_FILE} exists"
    else
      echo "Fetching issue ${ISSUE_KEY} from ${ISSUE_URL}"
      wget --quiet --output-document="${ISSUE_FILE}" "${ISSUE_URL}"
      if [ ${?} -ne 0 ] ; then
        echo "Error getting issue"
        exit 1
      fi
    fi
  done
fi


