#!/bin/bash
#
# List issues from a JIRA issue search
#

SEARCH_ENDPOINT="https://${JIRA_HOST}/rest/api/2/search"

SEARCH_START_AT="0"
SEARCH_MAX_RESULTS="100"
SEARCH_PROJECT="${JIRA_PROJECT}"

if [ -z "${SEARCH_PROJECT}" ] ; then
  exit 0
fi

while true; do
  # get page to listing file
  PAD_START_INT="000000${SEARCH_START_AT}"
  PAD_START=${PAD_START_INT: -6}
  LIST_OUT=listing_${SEARCH_PROJECT}_${PAD_START}.json
  if [ -f "${LIST_OUT}" ] ; then
    echo "Skipping listing for ${SEARCH_PROJECT} from ${SEARCH_START_AT} as ${LIST_OUT} exists"
    sleep 1
  else
    echo "Fetching listing for ${SEARCH_PROJECT} from ${SEARCH_START_AT} to ${LIST_OUT}"
    sleep 1
    wget \
      --post-data='{
        "jql": "project = '${SEARCH_PROJECT}' order by key asc",
        "startAt": '${SEARCH_START_AT}',
        "maxResults": '${SEARCH_MAX_RESULTS}',
        "fields": [
            "summary"
        ],
        "fieldsByKeys": false
      }' \
      --header='Content-Type: application/json' \
      --quiet \
      --output-document="${LIST_OUT}" \
      "${SEARCH_ENDPOINT}"
    if [ ${?} -ne 0 ] ; then
      echo "Error getting results page"
      exit 1
    fi
  fi

  # check if empty page of results
  grep -q \"summary\" ${LIST_OUT}
  if [ ${?} -ne 0 ] ; then
    rm ${LIST_OUT}
    break;
  fi

  # next page
  SEARCH_START_AT=$((SEARCH_START_AT + SEARCH_MAX_RESULTS))
done


