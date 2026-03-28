#!/bin/bash
set -e

# ==============================
# Firebase App Distribution — Android
# ==============================

FIREBASE_APP_ID="1:573182601628:android:b9b24bf4217e710feb4059"
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_usage() {
  echo -e "${CYAN}Usage:${NC}"
  echo "  ./distribute_android.sh [options]"
  echo ""
  echo -e "${CYAN}Options:${NC}"
  echo "  -n, --notes         Release notes text"
  echo "  -f, --notes-file    Path to release notes file"
  echo "  -t, --testers       Comma-separated tester emails"
  echo "  -T, --testers-file  Path to testers file"
  echo "  -g, --groups        Comma-separated group aliases"
  echo "  -G, --groups-file   Path to groups file"
  echo "  -p, --apk-path      Path to APK file (default: $APK_PATH)"
  echo "  -h, --help          Show this help"
  echo ""
  echo -e "${CYAN}Tester/Group management:${NC}"
  echo "  --add-testers       Add testers (emails or --testers-file)"
  echo "  --remove-testers    Remove testers (emails or --testers-file)"
  echo "  --create-group      Create group: --alias <alias> --group-name <name>"
  echo "  --delete-group      Delete group: --alias <alias>"
  echo "  --group-alias       Group alias (used with add/remove/create/delete)"
  echo "  --group-name        Group display name (used with --create-group)"
}

NOTES=""
NOTES_FILE=""
TESTERS=""
TESTERS_FILE=""
GROUPS=""
GROUPS_FILE=""
ACTION="distribute"
GROUP_ALIAS=""
GROUP_NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--notes)          NOTES="$2";        shift 2 ;;
    -f|--notes-file)     NOTES_FILE="$2";   shift 2 ;;
    -t|--testers)        TESTERS="$2";      shift 2 ;;
    -T|--testers-file)   TESTERS_FILE="$2"; shift 2 ;;
    -g|--groups)         GROUPS="$2";       shift 2 ;;
    -G|--groups-file)    GROUPS_FILE="$2";  shift 2 ;;
    -p|--apk-path)       APK_PATH="$2";     shift 2 ;;
    --add-testers)       ACTION="add-testers";    shift ;;
    --remove-testers)    ACTION="remove-testers"; shift ;;
    --create-group)      ACTION="create-group";   shift ;;
    --delete-group)      ACTION="delete-group";   shift ;;
    --group-alias)       GROUP_ALIAS="$2";  shift 2 ;;
    --group-name)        GROUP_NAME="$2";   shift 2 ;;
    -h|--help)           print_usage; exit 0 ;;
    *) echo -e "${RED}Unknown option: $1${NC}"; print_usage; exit 1 ;;
  esac
done

case "$ACTION" in

  distribute)
    if [[ ! -f "$APK_PATH" ]]; then
      echo -e "${RED}APK not found at: $APK_PATH${NC}"
      echo -e "${YELLOW}Run 'flutter build apk' first.${NC}"
      exit 1
    fi

    if [[ -z "$NOTES" && -z "$NOTES_FILE" ]]; then
      echo -e "${YELLOW}No release notes provided. Enter them now (or press Enter to skip):${NC}"
      read -r NOTES
    fi

    CMD="firebase appdistribution:distribute \"$APK_PATH\" --app \"$FIREBASE_APP_ID\""
    [[ -n "$NOTES" ]]        && CMD+=" --release-notes \"$NOTES\""
    [[ -n "$NOTES_FILE" ]]   && CMD+=" --release-notes-file \"$NOTES_FILE\""
    [[ -n "$TESTERS" ]]      && CMD+=" --testers \"$TESTERS\""
    [[ -n "$TESTERS_FILE" ]] && CMD+=" --testers-file \"$TESTERS_FILE\""
    [[ -n "$GROUPS" ]]       && CMD+=" --groups \"$GROUPS\""
    [[ -n "$GROUPS_FILE" ]]  && CMD+=" --groups-file \"$GROUPS_FILE\""

    echo -e "${CYAN}Distributing Android build...${NC}"
    eval "$CMD"
    echo -e "${GREEN}Done!${NC}"
    ;;

  add-testers)
    CMD="firebase appdistribution:testers:add"
    [[ -n "$GROUP_ALIAS" ]]  && CMD+=" --group-alias \"$GROUP_ALIAS\""
    [[ -n "$TESTERS_FILE" ]] && CMD+=" --file \"$TESTERS_FILE\""
    [[ -n "$TESTERS" ]]      && CMD+=" $TESTERS"

    echo -e "${CYAN}Adding testers...${NC}"
    eval "$CMD"
    echo -e "${GREEN}Done!${NC}"
    ;;

  remove-testers)
    CMD="firebase appdistribution:testers:remove"
    [[ -n "$GROUP_ALIAS" ]]  && CMD+=" --group-alias \"$GROUP_ALIAS\""
    [[ -n "$TESTERS_FILE" ]] && CMD+=" --file \"$TESTERS_FILE\""
    [[ -n "$TESTERS" ]]      && CMD+=" $TESTERS"

    echo -e "${CYAN}Removing testers...${NC}"
    eval "$CMD"
    echo -e "${GREEN}Done!${NC}"
    ;;

  create-group)
    if [[ -z "$GROUP_NAME" || -z "$GROUP_ALIAS" ]]; then
      echo -e "${RED}--group-name and --group-alias are required.${NC}"
      exit 1
    fi
    echo -e "${CYAN}Creating group '$GROUP_NAME' ($GROUP_ALIAS)...${NC}"
    firebase appdistribution:group:create "$GROUP_NAME" "$GROUP_ALIAS"
    echo -e "${GREEN}Done!${NC}"
    ;;

  delete-group)
    if [[ -z "$GROUP_ALIAS" ]]; then
      echo -e "${RED}--group-alias is required.${NC}"
      exit 1
    fi
    echo -e "${CYAN}Deleting group '$GROUP_ALIAS'...${NC}"
    firebase appdistribution:group:delete "$GROUP_ALIAS"
    echo -e "${GREEN}Done!${NC}"
    ;;

esac
