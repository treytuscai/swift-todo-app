//
//  AddTaskVC.swift
//  iOS-Todo
//
//  Created by Trey Tuscai on 4/4/25.
//

import Foundation // Provides basic functionality like data types and collections
import UIKit // Required for building user interfaces in iOS apps

// This class controls the add task screen
// Subclass of UIVC: It inherits from UIViewController, which means it has all the built-in features that allow it to manage and display the screen.
public class AddTaskVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField! // Outlet connects the name text field in the storyboard to this class
    @IBOutlet weak var categoryField: UITextField! // Outlet connects the category text field in the storyboard to this class
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Here, we’re again getting the context from Core Data to manage our app’s data. Allows us to interact with Core Data and save our task data to the app’s storage.
    
    // Remember this gets called once when this screen (view controller) is loaded into memory. It’s like a "setup" function — a great place to prepare things before the screen appears.
    public override func viewDidLoad() { // built-in method in UIViewController
        super.viewDidLoad()
    }
    
    // This method gets called when the Add Task button is tapped. The @IBAction keyword links this function to the button in the UI.
    @IBAction func addTaskButton(_ sender: Any) {
        //Here, we’re gonna check if the task name and category fields are filled out. If either field is empty, we stop and don’t proceed further.
        guard let taskName = nameField.text, !taskName.isEmpty,
              let taskCategory = categoryField.text, !taskCategory.isEmpty else {
            // Optionally show an alert if required fields are empty
            return
        }
        // We create a new task using Core Data. TaskEntity is the model for our task, and we’re assigning values to its properties: task name, category, and initial completion status (which is set to false since it's a new task).
        let newTask = TaskEntity(context: self.context)
        newTask.name = taskName
        newTask.category = taskCategory
        newTask.completed = false
        
        // This is the part where we save the new task to Core Data. If saving is successful, we print a success message. If there’s an error (e.g., saving fails), we print an error message.
        do {
            try self.context.save()
            print("Task saved successfully!")
        } catch let error as NSError {
            print("Could not save task: \(error), \(error.userInfo)")
        }
        //After the task is saved, we go back to the previous screen (pop this view controller off the navigation stack). The animated: true means the transition will be smooth and animated.
        self.navigationController?.popViewController(animated: true)
    }
    // In this section, we handle the button tap that lets the user add a new task. First, we check that both fields are filled in. Then, we create a new task, save it to Core Data, and go back to the previous screen. This button allows users to add tasks to the list!
}
