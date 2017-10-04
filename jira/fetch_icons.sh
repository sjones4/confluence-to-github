#!/bin/bash
#
# Fetch icons for a specified issue file
#

ISSUE_FILE="${1}"

if [ ! -z "${ISSUE_FILE}" ] ; then
  ICON_PROJECTS=$(json_reformat < "${ISSUE_FILE}" | grep '32x32' | grep 'projectavatar' | awk -F'"' '{print $4}' | sort -u)
  ICON_ISSUETYPES=$(json_reformat < "${ISSUE_FILE}" | grep '"iconUrl":' | grep 'issuetype' | awk -F'"' '{print $4}' | sort -u)
  ICON_PRIORITIES=$(json_reformat < "${ISSUE_FILE}" | grep '"iconUrl":' | grep '/icons/priorities/' | awk -F'"' '{print $4}' | sort -u)
  ICON_STATII=$(json_reformat < "${ISSUE_FILE}" | grep '"iconUrl":' | grep '/icons/statuses/' | awk -F'"' '{print $4}' | sort -u)

  # project icons
  for ICON_PROJECT in ${ICON_PROJECTS}; do
    PROJECT_KEY=$(json_reformat < "${ISSUE_FILE}" | grep -B 10 "${ICON_PROJECTS}" | grep '"key":' | head -n 1 | awk -F'"' '{print $4}')
    ICON_FILE_PROJECT="project_icon_${PROJECT_KEY}.svg"
    if [ -f "${ICON_FILE_PROJECT}" ] ; then
      echo "Skipping project icon ${PROJECT_KEY} as file ${ICON_FILE_PROJECT} exists"
    else
      echo "Fetching project icon ${PROJECT_KEY} to file ${ICON_FILE_PROJECT}"
      wget --quiet --output-document="${ICON_FILE_PROJECT}" "${ICON_PROJECT}"
      if [ ${?} -ne 0 ] ; then
        echo "Error getting project icon"
        exit 1
      fi
    fi
  done

  # issuetype icons
  for ICON_ISSUETYPE in ${ICON_ISSUETYPES}; do
    ISSUETYPE_NAME=$(json_reformat < "${ISSUE_FILE}" | grep -A 4 "${ICON_ISSUETYPE}" | grep '"name":' | head -n 1 | awk -F'"' '{print $4}')
    ICON_FILE_ISSUETYPE="issuetype_icon_${ISSUETYPE_NAME}.svg"
    if [ -f "${ICON_FILE_ISSUETYPE}" ] ; then
      echo "Skipping issuetype icon ${ISSUETYPE_NAME} as file ${ICON_FILE_ISSUETYPE} exists"
    else
      echo "Fetching issuetype icon ${ISSUETYPE_NAME} to file ${ICON_FILE_ISSUETYPE}"
      wget --quiet --output-document="${ICON_FILE_ISSUETYPE}" "${ICON_ISSUETYPE}"
      if [ ${?} -ne 0 ] ; then
        echo "Error getting issuetype icon"
        exit 1
      fi
    fi
  done

  # priority icons
  for ICON_PRIORITY in ${ICON_PRIORITIES}; do
    PRIORITY_NAME=$(json_reformat < "${ISSUE_FILE}" | grep -A 4 "${ICON_PRIORITY}" | grep '"name":' | head -n 1 | awk -F'"' '{print $4}')
    ICON_FILE_PRIORITY="priority_icon_${PRIORITY_NAME}.svg"
    if [ -f "${ICON_FILE_PRIORITY}" ] ; then
      echo "Skipping priority icon ${PRIORITY_NAME} as file ${ICON_FILE_PRIORITY} exists"
    else
      echo "Fetching priority icon ${PRIORITY_NAME} to file ${ICON_FILE_PRIORITY}"
      wget --quiet --output-document="${ICON_FILE_PRIORITY}" "${ICON_PRIORITY}"
      if [ ${?} -ne 0 ] ; then
        echo "Error getting priority icon"
        exit 1
      fi
    fi
  done

  # status icons
  for ICON_STATUS in ${ICON_STATII}; do
    STATUS_NAME=$(json_reformat < "${ISSUE_FILE}" | grep -A 4 "${ICON_STATUS}" | grep '"name":' | head -n 1 | awk -F'"' '{print $4}')
    ICON_FILE_STATUS="status_icon_${STATUS_NAME}.svg"
    if [ -f "${ICON_FILE_STATUS}" ] ; then
      echo "Skipping status icon ${STATUS_NAME} as file ${ICON_FILE_STATUS} exists"
    else
      echo "Fetching status icon ${STATUS_NAME} to file ${ICON_FILE_STATUS}"
      wget --quiet --output-document="${ICON_FILE_STATUS}" "${ICON_STATUS}"
      if [ ${?} -ne 0 ] ; then
        echo "Error getting status icon"
        exit 1
      fi
    fi
  done
fi

