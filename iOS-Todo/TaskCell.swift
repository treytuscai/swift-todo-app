//
//  TaskCell.swift
//  iOS-Todo
//
//  Created by Trey Tuscai on 4/4/25.
//

import Foundation
import UIKit

public class TaskCell: UITableViewCell {
    public let nameLabel = UILabel()
    public let categoryLabel = UILabel()
    public let deleteButton = UIButton(type: .system)
    public var onDeleteTapped: (() -> Void)?
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    public func setupUI() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(deleteButton)
        
        deleteButton.setTitle("X", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            categoryLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func deleteTapped() {
        onDeleteTapped?()
    }

    public func configure(with task: TaskEntity) {
        nameLabel.text = task.name
        categoryLabel.text = task.category ?? "Uncategorized"

        let isCompleted = task.completed
        let color: UIColor = isCompleted ? .gray : .label

        nameLabel.textColor = color
        categoryLabel.textColor = color

        let attrText = NSAttributedString(string: task.name ?? "", attributes: [
            .strikethroughStyle: isCompleted ? NSUnderlineStyle.single.rawValue : 0
        ])
        nameLabel.attributedText = attrText
    }
}
