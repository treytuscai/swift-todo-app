//
//  TaskCell.swift
//  iOS-Todo
//
//  Created by Trey Tuscai on 4/4/25.
//

import Foundation // Provides basic functionality like data types and collections
import UIKit // Required for building user interfaces in iOS apps

// This class represents the custom table view cell for displaying a task
// It controls how each task appears in the task list (name, category, and delete button)
public class TaskCell: UITableViewCell {
    
    // UI elements: labels for name and category of the task, and a delete button
    public let nameLabel = UILabel()
    public let categoryLabel = UILabel()
    public let deleteButton = UIButton(type: .system)
    
    // Closure property to handle delete button action (callback function). A closure in Swift is a block of code that can be passed around and executed later.
    /*() means it takes no parameters. So this closure (a function or block of code) does not accept any input values.
    
    Void means it returns nothing, or "void." So this closure is used for performing an action, but it doesn't return any value.

    The ? at the end means this is an optional closure. This means that the closure can be nil, meaning no action is set, or it can hold a function (closure) to be executed later. If onDeleteTapped is nil, nothing will happen when it's called. It's used to decouple the delete logic from the TaskCell class, allowing other classes (like the view controller) to define what should happen when the button is pressed.*/
    public var onDeleteTapped: (() -> Void)?
    
    // Initializer for creating the cell programmatically
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI() // Setup the user interface components
    }
    
    // Required initializer for decoding the cell from a storyboard
    // initializer is required even if you're creating everything programmatically
    /*in a context where the table view might be using a storyboard or nib to initialize the cell (like when the app is built with a mix of programmatic views and storyboards), UIKit needs a way to "decode" the view from that interface.*/
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI() // Setup the user interface components
    }
    
    // Function to setup the UI elements (labels and button) inside the cell
    public func setupUI() {
        // Disable automatic constraints and set up manual constraints
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the UI elements to the cell's content view
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(deleteButton)
        
        // Configure the delete button's title and appearance
        deleteButton.setTitle("X", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        // Add action for the delete button to trigger the deleteTapped method
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        // Activate layout constraints for the UI elements
        NSLayoutConstraint.activate([
            // Position name label to the left with padding
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            // Position category label below the name label with padding
            categoryLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Position delete button to the right side of the cell
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // This method is called when the delete button is tapped
    @objc private func deleteTapped() {
        onDeleteTapped?() // Trigger the callback if it's set
    }

    // This method configures the cell with task data
    public func configure(with task: TaskEntity) {
        // Set the name and category text
        nameLabel.text = task.name
        categoryLabel.text = task.category ?? "Uncategorized"

        // Set the text color based on whether the task is completed or not
        let isCompleted = task.completed
        let color: UIColor = isCompleted ? .gray : .label
        nameLabel.textColor = color
        categoryLabel.textColor = color

        // Apply strikethrough style to the task name if completed
        let attrText = NSAttributedString(string: task.name ?? "", attributes: [
            .strikethroughStyle: isCompleted ? NSUnderlineStyle.single.rawValue : 0
        ])
        nameLabel.attributedText = attrText
    }
}
