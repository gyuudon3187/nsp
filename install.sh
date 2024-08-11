#!/bin/bash
# Installation script for New Swing Project (NSP)

declare -A FILES
declare -A INSTALL_PATHS

readonly MAIN_SCRIPT="main_script"
readonly MAN_PAGE="man_page"
readonly SHARE="share"

FILES=(
  ["$MAIN_SCRIPT"]="nsp"
  ["$MAN_PAGE"]="nsp.1"
  ["$SHARE"]="src/*"
)

INSTALL_PATHS=(
  ["$MAIN_SCRIPT"]="/usr/local/bin"
  ["$MAN_PAGE"]="/usr/local/share/man/man1/"
  ["$SHARE"]="/usr/local/share/nsp/"
)

declare -r -A FILES
declare -r -A INSTALL_PATHS

__load_util_functions() {
  source ./src/Scripts/utils.sh
  local -r UTIL_FUNCTIONS=("handle_error" "create_temp_dir" "cleanup")
  check_source_success "${UTIL_FUNCTIONS[@]}"
}

__validate() (
  __check_if_root() {
    if [[ $EUID -ne 0 ]]; then
      local -r MSG="This script must be run as root"
      handle_error $LINENO "$MSG"
    fi
  }

  __check_required_files() (
    __check_main_script() {
      if [[ ! -f ./${FILES[${MAIN_SCRIPT}]} ]]; then
        local -r MSG="Error: $SCRIPT_NAME not found in current directory."
        handle_error $LINENO "$MSG"
      fi
    }
    
    __check_man_page() {
      if [[ ! -f ./${FILES[${MAN_PAGE}]} ]]; then
        local -r MSG="Error: $MAN_PAGE not found in current directory."
        handle_error $LINENO "$MSG"
      fi
    }

    __check_src() (
      __check_dir_exists() {
        local -r DIR=$1

        if [[ ! -d $DIR ]]; then
          local -r MSG="Error: The subdirectory $DIR is missing from /src"
          handle_error $LINENO "$MSG"
        fi
      }

      local -a DIRS=("Icons" "Scripts" "Templates" "Utils")

      for DIR in $DIRS; do
        __check_dir_exists src/$DIR
      done
    )
  )

  __check_if_root
  __check_required_files
)

__install() (
  __install_target_to_temp_dir() {
    local -r TARGET="$1"
    local -r DEST_PATH=$TEMP_DIR/$2
    local -r DESC=${3:-"$TARGET"}

    echo "Installing $DESC to $DEST_PATH"

    if [[ ! -d $DEST_PATH ]]; then
      mkdir -p $DEST_PATH
    fi
    
    cp -r ./$TARGET $DEST_PATH
  }

  __mv_temp_dir_to_install_path() (
    __mv_to_install_path() {
      local -r FROM=$1
      local -r TO=$2

      echo "Moving $FROM to $TO"
      mv $FROM $TO
    }

    __mv_main_script() {
      __mv_to_install_path $TEMP_DIR/${FILES[${MAIN_SCRIPT}]} ${INSTALL_PATHS[${MAIN_SCRIPT}]}
    }

    __mv_src() {
      __mv_to_install_path $TEMP_DIR/src ${INSTALL_PATHS[${SHARE}]}
    }

    __mv_man_page_and_gzip_and_update() {
      local -r FROM=$TEMP_DIR/${FILES[${MAN_PAGE}]}
      local -r TO=${INSTALL_PATHS[${MAN_PAGE}]}

      __mv_to_install_path $FROM $TO 
      gzip -f $TO/${FILES[${MAN_PAGE}]}
      mandb
    }

    __mv_main_script
    __mv_src
    __mv_man_page_and_gzip_and_update
  )

  create_temp_dir
  __install_target_to_temp_dir ${FILES[${MAIN_SCRIPT}]} .
  __install_target_to_temp_dir ${FILES[${MAN_PAGE}]} . "man page"
  __install_target_to_temp_dir "${FILES[${SHARE}]}" src
  __mv_temp_dir_to_install_path
)

# __init_vars
__load_util_functions
trap 'cleanup $TEMP_DIR' ERR
__validate
__install

echo "Installation completed successfully!"
