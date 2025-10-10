#!/usr/bin/env bash

version="0.1 alpha"
menu()
	{
		help=$(gum style --height 5 --width 25 --padding '1 3' --border double --border-foreground 42 "Gum the Void")
		content=$(gum style --width 25 --padding '1 3' --border double --border-foreground 212 "version $(gum style --foreground "#04B575" "0.1") alpha.")
		gum join --horizontal "$help" "$content"
		gum choose --height=23 --header="$header" projects packages services update btop vsv tools network media vut essential void src EXIT
	}
#NICE_MEETING_YOU=$(gum style --height 5 --width 25 --padding '1 3' --border double --border-foreground 42 "Well, it was nice meeting you, $(gum style --foreground 23 "$NAME"). Hope to see you soon!")
#CHEW_BUBBLE_GUM=$(gum style --width 25 --padding '1 3' --border double --border-foreground 212 "Don't forget to chew some $(gum style --foreground "#04B575" "$GUM") bubble gum.")
#gum join --horizontal "$NICE_MEETING_YOU" "$CHEW_BUBBLE_GUM"

loop()
	{
		while :
		do
			#clear
			action
		done
	}
### actions
open()
	{
		if interm="yes";then
			open_in_terminal "$@"
		else
			"$@"
		fi
	}
open_as_root()
	{
		rootcheck
		if interm="yes";then
			open_in_terminal "$SUDO $*"
		else
			"$SUDO $*"
		fi
	}
rootcheck()
	{
		if [[ $EUID -eq 0 ]]; then
			echo "This operation is being run with super-user privileges."
			SUDO=''
		else
			echo "This operation needs super-user privileges."
			SUDO='sudo'
		fi
	}
open_in_terminal()
	{
		$TERMINAL -e "$*" &
	}
config_edit()
	{
		# shellcheck disable=SC2154
		open "$EDITOR $config"
		# shellcheck disable=SC1090,SC2154
		source "$config"
	}
input()
	{
		input=$(gum input --header="$input_header" --placeholder="$input_placeholder" --char-limit=23)
	}

action()
	{
		case $answer in
			projects) menu_projects;;
			packages) menu_packages;;
			services) menu_services;;
			update) open_as_root "xbps-install -Suv";;
			btop) open btop;;
			vsv) open_as_root vsv;;
			tools) menu_tools;;
			network) menu_network;;
			media) menu_media;;
			vut) menu_vut;;
			essential) menu_essential;;
			void) menu_void;;
			xbps-src) menu_src;;
			lazygit)  open lazygit;;
			UPDATE) src_update;;
			new) src_new;;
			choose) src_choose;;
			repology) src_repology;;
			autobump) src_autobump;;
			edit) src_edit;;
			checksum) src_checksum;;
			lint) src_lint;;
			build) src_build;;
			install) src_install;;
			clean) src_clean;;
			PRcheck) src_pr_check;;
			createPR) src_pr_create;;
			push) src_push;;
			Homepage) src_homepage;;
			back) menu;loop;;
			EXIT) goodbye;;
		esac
	}
## submenus
menu_projects()
	{
		help=$(gum style --height 5 --width 25 --padding '1 3' --border double --border-foreground 42 "Projects")
		content=$(gum style --width 25 --padding '1 3' --border double --border-foreground 212 "version $(gum style --foreground "#04B575" "0.1") alpha.")
		gum join --horizontal "$help" "$content"
		gum choose --height=23 xbps-src lazygit back EXIT
	}
menu_src()
	{
		help=$(gum style --height 5 --width 25 --padding '1 3' --border double --border-foreground 42 "Add packages to void..")
		content=$(gum style --width 25 --padding '1 3' --border double --border-foreground 212 "template = $(gum style --foreground "#04B575" "$template")")
		gum join --horizontal "$help" "$content"
		gum choose --height=23 UPDATE new choose repology Homepage autobump edit checksum lint build install clean PRcheck createPR push back EXIT

		help_message="Add packages to void.."
		help_content="template = $template"
		header=xbps-src
		items=''
	}
src_update() {
		echo "#TODO"
		vpsm upr
	}
src_new()
	{
		new="yes"
		input_header="Enter new template name..."
		input_placeholder="template name"
		input
		vpsm n "$input"
		src_show_name
	}
src_choose()
	{
		src_enter
		new="no"
		template=$(find srcpkgs/ -maxdepth 1 | cut -d'/' -f2 | fzf)
		src_show_name
	}
src_show_name() {
		header="$template"
	}
src_bump()
	{
		xxautobump "$template"
	}
src_clean()
	{
		vpsm cl "$template"
	}
src_homepage()
	{
		# shellcheck disable=SC1090,SC2154
		source "srcpkgs/$template/template"
		xdg-open "$homepage"
	}
src_repology()
	{
		xdg-open https://repology.org/projects/?search="$template"
	}
src_pr_check()
	{
		if [ -z "$pr_number" ]; then
		xdg-open https://github.com/void-linux/void-packages/pulls?q="$template" &
	else
		xdg-open https://github.com/void-linux/void-packages/pulls/"$pr_number" &
	fi
	}
src_pr_create()
	{
		set_branch_name
	}
src_pr_number()
	{
		read -p "Enter number of your PR: " pr_number
	}
src_push()
	{
		REPO="$MY_XBPS_REPO"; HEAD="$template"; repo_push
	}
src_lint()
	{
		vpsm lint "$template"
	}
src_checksum()
	{
		vpsm xgsum "$template" && vpsm xgsum "$template"
	}
src_edit()
	{
		#vpsm et "$template"
		open "$EDITOR srcpkgs/$template/template"
	}
src_build()
	{
		vpsm pkg "$template"
	}
src_install()
	{
		xi "$template"
	}
src_enter()
	{
		cd "$XBPS_DISTDIR" && echo "Entered XBPS_DISTDIR"|| echo "XBPS_DISTDIR not set!"
	}
goodbye()
	{
		help_message='Please let me know, if you found some bug...'
		gum style --height 1 --padding '1 3' --border double --border-foreground 42 "$help_message"
		exit 0
	}

menu
loop

# This restores STDERR output on your terminal...
exec 2>&6 6>&-
