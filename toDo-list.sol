//SPDX-License-Identifier:MIT

pragma solidity ^0.8.9;

contract todo_list{

    enum Status{Pending, Completed}
    enum Priority{High,Medium,Low,Remove}
    enum Category{work,personal,none}
 

    Task[] public tasks;
        
    struct Task{
        string description;
        Status status;
        Priority priority;
        uint256 dueDate;
        string category;
    }

    event TaskCreated(
        uint256 index,
        string description,
        Priority priority
    );

    //mapping(uint256=>Priority) public priorityValues;
    mapping{uint256=>Category} public categoryValues;
    
    constructor(){
        priorityValues[3]=Priority.Remove;
        priorityValues[0]=Priority.Low;
        priorityValues[1]=Priority.Medium;
        priorityValues[2]=Priority.High;
    }

    function displayTasksAccToPriority() public view returns (Task[] memory) {
        // Copy tasks to a new array for sorting
        Task[] memory sortedTasks = new Task[](tasks.length);
        for (uint256 i = 0; i < tasks.length; i++) {
            sortedTasks[i] = tasks[i];
        }

        // Bubble sort based on priority
        for (uint256 i = 0; i < sortedTasks.length - 1; i++) {
            for (uint256 j = 0; j < sortedTasks.length - i - 1; j++) {
                if (sortedTasks[j].priority > sortedTasks[j + 1].priority) {
                    Task memory temp = sortedTasks[j];
                    sortedTasks[j] = sortedTasks[j + 1];
                    sortedTasks[j + 1] = temp;
                }
            }
        }
        // Filter out tasks with priority set to Remove
        Task[] memory filteredTasks=new Task[](tasks.length);
        uint256 filteredIndex = 0;
        for (uint256 i = 0; i < tasks.length; i++) {
            if (sortedTasks[i].priority != Priority.Remove) {
                filteredTasks[filteredIndex] = sortedTasks[i];
                filteredIndex++; 
            } 
        }

        return filteredTasks;
    }

    function addTask(string memory description, Priority priority,uint256 dueDate,string memory category) public {
        Task memory task = Task({
            description : description, 
            status : Status.Pending, 
            priority : priority,
            dueDate:dueDate,
            category:category
        });
        uint256 index = tasks.length; 
        emit TaskCreated(index, description, priority);
        tasks.push(task);

    }

    function TaskCompleted(uint256 _index) public{
        if(_index < tasks.length){
            tasks[_index].status = Status.Completed;
        }else {
            revert("Index not found"); 
        }

    }

    function removingTask(uint256 _index) public{
        if(_index < tasks.length){ 
            tasks[_index].priority = Priority.Remove; 
         }else {
            revert("Index not found"); 
         }
    }

    function displayTasksAccToCategory(string memory _category) public view returns(Task[] memory){

        
        // Filter out tasks with priority set to Remove
        Task[] memory filteredTasks=new Task[](tasks.length);
        uint256 filteredIndex = 0;
        for (uint256 i = 0; i < tasks.length; i++) {
            if (tasks[i].priority != Priority.Remove) {
                filteredTasks[filteredIndex] = tasks[i];
                filteredTasks[filteredIndex].category=tasks[i].category;
                filteredIndex++; 
            } 
        }
    
         Task[] memory categoryTasks = new Task[](tasks.length);
        uint256 j=0;
        for(uint256 i=0;i<tasks.length;i++){
             if (keccak256(abi.encodePacked(tasks[i].category)) == keccak256(abi.encodePacked(_category))){
            categoryTasks[j]=filteredTasks[i];
            categoryTasks[j].category=filteredTasks[i].category;
            j++;
            }
            
        }
        return categoryTasks;
    }
    function displayTaskaAccToStatus(Status status) public view returns(Task[] memory){
         Task[] memory statusTasks = new Task[](tasks.length);
         uint256 statusIndex=0;
         for(uint256 i=0;i<tasks.length;i++){
            if(tasks[i].status==status)
            statusTasks[statusIndex]=tasks[i];
            statusIndex++;
         }
         return statusTasks;


    }
    


}