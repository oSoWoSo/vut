#!/usr/bin/env bash
# shellcheck disable=SC2154,SC2317

# For debug uncomment desired set
#set -u # End if are here unused variables
#set -e # End on first error
#set -x # Show what script is going to do

# INTERNAL FUNCTIONS
#
_config() {
  config_path=$HOME/.config/vut
  config=$HOME/.config/vut/vut.conf
  if [ ! -e "$config" ]; then
    mkdir -p "$config_path" && cat <<EOF > vut.conf
# Void Ultimate Tool config v.0.1
#
# your gpu
GPU="amd"
# where forked repo stored localy
XBPS_DISTDIR="$HOME/void"
# link to forked repo hosting
MY_XBPS_REPO="git@github.com:oSoWoSo/VUR.git"
# name of remote git repo
GIT_HOST_NAME="gh"
# your email (for comitting)
email="zenobit@disroot.org"
# your user name (for comitting)
name="zenobit"
# default browser: any
BROWSER="firefox"
# for color support
TERM=xterm-256color
# default terminal emulator: any (but using -e for opening in new windows)
TERMINAL=kitty
# default editor: any
EDITOR=hx
# commit message using "oc" or "" for git commit
message_using="oc"
# DEBUGING : "clear" or "" to not clear
clear_yes="clear"
# výstup do externího terminálu, nebo na standardního výstup "/dev/tty"
output_to="/dev/stdout"
EOF
    echo "$MSG_config_created_sourcing Config created, sourcing.."
  else
    echo "$MSG_config_exists_sourcing Config exists, sourcing.."
  fi
  # shellcheck source=./vut.conf
  source "$config"
}
# shellcheck disable=SC2034
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
_exterm_open() {
  $TERMINAL -e $cmd &
}
# arguments
_arguments_get() {
  while read -r line; do
    if [[ $line =~ ^\ *function\ +([^[:space:]]+) ]]; then
      echo "${BASH_REMATCH[1]}"
    fi
  done < "$0" | sort -u
}
_arguments_use() {
  function_list=$(_arguments_get)
  for func_name in $function_list; do
    if [[ $func_name == "$1" ]]; then
      # Execute the function
      $func_name
      exit 0
    fi
  done
  run_gui
}
_arguments_export() {
  echo "$function_list" > "$config_path/arguments"
  export function_list
}
_install_get() {
  IFS=$'\n' sorted_install_functions=($(grep -E '^function install_' $0 | awk '{print $2}' | sort -u | awk NF))
  unset IFS
  printf '%s\n' "${sorted_install_functions[@]}"
}
# menu
_run_list() {
  while :
  do
    list --width 200 --height 600 "${menu_items[@]}"
    answer="${?}"
    if [ ${answer} -eq 0 ]
    then
    menu_choice="$( 0< "${dir_tmp}/${file_tmp}" )"
    menu_actions $menu_choice
    elif [ ${answer} -eq 1 ]
    then
    break
    else
    exit
    fi
  done
}
_run_menu() {
  while :
  do
    tagged_menu --width 200 --height 500 "${menu_items[@]}"
    answer="${?}"
    if [ ${answer} -eq 0 ]
    then
    menu_choice="$( 0< "${dir_tmp}/${file_tmp}" )"
    menu_actions $menu_choice
    elif [ ${answer} -eq 1 ]
    then
    break
    else
    exit
    fi
  done
}
_define_menu() {
  echo "$MSG_define_menu"
  menu_items=(
 "1" "xbps-src MENU"
 "2" "fuzzypkg"
 "3" "packages MENU"
 "4" "Update xbps"
 "5" "Update all"
 "6" "system monitor"
 "7" "services"
 "8" "Tools MENU"
 "9" "List arguments"
 "10" "Edit config"
 "11" "Install essentials MENU"
 "12" "Install void MENU"
 "0" "Quit"
  )

  function menu_actions {
    case $1 in
      1) _define_menu_src;;
      2) cmd=fuzzypkg; _exterm_open;;
      3) _define_menu_xbps;;
      4) sudo xbps-install -Suv;;
      5) cmd=topgrade; _exterm_open;;
      6) system_monitor;;
      7) manage_services;;
      8) _define_menu_tools;;
      9) list_arguments;;
      10) config_edit;;
      11) _define_list_essen;_run_list;;
      12) install_v_void;;
      0) exit 0;;
    esac
  }
}
_define_list_essen() {
  echo "$MSG_define_menu_essential"
  menu_items=(
 "ansible"
 "connman"
 "distrohopper"
 "gparted"
 "chezmoi"
 "lutris"
 "ngetty"
 "opencommit"
 "pipewire"
 "quickemu"
 "steam"
 "virtmanager"
 "wine"
 'WM awesome'
 'WM bspwm'
 'WM openbox'
 "xxtools"
 "00" "Back to Main Menu"
 "0" "Quit"
  )

  function menu_actions {
    case $1 in
      00) _define_menu;_run_menu;;
      0) exit 0;;
      'Back..') _define_menu;_run_menu;;
      ansible) install_ansible;;
      connman) install_connman;;
      distrohopper) install_distrohopper;;
      gparted) install_gparted;;
      chezmoi) install_chezmoi;;
      lutris) install_lutris;;
      ngetty) install_ngetty;;
      opencommit) install_opencommit;;
      pipewire) install_pipewire;;
      quickemu) install_quickemu;;
      steam) install_steam;;
      virtmanager) install_virtmanager;;
      wine) install_wine;;
      'WM awesome') install_wm_awesome;;
      'WM bspwm') install_wm_bspwm;;
      'WM openbox') install_wm_openbox;;
      xxtools) install_xxtools;;
    esac
  }
}
_define_menu_src() {
  echo "$MSG_define_menu_src"
  menu_items=(
 "1" "create NEW template"
 "2" "choose template"
 "3" "$template on Repology"
 "4" "autobump $template"
 "5" "edit $template"
 "6" "checksum $template"
 "7" "lint $template"
 "8" "build $template"
 "9" "install packaged $template"
 "10" "update"
 "11" "clean $template"
 "12" "PR check"
 "13" "create PR"
 "14" "push"
 "15" "open $template Homepage"
 "00" "Back to Main Menu"
 "0" "Quit"
  )

  function menu_actions {
    case $1 in
      00) _define_menu;_run_menu;;
      0) exit 0;;
      1) src_new;;
      2) src_choose;;
      3) src_repology;;
      4) src_bump;;
      5) src_edit;;
      6) src_checksum;;
      7) src_lint;;
      8) src_build;;
      9) src_install;;
      10) src_update;;
      11) src_clean;;
      12) src_pr_check;;
      13) src_pr_create;;
      14) REPO="$MY_XBPS_REPO"; HEAD="$template"; repo_push;;
      15) src_homepage;;
    esac
  }
}
_define_menu_tools() {
  echo "$MSG_define_menu_tools"
  menu_items=(
 "1" "translate"
 "2" "lazygit"
 "00" "Back to Main Menu"
 "0" "Quit"
  )

  function menu_actions {
    case $1 in
      00) _define_menu;_run_menu;;
      0) exit 0;;
      1) cmd=./translate; _exterm_open;;
      2) cmd=lazygit; _exterm_open;;
    esac
  }
}
_define_menu_xbps() {
  echo "$MSG_define_menu_xbps"
  menu_items=(
 "1" "Install package"
 "2" "Remove package"
 "3" ""
 "4" ""
 "5" ""
 "6" ""
 "7" ""
 "00" "Back to Main Menu"
 "0" "Quit"
  )
  function menu_actions {
    case $1 in
      00) _define_menu;_run_menu;;
      0) exit 0;;
      1) install_package;;
      2) remove_package;;
      3) ;;
      4) ;;
      5) ;;
      6) ;;
      7) ;;
    esac
  }
}
# menu template
_define_menu_CHANGETHIS() {
  echo "$MSG_CHANGETHIS"
  menu_items=(
 "1" "CHANGETHIS"
 "2" "CHANGETHIS"
 "3" "CHANGETHIS"
 "4" "CHANGETHIS"
 "5" "CHANGETHIS"
 "6" "CHANGETHIS"
 "7" "CHANGETHIS"
 "00" "Back to Main Menu"
 "0" "Quit"
  )

  function menu_actions {
    case $1 in
      00) _define_menu;_run_menu;;
      0) exit 0;;
      1) CHANGETHIS;;
      2) CHANGETHIS;;
      3) CHANGETHIS;;
      4) CHANGETHIS;;
      5) CHANGETHIS;;
      6) CHANGETHIS;;
      7) CHANGETHIS;;
    esac
  }
}
_define_submenu_tools() {
    name="tools"
    items=(
'translate'
'lazygit'
'Back to main menu'
)
    actions=(
'_define_menu;;'
'cmd=./translate; _exterm_open;;'
'cmd=lazygit
_exterm_open
;;'
)
    local submenu_name=$(echo "$1" | sed 's/ /_/g');
    echo "$MSG_define_submenu_$submenu_name Defining submenu: $1...";
    menu_items=();
    i=1;
    for item in "${items[@]}";
    do
        menu_items+=("$i" "$item");
        ((i++));
    done;
    menu_items+=("$i" "Back to Main Menu");
    function menu_actions ()
    {
        case $1 in
            ${#items[@]})
                _define_menu
            ;;
            *)
                cmd="${items[$(( $1 - 1 ))]}";
                _exterm_open
            ;;
        esac
    };
    echo '_define_submenu_'"$submenu_name"'() {' > "$submenu_name.sh";
    declare -f _define_submenu | tail -n +2 >> "$submenu_name.sh";
    echo '}' >> "$submenu_name.sh"
}
### HELP
function help {
  echo "#TODO"
}
function help_main {
  echo "#TODO"
}
function help_src {
  echo "#TODO"
}
function help_xbps {
  echo "#TODO"
}
# MENU - modes
function run_gui {
  unset supermode
  source easybashgui
  _define_menu
  _run_menu
}
function run_yad_mode {
  export supermode="yad"
  source easybashgui
  _define_menu
  _run_menu
}
function run_gtkdialog_mode {
  export supermode="gtkdialog"
  source easybashgui
  _define_menu
  _run_menu
}
function run_kdialog_mode {
  export supermode="kdialog"
  source easybashgui
  _define_menu
  _run_menu
}
function run_zenity_mode {
  export supermode="zenity"
  source easybashgui
  _define_menu
  _run_menu
}
function run_xdialog_mode {
  export supermode="Xdialog"
  source easybashgui
  _define_menu
  _run_menu
}
function run_dialog_mode {
  export supermode="dialog"
  source easybashgui
  _define_menu
  _run_menu
}
function run_tui {
  export supermode="none"
  source easybashgui
  _define_menu
  _run_menu
}
### FUNCTIONS (SORTED BY MENUS)
# MAIN MENU
function system_monitor {
  echo "#TODO"
  cmd=btop
  _exterm_open
}
function config_edit {
  cmd="$EDITOR $config"
  _exterm_open
  source $config
}
function config_edit_vars {
  "$clear_yes" >/dev/null 2>&1
  # display a list of variables
  echo "$MSG_list_of_variables_in_the_configuration_file"
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
      echo "$MSG_echo_variable_var_does_not_exist_in_the_configuration_file_skipping"
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
function list_arguments {
  echo "Posible arguments are:"
  echo "***************************"
  _arguments_get
  echo "***************************"
}
function manage_services {
  echo "#TODO"
  sudo vsv
}
### SRC MENU
function src_list_gen {
  ls srcpkgs/ > "$config_path/list"
}
function list_templates {
  cd "$XBPS_DISTDIR" || exit 2
  find ./*/ | sed 's#/##'
}
function src_update {
  echo "#TODO"
  vpsm upr
}
function src_new {
  src_enter
  new="yes"
  read -p "Enter the template name: " template
  vpsm n "$template"
  echo "$template"
  _define_menu_src
}
function src_choose {
  src_enter
  new="no"
  template=$(find srcpkgs/ -maxdepth 1 | cut -d'/' -f2 | fzf)
  echo "$template"
  _define_menu_src
}
function src_bump {
  xxautobump "$template"
}
function src_clean {
  vpsm cl "$template"
}
function src_homepage {
  source "srcpkgs/$template/template"
  xdg-open "$homepage"
}
function src_repology {
  xdg-open https://repology.org/projects/?search="$template"
}
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
function src_pr_number {
  read -p "Enter number of your PR: " pr_number
}
function src_lint {
  vpsm lint "$template"
}
function src_checksum {
  vpsm xgsum "$template" && vpsm xgsum "$template"
}
function src_edit {
  #vpsm et "$template"
  cmd="$EDITOR srcpkgs/$template/template"
  _exterm_open
}
function src_build {
  vpsm pkg "$template"
}
function src_install {
  xi "$template"
}
function src_enter {
  cd "$XBPS_DISTDIR" && echo "Entered XBPS_DISTDIR"|| echo "XBPS_DISTDIR not set!"
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
function create_repo_github {
  curl -H "$GITHUB_TOKEN" https://api.github.com/user/repos -d '{"name":"REPO"}'
  git init
  git remote add origin git@github.com:"$USERNAME/$REPO.git"
}
function repo_push {
  git push -u "$GIT_HOST_NAME" "$HEAD"
  read -p "Press Enter to continue"
}
function get_api_key {
  read -p "Please enter your API key: " api_key
  export your_api_key=$api_key
  echo "API key saved as your_api_key=$api_key"
}
### INSTALL MENU
function install_v_vut {
  echo "#TODO"
}
function install_v_void {
  echo "#TODO"
}
function install_v_drivers_nvidia {
  sudo xbps-install dkms nvidia nvtop pkg-config
}
function install_essentials {
  echo "#TODO"
}
function install_ansible {
  echo "#TODO"
  # Vytvoření adresáře pro Ansible, pokud neexistuje
  mkdir -p $HOME/.ansible

  # Instalace Ansible
  sudo xbps-install ansible

  # Kontrola verze Ansible
  ansible --version

  # Nastavení cesty a názvu souboru pro SSH klíče
  ssh_file=$HOME/.ansible/ansible_ed25519
  ssh_keygen_cmd="ssh-keygen -t ed25519 -C ansible -f $ssh_file -P \""

  # Vytvoření SSH klíčů, pokud neexistují
  if [ ! -f "$ssh_file" ]; then
    $ssh_keygen_cmd
  fi

  # Nastavení autorizovaných klíčů pro SSH
  # Přidat obsah souboru ~/.ssh/ansible_ed25519.pub na cílové servery v souboru ~/.ssh/authorized_keys

  # Vytvoření inventáře
  echo "all:
    hosts:
      server1:
        ryzen: 192.168.0.101
      server2:
        ansible_host: server2.example.com
    vars:
      ansible_user: root" > $HOME/.ansible/inventory.yml

  # Vytvoření playbooku pro aktualizaci balíčků
  echo "- name: Aktualizovat balíčky
    hosts: all
    become: true
    tasks:
      - name: Aktualizovat balíčky
        package:
          name: "*"
          state: latest" > $HOME/.ansible/update_packages.yml

  # Spuštění playbooku
  ansible-playbook $HOME/.ansible/update_packages.yml -i $HOME/.ansible/inventory.yml
}
function install_connman {
  sudo xbps-remove\
 libnma\
 NetworkManager\
 network-manager-applet
  sudo xbps-install\
 connman\
 connman-ui
  sudo rm -vf /var/service/dhcpcd &&\
 sudo ln -s /etc/sv/connmand /var/service/
}
function install_chezmoi {
  echo "#TODO"
  sudo xbps-install chezmoi
  chezmoi init
  chezmoi cd
  git init
  git add .
}
function install_v_distrohopper {
  echo"#TODO"
  git clone https://github.com/oSoWoSo/distrohopper ~/git/dh
}
function install_gparted {
  sudo xbps-install -S gparted btrfs-progs exfatprogs e2fsprogs f2fs-tools dosfstools mtools hfsutils hfsprogs jfsutils util-linux cryptsetup lvm2 nilfs-utils ntfs-3g reiser4progs udftools xfsprogs xfsdump
}
function install_lutris {
  echo "$TODO"
}
function install_ngetty {
  sudo xbps-install ngetty
  sudo rm -vf /var/service/agetty* && sudo ln -s /etc/sv/ngetty /var/service
}
function install_opencommit {
  sudo xbps-install git pnpm
  sudo npm install -g opencommit
  sudo npm i -g gitmoji-cli
  #Your api key is stored locally in ~/.opencommit config file
  get_api_key
  oc config set OPENAI_API_KEY=${your_api_key}
  oc config set emoji=true
  oc config set description=true
}
function install_pipewire {
  xbps-install pipewire libpipewire wireplumber
  mkdir -p /etc/pipewire
  sed '/path.*=.*pipewire-media-session/s/{/#{/'\
 /usr/share/pipewire/pipewire.conf > /etc/pipewire/pipewire.conf
}
function install_steam {
  echo "$TODO"
}
function install_virtmanager {
  echo "#TODO"
  #
  # Install and setup KVM/QEMU/Virt-Manager with file sharing
  #
  # Copyright (c) 2022 zenobit from oSoWoSo
  # mail: <pm@osowoso.xyz> web: https://osowoso.xyz
  # licensed under EUPL 1.2
  # sources:
  # dt's Virt-Manager Is The Better Way To Manage VMs
  # https://www.youtube.com/watch?v=p1d_b_91YlU
  # dt's Virt-Manager Tips and Tricks from a VM Junkie
  # https://www.youtube.com/watch?v=9FBhcOnCxM8&t=1046s
  #

  ## colors
  blue=$(tput setaf 4)
  green=$(tput setaf 2)
  red=$(tput setaf 1)
  none=$(tput sgr0)
  echo -n "$green"
  echo "choices:"
  echo -n "$none"
  echo "0 - install required"
  echo "1 - share on host"
  echo "2 - share on guest"
  echo "3 - convert image"
  echo "4 - change resolution (one monitor only)"
  echo "5 - guest addition"
  echo "q - quit"
  echo -n "$green"
  read -p "posible answers: (0/1/2/3/4/q)" whattodo
  echo -n "$none"
  case $whattodo in
    q )
    echo -n "$red"
    echo "quit"
    echo -n "$none"
    exit
    ;;

    0 )
    ## usercheck
    echo "Your user is:"
    user=$USER
    echo -n "$red"
    echo $user
    echo -n "$none"
    echo
    ## check virtualization support
    echo -n "$green"
    echo check virtualization support
    echo -n "$none"
    LC_ALL=C lscpu | grep Virtualization
    ## install needed
    echo -n "$green"
    echo install needed
    echo -n "$none"
    sudo xbps-install\
     dbus\
     libvirt\
     qemu\
     virt-manager\
     bridge-utils\
     iptables

    ## add service
    echo -n "$green"
    echo add service
    echo -n "$none"
    sudo ln -s /etc/sv/dbus /var/service/
    sudo ln -s /etc/sv/libvirtd /var/service/
    sudo ln -s /etc/sv/virtlockd /var/service/
    sudo ln -s /etc/sv/virtlogd /var/service/
    ## add user to libvirt group
    echo -n "$green"
    echo add user to libvirt group
    echo -n "$none"
    sudo usermod -G libvirt -a $user
    echo -n "$green"
    echo "Done"
    echo -n "$none"
    ;;

    1 )
    ## create shared folder betwen host and guest
    mkdir ~/share
    ## give permission to anyone
    chmod 777 ~/share
    echo -n "$green"
    echo "Done"
    echo -n "$none"
    ;;

    2 )
    ## create shared folder betwen host and guest
    ## add new filesystem
    ## type: mount
    ## mode: mapped
    ## source path: /home/$USER/share
    ## target path: /sharepoint
    mkdir ~/share
    ## always mount shared directory
    sudo mount -t 9p -o trans=virtio /sharepoint share
    ## or
    ## auto mount at start
    ## add to /etc/fstab "/sharepoint	/home/$USER/share	9p	trans=virtio,version=9p2000.L,rw	0	0"
    echo -n "$green"
    echo "Done"
    echo -n "$none"
    ;;

    3 )
    ### Convert images: virtualbox vdi to gcow2
    echo "***not here yet***"
    #sudo qemu-img convert -f vdi -O qcow2 Ubuntu\ 20.04.vdi /var/lib/libvirt/images/ubuntu-20-04.qcow2
    echo -n "$green"
    echo "Done"
    echo -n "$none"
    ;;

    4 )
    echo "choose:"
    echo "a - fullHD"
    echo "b - custom"
    read -p "posible answers: (a/b)" resolution
    case $resolution in
      a )
      ## set fullHD
      xrandr -s 1920x1080
      echo -n "$green"
      echo "Done"
      echo -n "$none"
      ;;

      b )
      ## custom resolution
      echo "input custom resolution"
      echo "example: 1920x1080"
      read -p "custom" custom
      xrandr -s $custom
      echo -n "$green"
      echo "Done"
      echo -n "$none"
      ;;
    esac
    ;;

    5 )
    echo -n "$red"
    echo $user
    echo -n "$none"

    echo -n "$green"
    echo "Done"
    echo -n "$none"
    ;;
  esac

  echo -n "$red"
  echo "Finished"
  echo -n "$none"
}
function install_quickemu {
  echo "$TODO"
}
function install_wine {
  echo "$TODO"
}
function install_xxtools {
  sudo xbps-install xtools
  git clone https://github.com/Piraty/xxtools /tmp/xxtools
  sudo mv /tmp/xxtools/xx* /usr/bin/
}
function install_wm_awesome {
  sudo xbps-install awesome
  cp -r /etc/xdg/awesome ~/.config/awesome
}
function install_wm_bspwm {
  sudo xbps-install bspwm dbus dmenu elogind lxappearance lxsession sxhkd tint2 yambar
  mkdir -p $HOME/.config/bspwm
  cp /usr/share/doc/bspwm/examples/bspwmrc $HOME/.config/bspwm/bspwmrc
  chmod +x ~/.config/bspwm/bspwmrc
  mkdir -p $HOME/.config/sxhkd
  cp /usr/share/doc/bspwm/examples/sxhkdrc $HOME/.config/sxhkd/sxhkdrc
}
function install_wm_openbox {
  sudo xbps-install jgmenu lxappearance obconf obmenu-generator openbox tint2conf
  obmenu-generator -p -i -u -d -c
}
### RUN SCRIPT
echo "***************************"
echo "$MSG_WELCOME Void Ultimate Tool:
Support a lot of functions!
try run 'vut help' or 'vut list_arguments'"
echo "***************************"
_define_colors
_config
_arguments_use "$1"
_arguments_export
echo "***************************"
echo "$MSG_GOODBYE
 If you found some bugs please, let me know!
                                zenobit"
