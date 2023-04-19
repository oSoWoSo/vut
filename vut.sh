#!/bin/bash
# shellcheck disable=SC2162,SC2317

mkdir -p "$HOME/.config/vut"
touch "$HOME/.config/vut/vut.conf"
# real path
config_path="$HOME/.config/vut"
config="$HOME/.config/vut/vut.conf"
# testing path (same dir)
#config_path=""
#config="vut.conf"
# shellcheck source=./vut.conf
source "$config"

_define_colors() {
  cr="\033[0;31m"
  cg="\033[0;32m"
  green="\033[32m"
  cy="\033[0;33m"
  cb="\033[0;34m"
  cyan="\033[0;36m"
  clc="\033[36m"
  cw="\033[0;37m"
  bold="\033[1m"
  cc="\033[0m"
  c="\[0;"
}

_print_menu() {
  "$clear_yes" >/dev/null 2>&1
  echo -e "$bold$header$cc"
  echo -e "$bold$1$cc"
  shift
  for ((i=1; i<=$#; i++)); do
    echo -e "$clc$i.$cc $bold${!i}$cc"
  done
  echo -e "$cb 0. Help$cc"
  echo -e "$cr$menu_up$cc"
}

function hlp_main {
  echo "#TODO"
}

function hlp_src {
  echo "#TODO"
}

function hlp_xbps {
  echo "#TODO"
}

function config_edit {
  xdg-open "$config"
}

function config_edit_vars {
  "$clear_yes" >/dev/null 2>&1
  # display a list of variables
  echo "List of variables in the configuration file:"
  cat "$config"

  # offer the user to select variables to edit
  read -p "Enter the variable numbers to edit (separated by space), or press ENTER to select all variables: " varnums

  # if the user didn't enter any variable number, edit all variables
  if [[ -z $varnums ]]; then
    varnums=$(awk -F= '/^[^#]/ {print NR}' "$HOME/.config/vut/vut.conf")
  fi

  # iterate over the selected variables and offer the user the option to edit each one
  for varnum in $varnums; do
    # get the variable name and current value from the configuration file
    var=$(awk -F= '/^[^#]/ {if (NR == '$varnum') print $1}' "$HOME/.config/vut/vut.conf")
    varvalue=$(grep "^$var=" "$HOME/.config/vut/vut.conf" | cut -d= -f2)

    # if the variable doesn't exist, inform the user and skip it
    if [[ -z $varvalue ]]; then
      echo "Variable $var does not exist in the configuration file, skipping it."
      continue
    fi

    # display the current value of the variable and offer the user the option to change it
    read -p "The current value of $var is \"$varvalue\". Do you want to change it? (y/N) " choice
    case "$choice" in
      y|Y )
        # get the new value of the variable from the user and change it in the configuration file
        read -p "Enter the new value for $var: " newvalue
        sed -i "s/^$var=.*/$var=$newvalue/" "$HOME/.config/vut/vut.conf"
        echo "Variable $var has been changed to \"$newvalue\"."
        ;;
      * )
        # the user didn't want to change the value of the variable, skip it
        ;;
    esac
  done
}
# listing available templates
function list_templates {
  cd "$XBPS_DISTDIR" || exit 2
  find ./*/ | sed 's#/##'
}
# list available arguments
function list_arguments {
  cat "$config_path/arguments"
}

function list_arguments2 {
    # Get the list of functions in the script
    functions=($(declare -F | awk '{print $NF}'))

    # Print the names of the functions
    for f in "${functions[@]}"; do
        if [[ $f == function* ]]; then
            echo "${f/function /}"
        fi
    done
}

function src_list_gen {
  ls srcpkgs/ > "$config_path/list"
}
# updating templates from git
function src_update {
  vpsm upr && read -n 1 -s -r -p Press any key to continue
}
# create new template
function src_new {
  src_enter
  new="yes"
  read -p "Enter the template name: " template
  vpsm n "$template"
}
# choose template to work with
function src_choose {
  src_enter
  new="no"
  template=$(find srcpkgs/ -maxdepth 1 | cut -d'/' -f2 | fzf)
  echo "$template"
}
# try to autobump template (xxtools)
function src_bump {
  xxautobump "$template"
}
# clean template build directory
function src_clean {
  vpsm cl "$template"
}
# open project homepage
# shellcheck disable=SC2154,SC1091
function src_homepage {
  source "srcpkgs/$template/template"
  xdg-open "$homepage"
}
# check template on repology
function src_repology {
  xdg-open https://repology.org/projects/?search="$template"
}
# check for void-packages PRs
function src_pr_check {
  if [ -z "$pr_number" ]; then
    xdg-open https://github.com/void-linux/void-packages/pulls?q="$template"
  else
    xdg-open https://github.com/void-linux/void-packages/pulls/"$pr_number"
  fi
}

function src_pr_create {
  set_branch_name
}

function create_repo_github {
  curl -H "$GITHUB_TOKEN" https://api.github.com/user/repos -d '{"name":"REPO"}'
  git init
  git remote add origin git@github.com:"$USERNAME/$REPO.git"
}
# etnter number of guthub PR
function src_pr_number {
  read -p "Enter number of your PR: " pr_number
}

function repo_push {
  git push -u "$REPO_NAME" "$HEAD"
  read -p "Press Enter to continue"
}

function set_branch_name {
  # Generate a suggested branch name
  template="feature/$(whoami)/$(git rev-parse --abbrev-ref HEAD | sed 's/\//-/g')-"

  # Ask the user if they want to use the suggested branch name
  read -p "Use the suggested branch name \"$template\"? (y/n) " choice

  # If the user doesn't want to use the suggested name, prompt them for a new name
  if [[ $choice =~ ^[Nn]$ ]]; then
    read -p "Enter a new branch name: " branch_name
  else
    branch_name="$template"
  fi
}
# lint template
function src_lint {
  vpsm lint "$template"
}
# checksum template
function src_checksum {
  vpsm xgsum "$template"
}
# dit template
function src_edit {
  #vpsm et "$template"
  "$TERMINAL" -e "$EDITOR srcpkgs/$template/template &"

}
# downloading and building a template
function src_build {
  vpsm pkg "$template"
}
# installing a package
function src_install {
  xi "$template"
}
# enter XBPS_DISTDIR
function src_enter {
  cd "$XBPS_DISTDIR" && echo "Entered XBPS_DISTDIR"|| echo "XBPS_DISTDIR not set!"
}

function save_arguments {
    # Get the list of functions in the script
    declare -F | while read line; do
        # Extract the function name
        func_name=$(echo "$line" | awk '{print $3}')
        # Check if the function starts with the word "function"
        if [[ $func_name == function* ]]; then
            # Write the function name to the "arguments" file
            echo "${func_name/function /}" > "$config_path/arguments"
        fi
    done
}
# Get the list of functions in the script
declare -F | while read line; do
  # Extract the function name
  func_name=$(echo "$line" | awk '{print $3}')
  # Check if the function starts with the word "function"
  if [[ $func_name == function* ]]; then
    # Add a case branch for the function to the switch statement
    case "$1" in
      "${func_name/function /}")
        # Execute the function
        $func_name
        exit 0
        ;;
    esac
  fi
done
# Main script
_define_colors
while true; do
  header="$cr Void Ultimate Tool"
  menu_up="00. Quit"
  menu_name="main"
  _print_menu "main menu:" \
    "$cg menu XBPS-SRC" \
    "$cg menu PACKAGES" \
    "$cy Update xbps" \
    "$cy Update all" \
    "$cyan List possible arguments" \
    "$cyan Edit config file" \
    "$cc Install essential programs"
  read -p "Select an operation (00 0-7): " main_choice
  case "$main_choice" in
    1)
      while true; do
        header="Tools to work with xbps-src
Using:fzf git vpsm xtools xxtools
XBPS_DISTDIR=$XBPS_DISTDIR
repo: $MY_XBPS_REPO $(git branch | grep '*')
PR: $pr_number"
        menu_up="00. Back"
        menu_name="src"
        _print_menu "~" \
          "$cr Create template" \
          "$cr Choose template" \
          "$cy$template$cc on repology" \
          "autobump $cg$template$clc" \
          "edit $cg$template$cc" \
          "checksum $cg$template$clc" \
          "lint $cg$template$clc" \
          "build $cg$template$clc" \
          "install $cg$template$clc" \
          "$cc Update$clc" \
          "$cc Clean $cg$template$clc" \
          "$cg$template$cc PR check" \
          "$cg$template$cc create PR" \
          "$cg$template$cc push" \
          "generate list of current templates" \
          "$cc open template$cc homepage"
        read -p "Select an operation (00 0-16): " template_choice
        case "$template_choice" in
          1)
            src_new
            ;;
          2)
            src_choose
            ;;
          3)
            src_repology
            ;;
          4)
            src_bump
            read -p "Press Enter to continue"
            ;;
          5)
            src_edit
            ;;
          6)
            src_checksum
            read -p "Press Enter to continue"
            ;;
          7)
            src_lint
            read -p "Press Enter to continue"
            ;;
          8)
            src_build
            read -p "Press Enter to continue"
            ;;
          9)
            src_install
            read -p "Press Enter to continue"
            ;;
          10)
            src_update
            ;;
          11)
            src_clean
            ;;
          12)
            src_pr_check
            ;;
          13)
            src_pr_create
            ;;
          14)
            REPO="$MY_XBPS_REPO"
            HEAD="$template"
            repo_push
            ;;
          15)
            src_list_gen
            ;;
          16)
            src_homepage
            ;;
          0)
            hlp_src
            ;;
          00)
            break
            ;;
          *)
            echo "Invalid choice: $choice"
            ;;
        esac
      done
      ;;
    2)
      while true; do
        # second sub-menu
        header="Tools for working with packages"
        menu_up="00. Back"
        menu_name="xbps"
        _print_menu "PACKAGES:" \
          "Install Package" \
          "Remove Package"
        read -p "Select an operation (00 0-2): " package_choice
        case "$package_choice" in
          1)
            install_package
            read -p "Press Enter to continue"
            ;;
          2)
            remove_package
            read -p "Press Enter to continue"
            ;;
          0)
            hlp_xbps
            ;;
          00)
            break
            ;;
          *)
            echo "Invalid selection, please try again."
            read -p "Press Enter to continue"
            ;;
        esac
      done
      ;;
    3)
      sudo xbps-install -Suv
      read -p "Press Enter to continue"
      ;;
    4)
      topgrade
      read -p "Press Enter to continue"
      ;;
    5)
      list_arguments
      read -p "Press Enter to continue"
      ;;
    6)
      config_edit
      read -p "Press Enter to continue"
      ;;
    7)
      install_essentials
      ;;
    0)
      hlp_main
      ;;
    00)
      exit 0
      ;;
    *)
      echo "Invalid selection, please try again."
      read -p "Press Enter to continue"
      ;;
  esac
done
