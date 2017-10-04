#!/bin/bash
#
# Fetch icons for a specified issue file
#

ISSUE_FILE="${1}"

if [ ! -z "${ISSUE_FILE}" ] ; then
  ICON_USERS=$(json_reformat < "${ISSUE_FILE}" | grep '24x24' | grep 'useravatar' | awk -F'"' '{print $4}' | sort -u)

  # project icons
  for ICON_USER in ${ICON_USERS}; do
    USER_KEY=$(json_reformat < "${ISSUE_FILE}" | grep -B 10 "${ICON_USER}" | grep '"key":' | head -n 1 | awk -F'"' '{print $4}')
    ICON_FILE_USER="user_icon_24_${USER_KEY}.png"
    if [ -f "${ICON_FILE_USER}" ]  ; then
      echo "Skipping project icon ${PROJECT_KEY} as file ${ICON_FILE_USER} exists"
    else
      echo "Fetching user icon ${USER_KEY} to file ${ICON_FILE_USER}"
      wget --quiet --output-document="${ICON_FILE_USER}" "${ICON_USER}"
      if [ ${?} -ne 0 ] ; then
        echo "Error getting user icon"
        exit 1
      fi
    fi
  done

fi

