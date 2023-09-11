import { LightningElement, track } from 'lwc';

export default class TodoManager extends LightningElement {
    timeValue = '8:15 AM';
    greeting = 'Good Evening';

    //reactive list property to hold todo items
    @track todos = [];

    renderedCallback() {
        this.updateTime();
        setInterval(() => {
            this.updateTime();
        }, 1000*60);
        
    }

    updateTime() {
        const currentHour = new Date().getHours();

        if (currentHour >= 0 && currentHour < 12) {
            this.greeting = 'Good Morning';
        } else if (currentHour >= 12 && currentHour < 18) {
            this.greeting = 'Good Afternoon';
        } else {
            this.greeting = 'Good Evening';
        }
        
        let currentTime = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        this.timeValue = currentTime;
    }

    addTodoHandler(){
        const inputBox = this.template.querySelector('lightning-input');

        const todo = {
            todoId: this.todos.length,
            todoName: inputBox.value,
            done: false,
            todoDate: new Date()
        }

        this.todos.push(todo);
        inputBox.value = "";
    }

    get upcomingTasks(){
        return this.todos && this.todos.length 
            ? this.todos.filter( todo =>  !todo.done) 
            : [];
    }

    get completedTasks(){
        return this.todos && this.todos.length 
            ? this.todos.filter( todo =>  todo.done) 
            : [];
    } 

    /*populateTodos(){
        const todos = [
            {
                todoId: 0,
                todoName: "Feed the dog",
                done: false,
                todoDate: new Date()
            },
            {
                todoId: 1,
                todoName: "Wash the car",
                done: false,
                todoDate: new Date()
            },
            {
                todoId: 2,
                todoName: "Send email to manager",
                done: true,
                todoDate: new Date()
            }
        ];
        this.todos = todos;
    }*/
}