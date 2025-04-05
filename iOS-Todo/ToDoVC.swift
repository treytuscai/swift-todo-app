//
//  ToDoVC.swift
//  iOS-Todo
//
//  Created by Trey Tuscai on 4/4/25.
//

import Foundation // Provides basic functionality like data types and collections
import UIKit // Required for building user interfaces in iOS apps
import CoreData // Used for managing the app’s data model and persistent storage. Core Data isn’t a database itself. It’s a tool Apple gives us to manage app data as Swift objects.

// This class controls the main to-do list screen
// Object manages a view hierarchy, mananges the table view, provides data and cells to our table view
// Subclass of UIVC: can use all the functionality
// Conforms to UITable: these are protocols that ToDoVC has agreed to implement.
public class ToDoVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var TaskTableView: UITableView! // Outlet connects the table view in the storyboard to this class
    public var Tasks: [TaskEntity] = [] // This array holds the list of tasks fetched from Core Data
    
    /*1. UIApplication.shared: Refers to the singleton instance of your running app. This is how you access global app-level properties and behavior.
      2. .delegate: The delegate is an object that conforms to the UIApplicationDelegate protocol. In your project, this is your AppDelegate.swift file. So this gives you access to anything defined in AppDelegate. The AppDelegate is the behind-the-scenes organizer. It runs first, sets up things like the database and notifications, and keeps the app responding to system events like launching, going to sleep, or waking up.
      3. as! AppDelegate: You're force-casting the generic delegate to your specific AppDelegate class. It tells Swift: "Trust me, I know this is an AppDelegate." If it's not (which is unlikely in this case), the app will crash.
      4. .persistentContainer. This is the Core Data stack object in AppDelegate. It manages loading the data model and gives access to the context.
      5. .viewContext This is the actual NSManagedObjectContext.It's the main thread context used for reading and writing Core Data objects.
     */
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // This is a special method that gets called once when this screen (view controller) is loaded into memory. It’s like a "setup" function — a great place to prepare things before the screen appears.
    public override func viewDidLoad() {
        super.viewDidLoad() // This calls the original version of viewDidLoad from UIViewController. You always call this first to make sure the system does its own setup too.
        self.title = "Tasks" // This sets the navigation bar title at the top of the screen. So it will say tasks at the top of the screen.
        TaskTableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell") // This tells the table view: “Here’s the kind of cell I want you to use when displaying each task. We give it a cell class (TaskCell) and a reuse identifier (a name to match later when we want to show the cell).
        TaskTableView.delegate = self // This class (our ToDoVC) will handle things like what happens when a row is tapped.
        TaskTableView.dataSource = self // This class will provide the data (tasks) to show in the table view — like how many rows, and what each one should look like.
    }
    /* This code runs when the screen first loads. It sets the title, tells the table how to display our custom task cells, and says "Hey, I’ll be in charge of giving you data and handling user interaction." It’s like setting up the table before dinner — this is where we prepare everything before the user sees the screen. */
    
    // This is another special method from UIViewController. It gets called every time the screen fully appears on the device (even after coming back from another screen).
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // Just like with viewDidLoad, we call the parent’s version of this method to make sure the system handles any necessary behavior.
        self.fetchTasks() //Now that the screen is showing, go get the list of saved tasks from Core Data.
    }
    // Why not do this in viewDidLoad? Because maybe the tasks changed while the user was on a different screen — so we refresh every time the view appears.
    // When the screen appears, we call fetchTasks() to get our saved to-dos from Core Data. If it works, we reload the table so it shows the latest tasks. If it fails, we print an error. This way, the app always shows up-to-date tasks whenever the user opens this screen.
    
    // This function grabs all the tasks we’ve saved in our Core Data database.
    public func fetchTasks() {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest() // We're creating a request to ask Core Data: “Please give me all the saved TaskEntity objects.” Think of it like writing a search query, but in Swift instead of SQL.
        
        do { // We're running the request, and trying to fetch the data. If it works, we save the result to our Tasks array — which is what the table view uses to show your to-dos.
            Tasks = try self.context.fetch(fetchRequest)
            TaskTableView.reloadData() //“Hey! We got new data — refresh yourself and show it!”
        } catch let error as NSError {
            print("Could not fetch tasks: \(error), \(error.userInfo)") // If something goes wrong (maybe the database is corrupt), we catch the error and print it. do-catch is Swift’s way of safely trying something that could fail.
        }
    }
    
    //This method tells the table view how many rows (items) it needs to show in the table.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tasks.count //The answer is the number of tasks we have, so we return the count of the Tasks array. like len or length
    }
    
    // This method is responsible for creating or reusing a table view cell for each row in the table.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Here’s where you create the cell for each row. If there’s a reusable cell already waiting (for performance reasons), reuse it. If not, create a new one.
        //This method reuses cells that are no longer visible to improve performance. If it can’t reuse a cell, it creates a new one of type TaskCell. If we can't cast as type task cell we will use the default cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }

        //This part assigns the correct task to the cell. It’s basically telling the cell: Here’s the task you should display.
        let task = Tasks[indexPath.row]
        cell.configure(with: task) // passes the task data (like title, description, etc.) to the TaskCell.

        //This block of code handles when the user taps the delete button on a task cell.
        //When the delete button is tapped on a cell, we want to delete that task from Core Data and update the table.
        cell.onDeleteTapped = {
            self.context.delete(task) // Deletes the task from Core Data.
            self.Tasks.remove(at: indexPath.row) // Removes the task from the local Tasks array.
            try? self.context.save() // Saves the changes to Core Data (making sure the data is persistent).
            self.TaskTableView.deleteRows(at: [indexPath], with: .automatic) //Removes the deleted row from the table view with an animated deletion.
        }

        return cell // This returns the final cell to the table view for display.
    }
    
    // This method is triggered when the user taps on a row in the table view. It’s used to mark a task as completed or not completed.
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //When a user taps a task, I toggle its completed status and save the change.
        let task = Tasks[indexPath.row]
        task.completed.toggle() // Flips the completed status of the task (if it was incomplete, it becomes complete and vice versa).
        try? self.context.save() // Saves the updated task in Core Data.
        tableView.reloadRows(at: [indexPath], with: .automatic) //Refreshes the specific row so the change (like a checked-off task) appears on the screen.
    }
    /*These are table view delegate methods that handle displaying, deleting, and updating tasks. We get the data from Core Data and use it to fill the rows. When you delete a task, we remove it from the table and database. When you tap on a task, it toggles between 'completed' and 'not completed', and the table is updated right away.*/
    
}
