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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasks"
        TaskTableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        TaskTableView.delegate = self
        TaskTableView.dataSource = self
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchTasks()
    }
    
    
    public func fetchTasks() {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            Tasks = try self.context.fetch(fetchRequest)
            TaskTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch tasks: \(error), \(error.userInfo)")
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }

        let task = Tasks[indexPath.row]
        cell.configure(with: task)

        cell.onDeleteTapped = {
            self.context.delete(task)
            self.Tasks.remove(at: indexPath.row)
            try? self.context.save()
            self.TaskTableView.deleteRows(at: [indexPath], with: .automatic)
        }

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = Tasks[indexPath.row]
        task.completed.toggle()
        try? self.context.save()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
