# Linux-homework

Students concerned:
Badr ABRAGH: 117588
Othmane LEMJID: 117605

1. Data Storage:

- All tasks are stored in a text file named 'tasks.txt'.
- The file 'tasks.txt' is created automatically.
- Each task is stored as a single line in the format: id;title;description;location;date;time;completion.
- The id is a unique identifier for each task.
- The completion status is either completed or uncompleted.

2. Code Organization:

The script is divided into functions, each responsible for a specific operation:
- initiation(): Initializes the task file if it doesn't exist.
- is_empty(): Checks if the task file is empty.
- create_task(): Prompts the user to enter details for a new task and appends it to the task file.
- get_id(): Retrieves the last task ID from the task file.
- return_task(): Returns a specific task by its ID.
- display_tasks(): Displays all tasks.
- update_task(): Prompts the user to update a specific task.
- delete_task(): Deletes a specific task by its ID.
- get_task_by_title(): Searches for a task by its title and displays it.
- list_tasks_by_day(): Lists tasks for a specific date, separated by completion status.
- print_task(): Prints the details of a task.
- dashboard(): Main function to display the menu and handle user input.

3. How to Run the Program:

1) Make the Script Executable: chmod +x todo.sh
2) Run the Script (without any arguments): ./todo.sh
3) Using the Program: you will see a menu with different options, enter the number corresponding to the operation you want to perform and follow the prompts.
