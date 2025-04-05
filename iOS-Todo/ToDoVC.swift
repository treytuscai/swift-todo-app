//
//  ToDoVC.swift
//  iOS-Todo
//
//  Created by Trey Tuscai on 4/4/25.
//

import Foundation
import UIKit
import CoreData

public class ToDoVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var TaskTableView: UITableView!
    public var Tasks: [TaskEntity] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasks"
        TaskTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        TaskTableView.delegate = self
        TaskTableView.dataSource = self
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchTasks()
    }
    
    
    public func fetchTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            Tasks = try context.fetch(fetchRequest)
            TaskTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch tasks: \(error), \(error.userInfo)")
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = Tasks[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = task.name
        config.secondaryText = task.category ?? "Uncategorized" + (task.completed ? " ✅" : "")
        cell.contentConfiguration = config

        return cell
    }
    
}
