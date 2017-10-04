#!/bin/bash
#
# Fetch commits for a specified issue file
#

ISSUE_FILE="${1}"
COMMITS_ENDPOINT_PREFIX="https://${JIRA_HOST}/rest/dev-status/1.0/issue/detail?applicationType=github&dataType=repository&issueId="

if [ -z "${JIRA_HOST}" ] ; then
  echo "JIRA_HOST environment not set, cannot fetch commits"
  exit 1
fi

if [ ! -z "${ISSUE_FILE}" ] ; then
  ISSUE_ID=$(json_reformat < "${ISSUE_FILE}" | grep '"id":' | head -n 1 | awk -F'"' '{print $4}')

  COMMITS_FILE="commits_${ISSUE_ID}.json"
  if [ -f "${COMMITS_FILE}" ]  ; then
    echo "Skipping commits for issue ${ISSUE_ID} as file ${COMMITS_FILE} exists"
  else
    echo "Fetching commits for issue ${ISSUE_ID} to file ${COMMITS_FILE}"
    wget --quiet --output-document="${COMMITS_FILE}" "${COMMITS_ENDPOINT_PREFIX}${ISSUE_ID}"
    if [ ${?} -ne 0 ] ; then
      echo "Error getting commits"
      exit 1
    fi
  fi
fi

