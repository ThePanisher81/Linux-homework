#!/bin/bash

# Function to initiate the task file if it doesn't exist
initiation() {
    if [ ! -f tasks.txt ]; then
        touch tasks.txt
    fi
}

# Function to check if the task file is empty
is_empty() {
    if [ ! -s tasks.txt ]; then
        return 0
    else
        return 1
    fi
}

# Function to create a new task
create_task() {
    echo "Enter task information"
    while true; do
        read -p "Title: " title
        if [ -n "$title" ]; then
            break
        else
            echo "The title of the task is required" >&2
        fi
    done

    read -p "Description: " description
    read -p "Location: " location

    while true; do
        read -p "Due date (YYYY-MM-DD): " date
        if [[ $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            break
        else
            echo "Enter a valid date format (YYYY-MM-DD)." >&2
        fi
    done

    read -p "Time: " time

    id=$(($(get_id) + 1))
    echo "$id;$title;$description;$location;$date;$time;uncompleted" >> tasks.txt
    echo "The task was created successfully."
}

# Function to get the last task ID
get_id() {
    if is_empty; then
        echo 0
    else
        tail -n 1 tasks.txt | cut -d ';' -f 1
    fi
}

# Function to return a task by its ID
return_task() {
    local id="$1"
    grep "^$id;" tasks.txt
}

# Function to display all tasks
display_tasks() {
    if is_empty; then
        echo "There is no task yet!!" >&2
    else
        while IFS= read -r line; do
            IFS=';' read -ra task <<< "$line"
            echo "${task[0]}) title: ${task[1]} description: ${task[2]} location: ${task[3]} date: ${task[4]} time: ${task[5]} completion: ${task[6]}"
        done < tasks.txt
    fi
}

# Function to update a task
update_task() {
    if is_empty; then
        echo "There is no task yet!!" >&2
    else
        display_tasks
        read -p "Enter the task number to modify: " task_id
        chosen_task=$(return_task "$task_id")

        while [ -z "$chosen_task" ]; do
            read -p "Enter a valid task number: " task_id
            chosen_task=$(return_task "$task_id")
        done

        echo "Enter new task information"

        while true; do
            read -p "Title: " title
            if [ -n "$title" ]; then
                break
            else
                echo "The title of the task is required" >&2
            fi
        done

        read -p "Description: " description
        read -p "Location: " location

        while true; do
            read -p "Due date (YYYY-MM-DD): " date
            if [[ $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                break
            else
                echo "Enter a valid date format (YYYY-MM-DD)." >&2
            fi
        done

        read -p "Time: " time

        while true; do
            read -p "Is the task completed? (yes or no): " completion
            if [[ "$completion" =~ ^(yes|no)$ ]]; then
                status="uncompleted"
                [ "$completion" == "yes" ] && status="completed"
                break
            fi
        done

        new_line="$task_id;$title;$description;$location;$date;$time;$status"

        sed -i "/^$task_id;/c\\$new_line" tasks.txt
        echo "The task was updated successfully."
    fi
}

# Function to delete a task
delete_task() {
    if is_empty; then
        echo "There is no task yet!!" >&2
    else
        display_tasks
        read -p "Enter the task number to delete: " task_id
        chosen_task=$(return_task "$task_id")

        while [ -z "$chosen_task" ]; do
            read -p "Enter a valid task number: " task_id
            chosen_task=$(return_task "$task_id")
        done

        sed -i "/^$task_id;/d" tasks.txt
        echo "The task was deleted successfully."
    fi
}

# Function to get a task by title
get_task_by_title() {
    read -p "Enter the task title: " title
    task=$(grep ";$title;" tasks.txt)
    if [ -n "$task" ]; then
        IFS=';' read -ra task_info <<< "$task"
        echo "Task ${task_info[0]}:
Title: ${task_info[1]}
Description: ${task_info[2]}
Location: ${task_info[3]}
Date: ${task_info[4]}
Time: ${task_info[5]}
Completion: ${task_info[6]}"
    else
        echo "There is no task with the title: $title" >&2
    fi
}

# Function to list tasks for a specific day
list_tasks_by_day() {
    while true; do
        read -p "Date (YYYY-MM-DD): " date
        if [[ $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            break
        else
            echo "Enter a valid date format (YYYY-MM-DD)." >&2
        fi
    done

    completed_tasks=$(grep ";$date;.*;completed" tasks.txt)
    uncompleted_tasks=$(grep ";$date;.*;uncompleted" tasks.txt)

    echo "Completed Tasks:"
    if [ -n "$completed_tasks" ]; then
        while IFS= read -r task; do
            print_task "$task"
        done <<< "$completed_tasks"
    else
        echo "No completed tasks for this date."
    fi

    echo "Uncompleted Tasks:"
    if [ -n "$uncompleted_tasks" ]; then
        while IFS= read -r task; do
            print_task "$task"
        done <<< "$uncompleted_tasks"
    else
        echo "No uncompleted tasks for this date."
    fi
}

# Function to print a task's details
print_task() {
    IFS=';' read -ra task <<< "$1"
    echo "Task ${task[0]}:
title: ${task[1]}
description: ${task[2]}
location: ${task[3]}
date: ${task[4]}
time: ${task[5]}
completion: ${task[6]}"
}

# Main Todo function
dashboard() {
    local choice
    while true; do
        echo "0) Exit."
        echo "1) Show all tasks."
        echo "2) Create a task."
        echo "3) Update a task."
        echo "4) Delete a task."
        echo "5) Search for a task by title."
        echo "6) List a day's tasks."
        read -p "Select a valid option: " choice

        case $choice in
            0) exit ;;
            1) display_tasks ;;
            2) create_task ;;
            3) update_task ;;
            4) delete_task ;;
            5) get_task_by_title ;;
            6) list_tasks_by_day ;;
            *) echo "Select a valid option." >&2 ;;
        esac
    done
}

# Initiating the task file and starting the dashboard
initiation
dashboard
