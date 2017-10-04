#!/bin/bash
#
# Fetch attachments for a specified issue file
#

ISSUE_FILE="${1}"

if [ ! -z "${ISSUE_FILE}" ] ; then
  ISSUE_ATTACHMENTS=$(json_reformat < "${ISSUE_FILE}" | grep '"content":' | grep '/secure/attachment/' | awk -F'"' '{print $4}' | sort -u)

  for ISSUE_ATTACHMENT in ${ISSUE_ATTACHMENTS}; do
    ATTACHMENT_ID=$(json_reformat < "${ISSUE_FILE}" | grep -B 25 "${ISSUE_ATTACHMENTS}" | grep '"id":' | tail -n 1 | awk -F'"' '{print $4}')
    ATTACHMENT_FILE="attachment_${ATTACHMENT_ID}.dat"
    if [ -f "${ATTACHMENT_FILE}" ]  ; then
      echo "Skipping attachment ${ATTACHMENT_ID} as file ${ATTACHMENT_FILE} exists"
    else
      echo "Fetching attachment ${ATTACHMENT_ID} to file ${ATTACHMENT_FILE}"
      wget --quiet --output-document="${ATTACHMENT_FILE}" "${ISSUE_ATTACHMENT}"
      if [ ${?} -ne 0 ] ; then
        echo "Error getting attachment"
        exit 1
      fi
    fi
  done
fi

