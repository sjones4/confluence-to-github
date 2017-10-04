#!/bin/bash
#
# Fetch project info
#

FIELDS_ENDPOINT="https://${JIRA_HOST}/rest/api/2/field"

if [ -z "${JIRA_HOST}" ] ; then
  exit 0
fi


FIELDS_FILE="fields.json"
if [ -f "${FIELDS_FILE}" ]  ; then
  echo "Skipping fields as file ${FIELDS_FILE} exists"
else
  echo "Fetching fields to file ${FIELDS_FILE}"
  wget --quiet --output-document="${FIELDS_FILE}" "${FIELDS_ENDPOINT}"
  if [ ${?} -ne 0 ] ; then
    echo "Error getting fields"
    exit 1
  fi
fi

