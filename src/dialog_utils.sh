#!/bin/bash

export DIALOG_RETURN=
export DIALOG_ANSWER=

setValue() {
	value=
	if [ -z "$2" ] || [ "$2" = "null" ]; then
		value=$1
	else
		value=$2
	fi

	echo $value
}

# yesno        <text> <height> <width>
dialog_yesno_args=(
	text
	height
	width
)

dialog_yesno() {
	text=$(setValue "Yes/No" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift

	dialog --yesno "$text" $height $width
	
	DIALOG_RETURN=$?
	if [ $DIALOG_RETURN -eq 0 ]; then
		DIALOG_ANSWER=1
	else
		DIALOG_ANSWER=0
	fi
}

# buildlist    <text> <height> <width> <list-height> <tag1> <item1> <status1>...
dialog_buildlist_args=(
	text
	height
	width
	list-height
	tagN
	itemN
	statusN
)

dialog_buildlist() {
	text=$(setValue "Build List" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	let list_height=$(setValue 3 $1); shift

	declare -A item_layout=(
		[tag]="tag"
		[item]="item"
		[status]="status"
	)

	declare -a items

	for ((i=1; i <= $list_height; i++)); do
		idx=$[ $i - 1 ]
		idx=$[ $idx * ${#item_layout[@]} ]

		items[$idx]=$(setValue "${item_layout[tag]}$i" $1); shift
		items[$[ $idx + 1 ]]=$(setValue "${item_layout[item]}$i" $1); shift
		items[$[ $idx + 2 ]]=$(setValue "${item_layout[status]}$i" $1); shift
	done

	DIALOG_ANSWER=$(dialog --buildlist "$text" $height $width $list_height ${items[@]} 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# calendar     <text> <height> <width> <day> <month> <year>
dialog_calendar_args=(
	text
	height
	width
	day
	month
	year
)

dialog_calendar() {
	text=$(setValue "Calendar" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	let day=$(setValue 1 $1); shift
	let month=$(setValue 1 $1); shift
	let year=$(setValue 2000 $1); shift

	DIALOG_ANSWER=$(dialog --calendar "$text" $height $width $day $month $year 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# checklist    <text> <height> <width> <list height> <tag1> <item1> <status1>...
dialog_checklist_args=(
	text
	height
	width
	list-height
	tagN
	itemN
	statusN
)

dialog_checklist() {
	text=$(setValue "Checklist" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	let list_height=$(setValue 3 $1); shift
	
	declare -A item_layout=(
		[tag]="tag"
		[item]="item"
		[status]="status"
	)

	declare -a items

	for ((i=1; i <= $list_height; i++)); do
		idx=$[ $i - 1 ]
		idx=$[ $idx * ${#item_layout[@]} ]

		items[$idx]=$(setValue "${item_layout[tag]}$i" $1); shift
		items[$[ $idx + 1 ]]=$(setValue "${item_layout[item]}$i" $1); shift
		items[$[ $idx + 2 ]]=$(setValue "${item_layout[status]}$i" $1); shift
	done
	
	DIALOG_ANSWER=$(dialog --checklist "$text" $height $width $list_height ${items[@]} 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# dselect      <directory> <height> <width>
dialog_dselect_args=(
	directory
	height
	width
)

dialog_dselect() {
	directory=$(setValue "${HOME}" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift

	DIALOG_ANSWER=$(dialog --dselect "$directory" $height $width 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# editbox      <file> <height> <width>
dialog_editbox_args=(
	file
	height
	width
)

dialog_editbox() {
	tmp_file=$(mktemp)
	file=$(setValue "$tmp_file" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift

	DIALOG_ANSWER=$(dialog --editbox "$file" $height $width 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
	rm -f $tmp_file
}

# form         <text> <height> <width> <form height> <label1> <l_y1> <l_x1> <item1> <i_y1> <i_x1> <flen1> <ilen1>...
dialog_form_args=(
	text
	height
	width
	form-height
	label_nameN
	label_yN
	label_xN
	placeholderN
	input_yN
	input_xN
	field_lenN
	input_lenN
)

dialog_form() {
	text=$(setValue "Form" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	let form_height=$(setValue 3 $1); shift

	declare -A item_layout=(
		[label_name]="Label"
		[label_y]=0
		[label_x]=0
		[placeholder]="Placeholder"
		[input_y]=0
		[input_x]=1
		[field_len]=4
		[input_len]=5
	)

	declare -a items

	for ((i=1; i <= $form_height; i++)); do
		idx=$[ $i - 1 ]
		idx=$[ $idx * ${#item_layout[@]} ]

		items[$idx]=$(setValue "${item_layout[label_name]}$i" $1); shift
		items[$[ $idx + 1 ]]=$(setValue "${item_layout[label_y]}$i" $1); shift
		items[$[ $idx + 2 ]]=$(setValue "${item_layout[label_x]}$i" $1); shift
		items[$[ $idx + 3 ]]=$(setValue "${item_layout[placeholder]}$i" $1); shift
		items[$[ $idx + 4 ]]=$(setValue "${item_layout[input_y]}$i" $1); shift
		items[$[ $idx + 5 ]]=$(setValue "${item_layout[input_x]}$i" $1); shift
		items[$[ $idx + 6 ]]=$(setValue "${item_layout[field_len]}$i" $1); shift
		items[$[ $idx + 7 ]]=$(setValue "${item_layout[input_len]}$i" $1); shift
	done

	DIALOG_ANSWER=$(dialog --form "$text" $height $width $form_height ${items[@]} 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# fselect      <filepath> <height> <width>
dialog_fselect_args=(
	filepath
	height
	width
)

dialog_fselect() {
	filepath=$(setValue "${HOME}" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift

	DIALOG_ANSWER=$(dialog --fselect "$filepath" $height $width 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# gauge        <text> <height> <width> [<percent>]
dialog_gauge_args=(
	text
	height
	width
	percent
)

dialog_gauge() {
	text=$(setValue "Gauge" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	let percent=$(setValue 0 $1); shift

	DIALOG_ANSWER=$(dialog --gauge "$text" $height $width $percent 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# infobox      <text> <height> <width>
dialog_infobox_args=(
	text
	height
	width
)

dialog_infobox() {
	text=$(setValue "Infobox" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift

	DIALOG_ANSWER=$(dialog --infobox "$text" $height $width 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# inputbox     <text> <height> <width> [<init>]
dialog_inputbox_args=(
	text
	height
	width
	init
)

dialog_inputbox() {
	text=$(setValue "Inputbox" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	init=$(setValue "init" $1); shift

	DIALOG_ANSWER=$(dialog --inputbox "$text" $height $width "$init" 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# inputmenu    <text> <height> <width> <menu height> <tag1> <item1>...
dialog_inputmenu_args=(
	text
	height
	width
	menu-height
	tagN
	itemN
)

dialog_inputmenu() {
	text=$(setValue "Inputmenu" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	let menu_height=$(setValue 3 $1); shift

	declare -A item_layout=(
		[tag]="tag"
		[item]="item"
	)

	declare -a items

	for ((i=1; i <= $menu_height; i++)); do
		idx=$[ $i - 1 ]
		idx=$[ $idx * ${#item_layout[@]} ]

		items[$idx]=$(setValue "${item_layout[tag]}$i" $1); shift
		items[$[ $idx + 1 ]]=$(setValue "${item_layout[item]}$i" $1); shift
	done

	DIALOG_ANSWER=$(dialog --inputmenu "$text" $height $width $menu_height ${items[@]} 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# menu         <text> <height> <width> <menu height> <tag1> <item1>...
dialog_menu_args=(
	text
	height
	width
	menu-height
	tagN
	itemN
)

dialog_menu() {
	text=$(setValue "Menu" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	let menu_height=$(setValue 3 $1); shift

	declare -A item_layout=(
		[tag]="tag"
		[item]="item"
	)

	declare -a items

	for ((i=1; i <= $menu_height; i++)); do
		idx=$[ $i - 1 ]
		idx=$[ $idx * ${#item_layout[@]} ]

		items[$idx]=$(setValue "${item_layout[tag]}$i" $1); shift
		items[$[ $idx + 1 ]]=$(setValue "${item_layout[item]}$i" $1); shift
	done

	DIALOG_ANSWER=$(dialog --menu "$text" $height $width $menu_height ${items[@]} 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# mixedform    <text> <height> <width> <form height> <label1> <l_y1> <l_x1> <item1> <i_y1> <i_x1> <flen1> <ilen1> <itype>...
dialog_mixedform_args=(
	text
	height
	width
	form-height
	label_nameN
	label_yN
	label_xN
	placeholderN
	input_yN
	input_xN
	field_lenN
	input_lenN
	input_typeN
)

dialog_mixedform() {
	text=$(setValue "Mixed Form" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	let form_height=$(setValue 3 $1); shift

	declare -A item_layout=(
		[label_name]="Label"
		[label_y]=0
		[label_x]=0
		[placeholder]="Placeholder"
		[input_y]=0
		[input_x]=1
		[field_len]=4
		[input_len]=5
		[input_type]=0
	)

	declare -a items

	for ((i=1; i <= $form_height; i++)); do
		idx=$[ $i - 1 ]
		idx=$[ $idx * ${#item_layout[@]} ]

		items[$idx]=$(setValue "${item_layout[label_name]}$i" $1); shift
		items[$[ $idx + 1 ]]=$(setValue "${item_layout[label_y]}$i" $1); shift
		items[$[ $idx + 2 ]]=$(setValue "${item_layout[label_x]}$i" $1); shift
		items[$[ $idx + 3 ]]=$(setValue "${item_layout[placeholder]}$i" $1); shift
		items[$[ $idx + 4 ]]=$(setValue "${item_layout[input_y]}$i" $1); shift
		items[$[ $idx + 5 ]]=$(setValue "${item_layout[input_x]}$i" $1); shift
		items[$[ $idx + 6 ]]=$(setValue "${item_layout[field_len]}$i" $1); shift
		items[$[ $idx + 7 ]]=$(setValue "${item_layout[input_len]}$i" $1); shift
		items[$[ $idx + 8 ]]=$(setValue "${item_layout[input_type]}$i", $1); shift
	done

	DIALOG_ANSWER=$(dialog --mixedform "$text" $height $width $form_height ${items[@]} 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# mixedgauge   <text> <height> <width> <percent> <tag1> <item1>...
declare -a mgauge_task_queue;
declare -a mgauge_task_id;

export mgauge_task_queue mgauge_task_id

dialog_mixedgauge_args=(
	text
	height
	width
)

dialog_mixedgauge() {
	# 0: success
	# 1: failed
	# 2: passed
	# 3: completed
	# 4: checked
	# 5: done
	# 6: skipped
	# 7: in progress
	# -X: 0-100, progress of process

	# Variables
	text=$(setValue "Mixed Gauge" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	let percent=0
	let process_len=${#mgauge_task_queue[@]}
	let rest_process=$process_len
	
	declare -a task_pid
	declare -a task_out
	declare -a task_stat

	# Process Runner
	for ((i=0; i < $process_len; i++)); do
		task_stat[$i]=0
		task_out[$i]=$(mktemp)
		${mgauge_task_queue[$i]} > ${task_out[$i]} &
		task_pid[$i]=$!
	done

	# Process Observer
	while [ $rest_process -ne 0 ]; do
		task_log=
		percent=0
		task_args=()

		for ((i=0; i < $process_len; i++)); do
			task_log=$(cat ${task_out[$i]} | tail -n 1)
			[ -z "$task_log" ] && task_log=0

			if [ "$task_log" = "100" ]; then
				wait ${task_pid[$i]}
				pstatus=$?
				echo $pstatus >> ${task_out[$i]}
				task_log=$(cat ${task_out[$i]} | tail -n 1)
				task_stat[$i]=1
				: $((rest_process--))
			fi

			if [ "${task_stat[$i]}" = "1" ]; then
				percent=$[ $percent + 100 ]
			else
				percent=$[ $percent + $task_log ]
				task_log="-${task_log}"
			fi

			task_args+=("${mgauge_task_id[$i]}" "${task_log}")
		done

		percent=$[${percent} / ${process_len}]

		dialog --mixedgauge "${text}" $height $width $percent "${task_args[@]}"

		sleep 0.5
	done

	rm ${task_out[@]}

	DIALOG_RETURN=0
}

# msgbox       <text> <height> <width>
dialog_msgbox_args=(
	text
	height
	width
)

dialog_msgbox() {
	text=$(setValue "Message Box" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift

	DIALOG_ANSWER=$(dialog --msgbox "$text" $height $width 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# passwordbox  <text> <height> <width> [<init>]
dialog_passwordbox_args=(
	text
	height
	width
	init
)

dialog_passwordbox() {
	text=$(setValue "Password Box" $1); shift
	let height=$(setValue -1 $1); shift
	let width=$(setValue -1 $1); shift
	init=$(setValue "placeholder" $1)

	DIALOG_ANSWER=$(dialog --passwordbox "$text" $height $width "$init" 2>&1 > /dev/tty)
	DIALOG_RETURN=$?
}

# passwordform <text> <height> <width> <form height> <label1> <l_y1> <l_x1> <item1> <i_y1> <i_x1> <flen1> <ilen1>...
dialog_passwordform_args=(
	text
	height
	width
	form-height
	labelN
	l_yN
	l_xN
	itemN
	i_yN
	i_xN
	flenN
	ilenN
	itypeN
)

dialog_passwordform() {
	DIALOG_ANSWER=0
}

# pause        <text> <height> <width> <seconds>
dialog_pause_args=(
	text
	height
	width
	seconds
)

dialog_pause() {
	DIALOG_ANSWER=0
}

# prgbox       <text> <command> <height> <width>
dialog_prgbox_args=(
	text
	command
	height
	width
)

dialog_prgbox() {
	DIALOG_ANSWER=0
}

# programbox   <text> <height> <width>
dialog_programbox_args=(
	text
	height
	width
)

dialog_programbox() {
	DIALOG_ANSWER=0
}

# progressbox  <text> <height> <width>
dialog_progressbox_args=(
	text
	height
	width
)

dialog_progressbox() {
	DIALOG_ANSWER=0
}

# radiolist    <text> <height> <width> <list height> <tag1> <item1> <status1>...
dialog_radiolist_args=(
	text
	height
	width
	list-height
	tagN
	itemN
	statusN
)

dialog_radiolist() {
	DIALOG_ANSWER=0
}

# rangebox     <text> <height> <width> <min-value> <max-value> <default-value>
dialog_rangebox_args=(
	text
	height
	width
	min-value
	max-value
	default-value
)

dialog_rangebox() {
	DIALOG_ANSWER=0
}

# tailbox      <file> <height> <width>
dialog_tailbox_args=(
	file
	height
	width
)

dialog_tailbox() {
	DIALOG_ANSWER=0
}

# tailboxbg    <file> <height> <width>
dialog_tailboxbg_args=(
	file
	height
	width
)

dialog_tailboxbg() {
	DIALOG_ANSWER=0
}

# textbox      <file> <height> <width>
dialog_textbox_args=(
	file
	height
	width
)

dialog_textbox() {
	DIALOG_ANSWER=0
}

# timebox      <text> <height> <width> <hour> <minute> <second>
dialog_timebox_args=(
	text
	height
	width
	hour
	minute
	second
)

dialog_timebox() {
	DIALOG_ANSWER=0
}

# treeview     <text> <height> <width> <list-height> <tag1> <item1> <status1> <depth1>...
dialog_treeview_args=(
	text
	height
	width
	list-height
	tagN
	itemN
	statusN
	depthN
)

dialog_treeview() {
	DIALOG_ANSWER=0
}

