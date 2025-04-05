//
//  AddTaskVC.swift
//  iOS-Todo
//
//  Created by Trey Tuscai on 4/4/25.
//

import Foundation
import UIKit

public class AddTaskVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addTaskButton(_ sender: Any) {
        guard let taskName = nameField.text, !taskName.isEmpty,
              let taskCategory = categoryField.text, !taskCategory.isEmpty else {
            // Optionally show an alert if required fields are empty
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newTask = TaskEntity(context: context)
        newTask.name = taskName
        newTask.category = taskCategory
        newTask.completed = false
        
        do {
            try context.save()
            print("Task saved successfully!")
        } catch let error as NSError {
            print("Could not save task: \(error), \(error.userInfo)")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
