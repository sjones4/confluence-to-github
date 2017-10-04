#!/bin/bash
#
# Export JIRA issues to file
#
# This script is the main entry point for exports.
#
# Edit this file to set the target JIRA and project.
#
# Output is under the "export" directory.
#


export JIRA_HOST="eucalyptus.atlassian.net"
export JIRA_PROJECT="lb"

# dirs
BASE_DIR=export
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
START_DIR="$(pwd)"

# general info
PROJECT_DIR="${START_DIR}/${BASE_DIR}/${JIRA_PROJECT}"
mkdir -p "${PROJECT_DIR}"
cd "${PROJECT_DIR}"
"${SCRIPT_DIR}/fetch_project.sh"

# list issues
LISTING_DIR="${START_DIR}/${BASE_DIR}/${JIRA_PROJECT}/listing"
mkdir -p "${LISTING_DIR}"
cd "${LISTING_DIR}"
"${SCRIPT_DIR}/fetch_listing.sh"

# fetch issues
ISSUES_DIR="${START_DIR}/${BASE_DIR}/${JIRA_PROJECT}/issues"
mkdir -p "${ISSUES_DIR}"
cd "${ISSUES_DIR}"
for LISTING_FILE in "${LISTING_DIR}"/*.json; do
  "${SCRIPT_DIR}/fetch_listing_issues.sh" "${LISTING_FILE}"
done

# fetch issue icons
ICONS_DIR="${START_DIR}/${BASE_DIR}/${JIRA_PROJECT}/icons"
mkdir -p "${ICONS_DIR}"
cd "${ICONS_DIR}"
for ISSUE_FILE in "${ISSUES_DIR}"/*.json; do
  "${SCRIPT_DIR}/fetch_icons.sh" "${ISSUE_FILE}"
  "${SCRIPT_DIR}/fetch_user_icons.sh" "${ISSUE_FILE}"
done

# fetch issue attachments
ATTACHMENTS_DIR="${START_DIR}/${BASE_DIR}/${JIRA_PROJECT}/attachments"
mkdir -p "${ATTACHMENTS_DIR}"
cd "${ATTACHMENTS_DIR}"
for ISSUE_FILE in "${ISSUES_DIR}"/*.json; do
  "${SCRIPT_DIR}/fetch_attachments.sh" "${ISSUE_FILE}"
done

# fetch issue github info
COMMITS_DIR="${START_DIR}/${BASE_DIR}/${JIRA_PROJECT}/commits"
mkdir -p "${COMMITS_DIR}"
cd "${COMMITS_DIR}"
for ISSUE_FILE in "${ISSUES_DIR}"/*.json; do
  "${SCRIPT_DIR}/fetch_commits.sh" "${ISSUE_FILE}"
done

#TODO
# fetch remaining comments (if comments are truncated for any issues)

