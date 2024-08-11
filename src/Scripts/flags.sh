# Flags Script for New Swing Project (NSP)
# Created by Daniel Dahlberg
# License: MIT
# Description: This script handles the creation of project templates and directories based on specified flags.

# Template and utility directories
local -A MAIN_TEMPLATES
local -A FRAME_TEMPLATES
local -A UTILS_DIRS
local -A TEMPLATES_DIRS

MAIN_TEMPLATES=(
  ["oneFrame"]="OneFrame.java"
  ["separate"]="Separate.java"
)

FRAME_TEMPLATES=(
  ["frame"]="Frame.java"
)

UTILS_DIRS=(
  ["templates"]="Templates"
  ["icons"]="Icons"
)

TEMPLATES_DIRS=(
  ["main"]="Main"
  ["frames"]="Frames"
)

declare -r -A MAIN_TEMPLATES
declare -r -A FRAME_TEMPLATES
declare -r -A UTILS_DIRS
declare -r -A TEMPLATES_DIRS

local -r TEMPLATES=Templates
local -r UTILS=Utils
local -r MAIN_DIR=$TEMPLATES/${TEMPLATES_DIRS[main]}

# Create project files and directories
__create() (
  local -r DIR=$1
  local -r FILE=$2
  local -r PROJECT_DIR=${3:-.}
  local -r FROM=$AUX_DIR/$DIR/$FILE
  local -r TO=$TEMP_DIR/$PROJECT_DIR

  __create_dest_if_not_exists() {
    if [ ! -d $TO ]; then
      mkdir $TO
    fi
  }

  __copy_to_project() {
    print_verbose "Copying FROM: $FROM, TO: $TO"
    cp -r $FROM $TO
  }

  __rename_to_main_if_main_template() (
    if [[ $DIR == $MAIN_DIR ]]; then
      cd $TEMP_DIR
      mv $FILE Main.java
    fi
  )

  __create_dest_if_not_exists
  __copy_to_project
  __rename_to_main_if_main_template
)

# Create directory structure
__create_directory() {
  local -r DIR=$1
  __create $DIR "*" $DIR
}

# Create main template file
__create_main() {
  local -r FILE=$1
  __create $MAIN_DIR $FILE
}

# Create frame template file
__create_frame() {
  local -r FRAMES_DIR=$TEMPLATES/Frames
  local -r FILE=$1
  __create $FRAMES_DIR $FILE
}

# Process flags to create respective files
process_one_frame_flag() {
  local -r MAIN=${MAIN_TEMPLATES[oneFrame]}
  __create_main $MAIN
}

process_separate_flag() {
  local -r MAIN=${MAIN_TEMPLATES[separate]}
  local -r FRAME=${FRAME_TEMPLATES[frame]}

  __create_main $MAIN
  __create_frame $FRAME
}

process_icon_flag() {
  __create_directory Icons
}

process_util_flag() {
  __create_directory $UTILS
}
